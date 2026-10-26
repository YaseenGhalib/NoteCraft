import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/notes_controller.dart';
import './add_note_page.dart';

import 'widgets/home__elements_cards/search_bar_widget.dart';
import 'widgets/home__elements_cards/note_card_widget.dart';
import 'widgets/home__elements_cards/empty_notes_widget.dart';
import 'widgets/home__elements_cards/no_search_results_widget.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ممارسة بيج تيك: جلب الـ Controller بدون التسمع (listen: false)
    // لتمريره بشكل معزول لشريط البحث وحماية كفاءة الـ Rebuilds
    final notesController = Provider.of<NotesController>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'NoteCraft',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            SizedBox(height: 2),
            Text(
              'حرفية الملاحظات',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          //  كفاءة معمارية: معزول خارج الـ Consumer لمنع الـ Lag أثناء كتابة الحروف
          SearchBarWidget(controller: notesController),

          Expanded(
            child: Consumer<NotesController>(
              builder: (context, controller, child) {
                // 1. حالة خلو التطبيق من أي ملاحظات نهائياً
                if (controller.notes.isEmpty) {
                  return const EmptyNotesWidget();
                }

                // 2. حالة وجود ملاحظات ولكن تصفية البحث لم تجد نتائج matching
                if (controller.filteredNotes.isEmpty) {
                  return const NoSearchResultsWidget();
                }

                // 3. حالة عرض البيانات بعد التحقق بنجاح من سلامة القوائم
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.80,
                  ),
                  itemCount: controller.filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = controller.filteredNotes[index];
                    return NoteCardWidget(note: note, controller: controller);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNotes()),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

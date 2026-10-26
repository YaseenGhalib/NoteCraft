import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import '../controllers/notes_controller.dart';
import '../models/note_model.dart';
import 'widgets/edit_note/date_update_selector_widget.dart';
import 'widgets/common_general_elements/image_picker_options_sheet.dart'; // الملف الاحترافي الموحد الجديد
import 'widgets/edit_note/edit_note_fields_widget.dart';
import 'widgets/edit_note/edit_note_image_widget.dart';

class EditNotePage extends StatefulWidget {
  final NoteModel note;

  const EditNotePage({super.key, required this.note});

  @override
  State<EditNotePage> createState() => EditNotePageState();
}

class EditNotePageState extends State<EditNotePage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  DateTime? selectedCustomDate;

  void handleInit() {
    titleController = TextEditingController(text: widget.note.title);
    contentController = TextEditingController(text: widget.note.content);

    if (widget.note.imagePath != null && widget.note.imagePath!.isNotEmpty) {
      selectedImage = File(widget.note.imagePath!);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedCustomDate = widget.note.date;
    handleInit();
  }

  // دالة التقاط الصورة - تم إزالة الـ Pop لحل الـ Bug وحمايتها بـ try-catch
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error updating note image: $e");
    }
  }

  void showImageOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // لإظهار جمال الحواف الدائرية للـ Sheet الجديد
      builder: (context) =>
          ImagePickerOptionsSheet(onImagePick: (source) => pickImage(source)),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesController = Provider.of<NotesController>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('تعديل الملاحظة'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. حقول النصوص المستخرجة بنظافة
            EditNoteFieldsWidget(
              titleController: titleController,
              contentController: contentController,
            ),
            const SizedBox(height: 16),

            // 2. واجهة الصورة المستخرجة بنظافة
            EditNoteImageWidget(
              selectedImage: selectedImage,
              onPickImage: showImageOptions,
            ),
            const SizedBox(height: 16),

            // 3. منتقي التاريخ والوقت الثلاثي
            DateUpdateSelectorWidget(
              originalDate: widget.note.date,
              onDateChanged: (newDate) {
                selectedCustomDate = newDate;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.black,
        onPressed: () async {
          final title = titleController.text.trim();
          final content = contentController.text.trim();

          if (title.isNotEmpty || content.isNotEmpty) {
            await notesController.updateNote(
              note: widget.note,
              newTitle: title,
              newContent: content,
              newImagePath: selectedImage?.path,
              customDate: selectedCustomDate,
            );
            if (!context.mounted) return;
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('لا يمكن ترك الملاحظة فارغة!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        label: const Text(
          'تحديث الملاحظة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.update),
      ),
    );
  }
}

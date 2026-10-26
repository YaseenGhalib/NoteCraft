import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//  استخدام الاستيراد المطلق الصارم لتأمين الروابط وحل كافة أخطاء النظام
import 'package:aflutter_apps/controllers/notes_controller.dart';
import 'package:aflutter_apps/models/note_model.dart';
import 'package:aflutter_apps/views/edit_note_page.dart';

import './delete_confirmation_dialog.dart'; // هذا يبقى نسبياً لأنه في نفس المجلد الحالي تماماً

class NoteCardWidget extends StatelessWidget {
  final NoteModel note;
  final NotesController controller;

  const NoteCardWidget({
    super.key,
    required this.note,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('MMM d, yyyy - hh:mm a')
        .format(note.date);

    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => const DeleteConfirmationDialog(),
        );
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        controller.deleteNote(note);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف الملاحظة بنجاح'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditNotePage(note: note)),
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFF1E1E1E),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note.imagePath != null && note.imagePath!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(note.imagePath!),
                      width: double.infinity,
                      height: 70,
                      fit: BoxFit.cover,
                      cacheWidth: 200, // حماية الذاكرة العشوائية RAM
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 70,
                          width: double.infinity,
                          color: Colors.black26,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  note.title.isEmpty ? 'بدون عنوان' : note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amberAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note.content,
                  maxLines:
                      (note.imagePath != null && note.imagePath!.isNotEmpty)
                      ? 2
                      : 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.2,
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

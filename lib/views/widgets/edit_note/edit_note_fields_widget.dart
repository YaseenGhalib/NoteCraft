import 'package:flutter/material.dart';

class EditNoteFieldsWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;

  const EditNoteFieldsWidget({
    super.key,
    required this.titleController,
    required this.contentController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
          ),
          decoration: const InputDecoration(
            hintText: 'العنوان',
            border: InputBorder.none,
          ),
        ),
        const Divider(color: Colors.grey, height: 20),
        TextField(
          controller: contentController,
          maxLines: null, // يسمح للنص بالتمدد لأسفل بحرية
          style: const TextStyle(fontSize: 16, color: Colors.white70),
          decoration: const InputDecoration(
            hintText: 'اكتب ملاحظتك هنا...',
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }
}

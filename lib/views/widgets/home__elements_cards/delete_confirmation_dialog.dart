import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تأكيد الحذف'),
      content: const Text('هل أنت متأكد من رغبتك في حذف هذه الملاحظة؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('حذف', style: TextStyle(color: Colors.redAccent)),
        ),
      ],
    );
  }
}

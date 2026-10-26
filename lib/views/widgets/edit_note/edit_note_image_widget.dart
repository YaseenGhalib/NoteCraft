import 'dart:io';

import 'package:flutter/material.dart';

class EditNoteImageWidget extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onPickImage;

  const EditNoteImageWidget({
    super.key,
    required this.selectedImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedImage != null) {
      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          // تم استبدال Container(decoration) بـ ClipRRect + Image.file
          // لتطبيق خاصية cacheHeight السحرية لحماية الذاكرة العشوائية RAM
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              selectedImage!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              cacheHeight:
                  400, // رندرة الصورة بدقة مخصصة تناسب حجم الارتفاع الفعلي فقط
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.amberAccent,
              child: IconButton(
                icon: const Icon(Icons.edit_rounded, color: Colors.black),
                onPressed: onPickImage,
              ),
            ),
          ),
        ],
      );
    } else {
      return OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.amberAccent,
          side: const BorderSide(color: Colors.amberAccent),
          minimumSize: const Size(
            double.infinity,
            48,
          ), // جعل الزر ممتداً بكامل العرض لتسهيل النقر
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPickImage,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('إضافة صورة للملاحظة'),
      );
    }
  }
}

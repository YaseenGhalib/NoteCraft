//عرض معاينة الصورة الملتقطة
import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final File imageFile;

  const ImagePreviewWidget({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover),
      ),
    );
  }
}

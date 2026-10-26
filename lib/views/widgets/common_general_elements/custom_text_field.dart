import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle? style;
  final int? maxLines;
  final bool expands;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.style,
    this.maxLines,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: expands ? null : maxLines,
      expands: expands,
      textAlignVertical: expands ? TextAlignVertical.top : null,
      style: style ?? const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38),
        border: InputBorder.none,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }
}

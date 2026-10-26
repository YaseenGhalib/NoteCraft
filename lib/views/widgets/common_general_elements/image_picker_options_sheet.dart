import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerOptionsSheet extends StatelessWidget {
  final Function(ImageSource) onImagePick;

  const ImagePickerOptionsSheet({super.key, required this.onImagePick});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Material(
        color: theme.colorScheme.surface, // تمرير اللون الأساسي هنا برمجياً
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(
                      alpha: 0.3,
                    ), // التحديث الحديث لعام 2026
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                "اختيار مصدر الصورة",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.amber),
                title: const Text(
                  "من معرض الصور (Gallery)",
                  style: TextStyle(fontSize: 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onImagePick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.amber),
                title: const Text(
                  "من الكاميرا (Camera)",
                  style: TextStyle(fontSize: 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onImagePick(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import '../controllers/notes_controller.dart';
import 'widgets/common_general_elements/image_preview_widget.dart';
// استيراد الـ Sheet الاحترافي الموحد الجديد بالاسم المحدث
import 'widgets/common_general_elements/image_picker_options_sheet.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  // استخدام الـ GlobalKey للتحقق من المدخلات (ممارسة معيارية في الشركات الكبرى)
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  // دالة التقاط الصورة - تم إزالة الـ Navigator.pop المتكرر لحل الـ Bug
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
      // ممارسة بيج تيك: معالجة الأخطاء في حال رفض المستخدم إعطاء صلاحية الكاميرا
      debugPrint("Error picking image: $e");
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void showBottomSheetOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // تضمن ظهور الحواف الدائرية للـ Sheet الجديد
      builder: (context) {
        // استدعاء الـ Sheet الموحد والمطور الجديد
        return ImagePickerOptionsSheet(
          onImagePick: (source) => pickImage(source),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesController = Provider.of<NotesController>(
      context,
      listen: false,
    );
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Note')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey, // ربط حقول الإدخال بالـ Key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // تمديد العناصر تلقائياً لتناسق المظهر
            children: [
              TextFormField(
                controller: titleController,
                maxLength: 30,
                // إزالة الألوان الثابتة يدوياً والاعتماد على ثيم التطبيق ليتناسق الـ Dark Mode تلقائياً
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "عنوان الملاحظة",
                  prefixIcon: Icon(Icons.note, color: Colors.amber),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contentController,
                minLines: 4,
                maxLines: 8,
                maxLength: 500, // رفع الحد الأقصى قليلاً لراحة المستخدم
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "الملاحظة",
                  prefixIcon: Icon(Icons.description, color: Colors.amber),
                ),
              ),
              const SizedBox(height: 16),

              // عرض المعاينة للصورة
              if (selectedImage != null) ...[
                ImagePreviewWidget(imageFile: selectedImage!),
                const SizedBox(height: 16),
              ],

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: showBottomSheetOptions,
                icon: const Icon(Icons.image),
                label: const Text("Add image for note"),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  final title = titleController.text.trim();
                  final content = contentController.text.trim();

                  if (title.isNotEmpty || content.isNotEmpty) {
                    await notesController.addNote(
                      title,
                      content,
                      imagePath: selectedImage?.path,
                    );
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('لا يمكن حفظ ملاحظة فارغة!'),
                        behavior: SnackBarBehavior
                            .floating, // شكل عائم واحترافي للـ SnackBar
                      ),
                    );
                  }
                },
                child: const Text(
                  "Add note",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

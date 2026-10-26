import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/note_model.dart';

class NotesController extends ChangeNotifier {
  // فتح الصندوق الخاص بقاعدة بيانات Hive
  final _notesBox = Hive.box<NoteModel>('notes_box');

  List<NoteModel> notes = []; // القائمة الأصلية المخزنة في الذاكرة (RAM)
  List<NoteModel> filteredNotes = []; // القائمة المصفاة للبحث والعرض في الواجهة

  String searchQuery = ''; // نص البحث الحالي

  // جلب البيانات وتطبيق الفرز والترتيب التلقائي (تُستدعى مرة واحدة فقط عند تشغيل التطبيق)
  void loadNotes() {
    notes = _notesBox.values.toList();
    applyFilter();
  }

  // دالة تحديث نص البحث وتصفية القائمة لحظياً
  void searchNotes(String query) {
    searchQuery = query.trim().toLowerCase();
    applyFilter();
  }

  // منطق التصفية الداخلي والترتيب الزمني (الأحدث أولاً)
  void applyFilter() {
    if (searchQuery.isEmpty) {
      filteredNotes = List.from(notes);
    } else {
      filteredNotes = notes.where((note) {
        final titleMatch = note.title.toLowerCase().contains(searchQuery);
        final contentMatch = note.content.toLowerCase().contains(searchQuery);
        return titleMatch || contentMatch;
      }).toList();
    }

    // ترتيب الملاحظات دائماً من الأحدث إلى الأقدم بناءً على التاريخ
    filteredNotes.sort((a, b) => b.date.compareTo(a.date));

    notifyListeners(); // تحديث الواجهات فوراً
  }

  //  دالة إضافة ملاحظة جديدة (تم تحسين الأداء)
  Future<void> addNote(
    String title,
    String content, {
    String? imagePath,
  }) async {
    // الاعتماد على التوقيت مع الميكروثانية لتقليل احتمالية تكرار المعرف
    final newNote = NoteModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      content: content,
      date: DateTime.now(),
      imagePath: imagePath,
    );

    await _notesBox.add(newNote); // الحفظ في قاعدة البيانات

    // التحديث الذكي: أضف الملاحظة للقائمة في الذاكرة مباشرة دون إعادة قراءة الملف بالكامل
    notes.add(newNote);
    applyFilter();
  }

  // دالة التعديل الذكية (تم تحسين الأداء)
  Future<void> updateNote({
    required NoteModel note,
    required String newTitle,
    required String newContent,
    String? newImagePath,
    DateTime? customDate,
  }) async {
    note.title = newTitle;
    note.content = newContent;

    if (newImagePath != null) {
      note.imagePath = newImagePath;
    }

    if (customDate != null) {
      note.date = customDate;
    }

    await note.save(); // حفظ التعديلات داخل كائن الملاحظة في Hive

    // التحديث الذكي: الملاحظة تم تعديلها بالفعل في الذاكرة لأنها تمرر كـ Reference
    // كل ما نحتاجه هو إعادة تطبيق الفرز والترتيب في حال تغير التاريخ أو النص
    applyFilter();
  }

  // دالة حذف ملاحظة مباشرة (تم تحسين الأداء)
  Future<void> deleteNote(NoteModel note) async {
    await note.delete(); // الحذف المباشر عبر HiveObject

    // التحديث الذكي: احذفها من القائمة في الذاكرة فوراً دون إعادة قراءة قاعدة البيانات
    notes.remove(note);
    applyFilter();
  }
}

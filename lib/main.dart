import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider/provider.dart';

import 'models/note_model.dart';

import 'controllers/notes_controller.dart';
import 'views/notes_page.dart';

void main() async {
  // تأمين تهيئة إضافات فلاتر قبل انطلاق التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة قاعدة البيانات المحلية Hive
  await Hive.initFlutter();

  // تسجيل المهايئ الخاص بالملاحظات (الذي سيتم توليده بعد قليل)
  Hive.registerAdapter(NoteModelAdapter());

  // فتح صندوق حفظ البيانات
  await Hive.openBox<NoteModel>('notes_box');

  runApp(
    // حقن الكنترولر في أعلى شجرة التطبيق وجلب البيانات تلقائياً
    ChangeNotifierProvider(
      create: (context) => NotesController()..loadNotes(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteCraft MVC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        // scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1F1F1F)),
      ),
      home: const NotesPage(),
    );
  }
}

//هذا هو الكائن المسؤول عن شكل ونوع البيانات المخزنة في قاعدة البيانات
import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String content;

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  String? imagePath;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.imagePath,
  });
}

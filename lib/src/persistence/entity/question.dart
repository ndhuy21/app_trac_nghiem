import 'package:floor/floor.dart';

@entity
class Question {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String? label;
  final String content;

  Question({
    this.id,
    this.label,
    required this.content,
  });
}

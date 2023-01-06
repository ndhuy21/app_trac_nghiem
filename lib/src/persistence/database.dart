import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/question_dao.dart';
import 'entity/question.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Question])
abstract class AppDatabase extends FloorDatabase {
  QuestionDao get questionDao;
}

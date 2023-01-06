import 'package:app_trac_nghiem/src/persistence/entity/question.dart';
import 'package:floor/floor.dart';

@dao
abstract class QuestionDao {
  @insert
  Future<List<int>> inserQuestion(List<Question> question);

  @Query('SELECT * FROM Question')
  Future<List<Question>> retrieveQuestions();

  @Query('DELETE FROM Question WHERE id = :id')
  Future<Question?> deleteQuestion(int id);
}

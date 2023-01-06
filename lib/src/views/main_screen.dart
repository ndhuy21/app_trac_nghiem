import 'package:app_trac_nghiem/src/persistence/database.dart';
import 'package:app_trac_nghiem/src/persistence/entity/question.dart';
import 'package:app_trac_nghiem/src/views/add_question_screen.dart';
import 'package:app_trac_nghiem/src/views/pick_questions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AppDatabase? database = null;

  void getDatabase() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    setState(() {});
  }

  Future<List<Question>> getQuestions() async {
    final questions = await database?.questionDao.retrieveQuestions() ?? [];
    return questions;
  }

  @override
  void initState() {
    getDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: database == null
              ? const CupertinoActivityIndicator()
              : Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddQuestionScreen(
                              onAddQuestionScreen: (content, label) async {
                                await database?.questionDao.inserQuestion([
                                  Question(
                                    content: content,
                                    label: label,
                                  )
                                ]);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text("Tạo câu hỏi"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PickQuestionsScreen(
                              getQuestions: getQuestions,
                            ),
                          ),
                        );
                      },
                      child: const Text("Chọn câu hỏi"),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

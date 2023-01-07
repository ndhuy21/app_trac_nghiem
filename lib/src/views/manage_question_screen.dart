import 'package:app_trac_nghiem/src/components/question_card.dart';
import 'package:app_trac_nghiem/src/persistence/entity/question.dart';
import 'package:app_trac_nghiem/src/views/add_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';

class ManageQuestionScreen extends StatefulWidget {
  const ManageQuestionScreen({
    Key? key,
    required this.getQuestions,
    required this.onAddQuestion,
    required this.onDeleteQuestion,
  }) : super(key: key);

  final Function() getQuestions;
  final Function(String content, String label) onAddQuestion;
  final Function(int id) onDeleteQuestion;

  @override
  State<ManageQuestionScreen> createState() => _ManageQuestionScreenState();
}

class _ManageQuestionScreenState extends State<ManageQuestionScreen> {
  List<Question>? questions = null;

  void loadQuestions() async {
    questions = await widget.getQuestions();
    setState(() {});
  }

  @override
  void initState() {
    loadQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý câu hỏi'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade600,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddQuestionScreen(
                          onAddQuestionScreen: (content, label) {
                            widget.onAddQuestion(content, label);
                          },
                        ),
                      ),
                    );
                    loadQuestions();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Thêm câu hỏi mới",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Boxicons.bxs_plus_circle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (questions != null)
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: QuestionCard(
                      question: questions![index],
                      onDelete: () {
                        widget.onDeleteQuestion(questions![index].id ?? -1);
                        questions!.removeAt(index);
                        setState(() {});
                      },
                    ),
                  );
                }, childCount: questions!.length),
              ),
          ],
        ),
      ),
    );
  }
}

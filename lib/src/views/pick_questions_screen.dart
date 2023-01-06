import 'package:app_trac_nghiem/src/components/pick_question_label.dart';
import 'package:app_trac_nghiem/src/components/question_card.dart';
import 'package:app_trac_nghiem/src/persistence/entity/question.dart';
import 'package:app_trac_nghiem/src/views/create_test_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickQuestionsScreen extends StatefulWidget {
  const PickQuestionsScreen({Key? key, required this.getQuestions})
      : super(key: key);

  final Function() getQuestions;

  @override
  State<PickQuestionsScreen> createState() => _PickQuestionsScreenState();
}

class _PickQuestionsScreenState extends State<PickQuestionsScreen> {
  List<Question>? questions = null;
  List<int> selectedQuestionIds = [];

  String label = "Tất cả";

  void loadQuestions() async {
    questions = await widget.getQuestions();
    setState(() {});
  }

  void applyQuestionFilter(String label) async {
    setState(() {
      questions = null;
    });
    questions = await widget.getQuestions();
    questions = questions
        ?.where((question) => label == "Tất cả" || question.label == label)
        .toList();
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
      appBar: AppBar(title: const Text("Chọn câu hỏi")),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.blue.shade100,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Bạn đã chọn " +
                        selectedQuestionIds.length.toString() +
                        " câu hỏi",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final pickedQuestions = questions!
                        .where((question) =>
                            selectedQuestionIds.contains(question.id))
                        .toList();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTestScreen(
                          questions: pickedQuestions,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: selectedQuestionIds.isNotEmpty
                        ? Colors.blueAccent
                        : Colors.grey,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 28),
                  ),
                  child: const Text(
                    "Tạo đề",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PickQuestionLabel(
                      label: label,
                      questionLabels: const [
                        "Tất cả",
                        "Cơ bản",
                        "Hiểu",
                        "Áp dụng",
                        "Nâng cao"
                      ],
                      onUpdateLabel: (newLabel) {
                        label = newLabel;
                        applyQuestionFilter(label);
                      },
                      allowAll: true,
                      title: "Lọc theo loại câu hỏi: ",
                    ),
                  ),
                ),
                if (questions != null)
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: QuestionCard(
                          question: questions![index],
                          selected: selectedQuestionIds
                              .contains(questions![index].id),
                          onTap: () {
                            if (!selectedQuestionIds
                                .contains(questions![index].id)) {
                              selectedQuestionIds
                                  .add(questions![index].id ?? 0);
                              setState(() {});
                            } else {
                              selectedQuestionIds.removeWhere(
                                  (id) => id == questions![index].id);
                              setState(() {});
                            }
                          },
                        ),
                      );
                    }, childCount: questions?.length),
                  ),
                if (questions != null && questions!.isEmpty)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        "Không tìm thấy câu hỏi",
                      ),
                    ),
                  ),
                if (questions == null)
                  const SliverToBoxAdapter(child: CupertinoActivityIndicator())
              ],
            ),
          ),
        ],
      ),
    );
  }
}

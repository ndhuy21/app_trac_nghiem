import 'package:app_trac_nghiem/src/components/pick_question_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionEditor extends StatefulWidget {
  const QuestionEditor({
    Key? key,
    required this.questionText,
    required this.onRemove,
    required this.onAdd,
  }) : super(key: key);

  final String questionText;
  final Function(String text, String label) onAdd;
  final Function() onRemove;

  @override
  State<QuestionEditor> createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditor> {
  String label = "Cơ bản";
  final _textController = TextEditingController();

  @override
  void initState() {
    _textController.text = widget.questionText;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PickQuestionLabel(
            title: "Loại câu hỏi: ",
            label: label,
            questionLabels: const ["Cơ bản", "Hiểu", "Áp dụng", "Nâng cao"],
            onUpdateLabel: (newLabel) {
              setState(() {
                label = newLabel;
              });
            }),
        Row(
          children: [
            ElevatedButton(
              onPressed: widget.onRemove,
              child: const Text(
                "Xóa",
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red.shade800,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (_textController.text.trim().isNotEmpty) {
                    widget.onAdd(_textController.text.trim(), label);
                  } else {
                    final snackBar = SnackBar(
                      content: const Text("Nội dung không được để trống"),
                      backgroundColor: Colors.red.shade700,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text(
                  "Lưu câu hỏi",
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        TextField(
          controller: _textController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        )
      ],
    );
  }
}

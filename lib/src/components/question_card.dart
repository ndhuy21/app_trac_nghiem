import 'package:app_trac_nghiem/src/persistence/entity/question.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    required this.question,
    this.onTap,
    this.selected = false,
    this.questionIndex,
  }) : super(key: key);

  final Question question;
  final Function()? onTap;
  final bool selected;
  final int? questionIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            border: selected ? Border.all(color: Colors.blue, width: 2) : null,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 8,
                color: Colors.black12,
              ),
            ],
            color: Colors.white),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question.content,
                maxLines: 5,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              width: 60,
              child: Text(
                question.label ?? "",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

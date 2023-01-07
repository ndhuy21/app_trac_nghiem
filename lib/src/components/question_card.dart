import 'package:app_trac_nghiem/src/persistence/entity/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    required this.question,
    this.onTap,
    this.onDelete,
    this.selected = false,
    this.questionIndex,
  }) : super(key: key);

  final Question question;
  final Function()? onTap;
  final Function()? onDelete;
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
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  width: 60,
                  child: Text(
                    question.label ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                if (onDelete != null)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onDelete,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade800,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Boxicons.bxs_trash_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

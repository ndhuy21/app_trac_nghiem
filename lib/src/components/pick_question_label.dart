import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';

class PickQuestionLabel extends StatelessWidget {
  const PickQuestionLabel({
    Key? key,
    required this.title,
    required this.label,
    required this.questionLabels,
    required this.onUpdateLabel,
    this.allowAll = false,
  }) : super(key: key);

  final String title;
  final String label;
  final List<String> questionLabels;
  final Function(String label) onUpdateLabel;
  final bool allowAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 20),
        DropdownButton<String>(
          value: label,
          icon: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Boxicons.bxs_down_arrow, size: 8),
          ),
          elevation: 16,
          style: const TextStyle(color: Colors.blue),
          onChanged: (String? value) {
            onUpdateLabel(value!);
          },
          items: questionLabels
              .map(
                (label) => DropdownMenuItem(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: label),
              )
              .toList(),
        ),
      ],
    );
  }
}

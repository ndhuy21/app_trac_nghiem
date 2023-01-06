import 'package:app_trac_nghiem/src/components/pick_question_label.dart';
import 'package:app_trac_nghiem/src/components/question_card.dart';
import 'package:app_trac_nghiem/src/persistence/entity/question.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateTestScreen extends StatefulWidget {
  const CreateTestScreen({
    Key? key,
    required this.questions,
  }) : super(key: key);

  final List<Question> questions;

  @override
  State<CreateTestScreen> createState() => _CreateTestScreenState();
}

class _CreateTestScreenState extends State<CreateTestScreen> {
  late List<DragAndDropList> _contents;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _contents = [
      DragAndDropList(
        children: widget.questions
            .map(
              (question) => DragAndDropItem(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: QuestionCard(
                    question: question,
                  ),
                ),
              ),
            )
            .toList(),
      )
    ];
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tạo đề")),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 28),
                      ),
                      child: const Text(
                        "Xuất đề",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text("Kéo thả để thay đổi thứ tự câu hỏi"),
                  ],
                ),
              ),
            ),
            DragAndDropLists(
              sliverList: true,
              scrollController: _scrollController,
              children: _contents,
              onItemReorder: _onItemReorder,
              onListReorder: _onListReorder,
            )
          ],
        ),
      ),
    );
  }
}

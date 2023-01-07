import 'package:app_trac_nghiem/src/components/question_card.dart';
import 'package:app_trac_nghiem/src/persistence/entity/question.dart';
import 'package:app_trac_nghiem/src/utils/export_docx.dart';
import 'package:app_trac_nghiem/src/utils/export_pdf.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

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
                    Row(
                      children: [
                        Expanded(
                          child: ExportButton(
                            title: "Xuất PDF",
                            export: () async {
                              final fileName =
                                  await exportPdf(widget.questions);
                              return fileName;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: ExportButton(
                            title: "Xuất DOCX",
                            export: () async {
                              final fileName =
                                  await exportDocx(widget.questions);
                              return fileName;
                            },
                          ),
                        ),
                      ],
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

class ExportButton extends StatelessWidget {
  const ExportButton({
    Key? key,
    required this.title,
    required this.export,
  }) : super(key: key);

  final String title;
  final Future<String> Function() export;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final filePath = await export();
        final snackBar = SnackBar(
          backgroundColor: filePath.isEmpty ? Colors.red.shade900 : null,
          content: filePath.isEmpty
              ? const Text("Có lỗi xảy ra")
              : Text("Đã lưu: " + filePath),
          action: filePath.isEmpty
              ? null
              : SnackBarAction(
                  label: "Mở",
                  onPressed: () {
                    OpenFile.open(filePath);
                  },
                ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 28),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}

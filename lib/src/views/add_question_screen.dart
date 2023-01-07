import 'package:app_trac_nghiem/src/components/pick_question_label.dart';
import 'package:app_trac_nghiem/src/components/question_editor.dart';
import 'package:app_trac_nghiem/src/utils/extract_question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({
    Key? key,
    required this.onAddQuestionScreen,
  }) : super(key: key);

  final Function(String content, String label) onAddQuestionScreen;

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _picker = ImagePicker();
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  List<String> questions = [""];
  bool waiting = false;

  void recognizeText(ImageSource source) async {
    final image = await _picker.getImage(source: source);
    if (image == null) {
      return;
    }
    setState(() {
      waiting = true;
      questions = [];
    });
    final inputImage = InputImage.fromFilePath(image.path);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    final textBlocks =
        recognizedText.blocks.map((block) => block.text).toList();
    questions = extractQuestion(textBlocks);

    setState(() {
      waiting = false;
    });
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo câu hỏi mới'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!waiting) {
                                recognizeText(ImageSource.camera);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Máy ảnh"),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(Boxicons.bxs_camera),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!waiting) {
                                recognizeText(ImageSource.gallery);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Thư viện",
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(Boxicons.bxs_photo_album),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: QuestionEditor(
                      questionText: questions[index],
                      onRemove: () {
                        questions.removeAt(index);
                        setState(() {});
                      },
                      onAdd: (content, label) {
                        widget.onAddQuestionScreen(content, label);
                        questions.removeAt(index);
                        setState(() {});
                      },
                    ),
                  );
                },
                childCount: questions.length,
              ),
            ),
            if (waiting)
              SliverToBoxAdapter(
                  child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("Đang nhận diên câu hỏi"),
                ),
              ))
          ],
        ),
      ),
    );
  }
}

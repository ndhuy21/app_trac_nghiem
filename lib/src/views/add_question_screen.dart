import 'package:app_trac_nghiem/src/components/pick_question_label.dart';
import 'package:app_trac_nghiem/src/utils/extract_question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({Key? key, required this.onAddQuestionScreen})
      : super(key: key);

  final Function(String content, String label) onAddQuestionScreen;

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _textController = TextEditingController();
  final _picker = ImagePicker();
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  String label = "Cơ bản";
  bool waiting = false;

  void recognizeText(ImageSource source) async {
    final image = await _picker.pickImage(source: source);
    if (image == null) {
      return;
    }
    setState(() {
      waiting = true;
    });
    final inputImage = InputImage.fromFilePath(image.path);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    final textBlocks =
        recognizedText.blocks.map((block) => block.text).toList();
    final questionText = extractQuestion(textBlocks);
    _textController.text = questionText;
    setState(() {
      waiting = false;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
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
            SliverFillRemaining(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                recognizeText(ImageSource.camera);
                              },
                              child: Row(children: const [
                                Text("Máy ảnh"),
                                Icon(Boxicons.bxs_camera),
                              ]),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                recognizeText(ImageSource.gallery);
                              },
                              child: Row(
                                children: const [
                                  Text("Thư viện"),
                                  Icon(Boxicons.bxs_photo_album),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  widget.onAddQuestionScreen(
                                    _textController.text,
                                    label,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Lưu"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        PickQuestionLabel(
                            title: "Loại câu hỏi: ",
                            label: label,
                            questionLabels: const [
                              "Cơ bản",
                              "Hiểu",
                              "Áp dụng",
                              "Nâng cao"
                            ],
                            onUpdateLabel: (newLabel) {
                              setState(() {
                                label = newLabel;
                              });
                            }),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (waiting)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const CupertinoActivityIndicator(),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

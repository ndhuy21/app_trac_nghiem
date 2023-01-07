import 'dart:io';
import 'dart:typed_data';

import 'package:app_trac_nghiem/src/persistence/entity/question.dart';
import 'package:app_trac_nghiem/src/utils/file_handle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String> exportPdf(List<Question> questions) async {
//Create a new PDF document.
//Read font data.
  final byteData = await rootBundle.load('assets/templates/arial.ttf');
  final f = File('${(await getTemporaryDirectory()).path}/temp.tmp');
  await f.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  final Uint8List fontData = f.readAsBytesSync();
//Create a PDF true type font object.
  final PdfFont font = PdfTrueTypeFont(fontData, 12);

  final PdfDocument document = PdfDocument();
  PdfPage page = document.pages.add();
  double lastBottomBound = 0;
  for (int i = 0; i < questions.length; i++) {
    final layoutResult = PdfTextElement(
      text: "Câu ${i + 1}: " + questions[i].content,
      font: font,
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
    ).draw(
      page: page,
      bounds: Rect.fromLTWH(0, lastBottomBound, page.getClientSize().width,
          page.getClientSize().height),
      format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
    )!;
    page = layoutResult.page;
    lastBottomBound = layoutResult.bounds.bottom + 10;
  }

// Save the document.
  final file = await document.save();
  DateTime _now = DateTime.now();
  String fileName = "export_${_now.hour}-${_now.minute}-${_now.second}.pdf";
  final filePath = await saveFile(fileName, file);
// Dispose the document.
  document.dispose();
  return filePath;
}

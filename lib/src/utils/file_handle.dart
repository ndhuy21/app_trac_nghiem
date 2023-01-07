import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<String> saveFile(String fileName, List<int> file) async {
  final dir = await getExternalStorageDirectory();
  final filePath = dir!.path + '/' + fileName;
  File(filePath).writeAsBytes(file);
  return filePath;
}

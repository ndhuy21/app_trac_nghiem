import 'dart:math';

const beginQuestionTexts = ["Câu", "câu", "Bài", "bài", "question", "Question"];
const splitChar = ['.', '/', '\\', ')', ':'];

int findPosition(String str, List<String> words, int startFrom) {
  int position = str.length;
  for (int i = 0; i < words.length; i++) {
    int p = str.indexOf(words[i], startFrom);
    if (p >= 0) position = min(position, p);
  }
  return position;
}

bool isBeginQuestion(String str) {
  for (int i = 0; i < beginQuestionTexts.length; i++) {
    if (str.startsWith(beginQuestionTexts[i])) return true;
  }
  for (int i = 1; i <= 100; i++) {
    for (int j = 0; j < splitChar.length; j++) {
      String text = i.toString() + splitChar[j];
      if (str.startsWith(text)) return true;
      text = i.toString() + ' ' + splitChar[j];
      if (str.startsWith(text)) return true;
    }
  }
  return false;
}

String clearBeginQuestion(String str) {
  String s = str.trim();
  for (int i = 0; i < beginQuestionTexts.length; i++) {
    if (str.startsWith(beginQuestionTexts[i])) {
      s = str.substring(beginQuestionTexts[i].length, str.length);
      break;
    }
  }
  s = s.trim();
  for (int i = 1; i <= 100; i++) {
    for (int j = 0; j < splitChar.length; j++) {
      String text = i.toString() + splitChar[j];
      if (s.startsWith(text)) return s.substring(text.length, s.length);
      text = i.toString() + ' ' + splitChar[j];
      if (s.startsWith(text)) return s.substring(text.length, s.length);
    }
  }
  return s;
}

List<String> extractQuestion(List<String> texts) {
  List<String> result = [];

  int start = 0;
  while (start < texts.length) {
    for (int i = start; i < texts.length; i++) {
      if (isBeginQuestion(texts[i])) {
        start = i;
        break;
      }
    }
    int end = texts.length;
    for (int i = start + 1; i < texts.length; i++) {
      if (isBeginQuestion(texts[i])) {
        end = i;
        break;
      }
    }

    String question = "";
    for (int i = start; i < end; i++) {
      question = question + texts[i] + "\n";
    }

    if (result.isEmpty || isBeginQuestion(question)) {
      if (isBeginQuestion(question)) {
        question = clearBeginQuestion(question);
      }
      result.add(question);
    }
    start = end;
  }
  return result;
}

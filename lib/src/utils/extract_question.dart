import 'dart:math';

const beginQuestionTexts = ["Câu", "câu", "Bài", "bài", "question", "Question"];

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
    if (str.startsWith(
      beginQuestionTexts[i],
    )) return true;
  }
  return false;
}

String extractQuestion(List<String> texts) {
  int start = 0;
  for (int i = 0; i < texts.length; i++) {
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

  String result = "";
  for (int i = start; i < end; i++) {
    result = result + texts[i] + "\n";
  }
  return result;
}

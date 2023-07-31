import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

Future<List<String>> readBadWordsFromFile() async {
  List<String> words = [];
  try {
    String contents = await rootBundle.loadString('assets/badWords.txt');
    words = contents.split('\n').map((word) => word.trim()).toList();
  } catch (e) {
    print("Error reading file: $e");
  }
  return words;
}

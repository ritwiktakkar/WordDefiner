import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

var spelledLikeURL = 'https://api.datamuse.com/words?sp=';
var soundsLikeURL = 'https://api.datamuse.com/words?sl=';
var relatedToURL = 'https://api.datamuse.com/words?rel_trg=';
var rhymesWithURL = 'https://api.datamuse.com/words?rel_rhy=';

Future<List<String>?> getSimilarSpeltWords(String wordToDefine) async {
  List<String>? similarSpeltWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(spelledLikeURL + wordToDefine),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getSimilarSpeltWords() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        similarSpeltWords.add(word);
      }

      // debugPrint('similarWordsList: ${similarSpeltWords}');
      return similarSpeltWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getSimilarSoundingWords(String wordToDefine) async {
  List<String>? similarSoundingWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(soundsLikeURL + wordToDefine),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getSimilarSpeltWords() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        similarSoundingWords.add(word);
      }

      // debugPrint('similarSoundingWords: ${similarSoundingWords}');
      return similarSoundingWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getRelatedWords(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(relatedToURL + wordToDefine),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getSimilarSpeltWords() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }

      // debugPrint('relatedWords: ${relatedWords}');
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

Future<List<String>?> getRhymingWords(String wordToDefine) async {
  List<String>? relatedWords = [];
  try {
    final response = await http
        .get(
      Uri.parse(rhymesWithURL + wordToDefine),
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("getSimilarSpeltWords() timeout");
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      var rest = parsedJson as List;
      for (var i = 0; i < rest.length; i++) {
        if (rest[i]["word"].toLowerCase() == wordToDefine.toLowerCase()) {
          continue;
        }
        String word = rest[i]["word"][0].toUpperCase() +
            rest[i]["word"].substring(1).toLowerCase();
        relatedWords.add(word);
      }

      // debugPrint('relatedWords: ${relatedWords}');
      return relatedWords;
    } else if (response.statusCode == 404) {}
  } on TimeoutException catch (_) {
    return null;
  }
  return null;
}

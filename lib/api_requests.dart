import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iDefine/models.dart';
import 'dart:convert';

var postURL = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

Future<Definition> getDefinition(String wordToDefine) async {
  try {
    final jsonResponse = await http.get(
      Uri.parse(postURL + wordToDefine),
    );
    // debugPrint('response.body: ' + response.body);
    if (jsonResponse.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      debugPrint('200 OK response');
      Definition definition = new Definition.fromJson(
        jsonDecode(jsonResponse.body),
      );
      debugPrint(definition.word);
      //  debugPrint('definition.word: ' + definition.word);
      return definition;
      // debugPrint(response.body.toString());
      // return response.body.toString();
      // return Definition.fromJson(json.decode(response.body));
    } else if (jsonResponse.statusCode == 404) {
      return Definition(
        word: '-',
        phonetic: '',
        phonetics: [],
        meanings: [],
        license: License(name: '', url: ''),
        sourceUrls: [],
      );
    }
  } catch (e) {
    debugPrint('$e');
  }
  return Definition(
      word: '',
      phonetic: '',
      phonetics: [],
      meanings: [],
      license: License(name: '', url: ''),
      sourceUrls: []);
}

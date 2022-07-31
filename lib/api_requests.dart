import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iDefine/definition.dart';
import 'dart:convert';

var postURL = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

Future<Definition> getDefinition(String wordToDefine) async {
  try {
    final response = await http.get(
      Uri.parse(postURL + wordToDefine),
    );
    debugPrint('response.body: ' + response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      debugPrint('200 OK response');
      Definition definition = Definition.fromJson(
        jsonDecode(response.body),
      );
      //  debugPrint('definition.word: ' + definition.word);
      return definition;
      // debugPrint(response.body.toString());
      // return response.body.toString();
      // return Definition.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return Definition(
        word: '-',
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
      phonetics: [],
      meanings: [],
      license: License(name: '', url: ''),
      sourceUrls: []);
}

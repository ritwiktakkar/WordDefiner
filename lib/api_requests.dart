import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iDefine/model/definition_model.dart';
import 'dart:convert';

var postURL = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

List<Phonetic> nullPhoneticList = <Phonetic>[];
List<Meaning> nullMeaningsList = <Meaning>[];

Definition definitionIfNotFound = Definition(
  word: '-',
  phonetic: '',
  phonetics: PhoneticsList(phonetics: nullPhoneticList),
  meanings: MeaningsList(meanings: nullMeaningsList),
  license: License(name: '', url: ''),
  sourceUrls: [],
);

Future<Definition> getDefinition(String wordToDefine) async {
  try {
    final jsonResponseInitial = await http.get(
      Uri.parse(postURL + wordToDefine),
    );
    debugPrint(
        'jsonResponseInitial is: ${jsonResponseInitial.runtimeType}; ${jsonResponseInitial}\n');
    if (jsonResponseInitial.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      debugPrint('200 OK response');
      debugPrint(
          'jsonResponseInitial.body.runtimeType: ${jsonResponseInitial.body.runtimeType}; ${jsonResponseInitial.body}\n');
      String tmpStringResponse = jsonResponseInitial.body;
      tmpStringResponse =
          tmpStringResponse.substring(1, tmpStringResponse.length - 1);
      final jsonResponseFormatted = json.decode(tmpStringResponse);
      debugPrint(
          'jsonResponseFormatted is: ${jsonResponseFormatted.runtimeType}; ${jsonResponseFormatted}\n');
      // Map<String, dynamic> data = new Map<String, dynamic>.from(
      //   jsonResponseFormatted.body,
      // );
      // debugPrint('data is: ${data.runtimeType}; ${data}\n');
      Definition definition = new Definition.fromJson(
        jsonResponseFormatted,
      );
      // Map<String, dynamic> data = new Map<String, dynamic>.from(
      //     json.decode(jsonResponseFormatted.body));
      // debugPrint('data is: ${data.runtimeType}; ${data}\n');0
      return definition;
      // debugPrint(response.body.toString());
      // return response.body.toString();
      // return Definition.fromJson(json.decode(response.body));
    } else if (jsonResponseInitial.statusCode == 404) {
      return Definition(
        word: '-',
        phonetic: '',
        phonetics: PhoneticsList(phonetics: nullPhoneticList),
        meanings: MeaningsList(meanings: nullMeaningsList),
        license: License(name: '', url: ''),
        sourceUrls: [],
      );
    }
  } catch (e) {
    debugPrint('exception: $e');
  }
  return Definition(
      word: '',
      phonetic: '',
      phonetics: PhoneticsList(phonetics: nullPhoneticList),
      meanings: MeaningsList(meanings: nullMeaningsList),
      license: License(name: '', url: ''),
      sourceUrls: []);
}

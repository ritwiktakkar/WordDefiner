import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iDefine/definition.dart';
import 'dart:convert';

var postURL = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

Future<String> getiDefinition(String wordToDefine) async {
  final response = await http.get(
    Uri.parse(postURL + wordToDefine),
  );
  debugPrint('response.body: ' + response.body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    Definition definition = Definition.fromJson(jsonDecode(response.body));
    debugPrint(definition.word);

    // debugPrint(response.body.toString());
    // return response.body.toString();
    // return Definition.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    debugPrint('Server error: non \'200 OK\' response');
  }
  return "";
}

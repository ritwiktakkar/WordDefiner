import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:iDefine/model/definition_model_old.dart';
import 'package:WordDefiner/model/definition_model.dart';
import 'dart:convert';

// import 'package:iDefine/model/definition_model_old.dart';

var postURL = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

Future<DefinitionElementList> getDefinition(String wordToDefine) async {
  try {
    final response = await http.get(
      Uri.parse(postURL + wordToDefine),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      debugPrint('200 OK response');
      final parsedJson = json.decode(response.body);
      DefinitionElementList definitionList =
          DefinitionElementList.fromJson(parsedJson);
      return definitionList;
    } else if (response.statusCode == 404) {
      return DefinitionElementList(
        definitionElements: null,
        isNotFound: true,
      );
    }
  } catch (e) {
    debugPrint('exception: $e');
  }
  return DefinitionElementList(
    definitionElements: null,
    isNull: true,
  );
}

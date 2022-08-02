import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:iDefine/model/definition_model_old.dart';
import 'package:iDefine/model/definition_model.dart';
import 'dart:convert';

// import 'package:iDefine/model/definition_model_old.dart';

var postURL = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

Future<DefinitionElementList> getDefinition(String wordToDefine) async {
  try {
    final response = await http.get(
      Uri.parse(postURL + wordToDefine),
    );
    // debugPrint(
    // 'response type is: ${response.runtimeType}; body: ${response.body}\n');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      debugPrint('200 OK response');
      // debugPrint(
      //     'response.body.runtimeType: ${response.body.runtimeType}; ${response.body}\n');
      // String tmpStringResponse = response.body;
      // tmpStringResponse =
      //     tmpStringResponse.substring(1, tmpStringResponse.length - 1);
      // // final response = json.decode(tmpStringResponse);
      // final response_tmp = json.decode(tmpStringResponse);
      // debugPrint(
      //     'response_tmp type is: ${response_tmp.runtimeType}; response_tmp is: ${response_tmp}\n');
      // final parsedJson = json.decode(response_tmp);
      // debugPrint(
      //     'parsedJson type is: ${parsedJson.runtimeType}; parsedJson is: ${parsedJson}\n');
      // // debugPrint('${parsedJson['word']}, ${parsedJson['phonetic']}');
      // Map<String, dynamic> data = new Map<String, dynamic>.from(
      //   parsedJson.body,
      // );
      // debugPrint('data is: ${data.runtimeType}; ${data}\n');
      // DefinitionElementList definitions = DefinitionElementList.fromJson(
      //   parsedJson,
      // );
      // debugPrint('definitions.word: ${definitions.word}');
      // // Map<String, dynamic> data = new Map<String, dynamic>.from(
      // //     json.decode(response.body));
      // // debugPrint('data is: ${data.runtimeType}; ${data}\n');0
      // return definitions;
      // debugPrint(response.body.toString());
      // return response.body.toString();
      // return Definition.fromJson(json.decode(response.body));
      // for (int i in response.body) {
//
      // }
      // return DefinitionElementList.fromJson(json.decode(response.body)[0]);
      final parsedJson = json.decode(response.body);
      DefinitionElementList definitionList =
          DefinitionElementList.fromJson(parsedJson);
      return definitionList;
    } else if (response.statusCode == 404) {
      return DefinitionElementList(
        definitionElements: null,
      );
    }
  } catch (e) {
    debugPrint('exception: $e');
  }
  return DefinitionElementList(
    definitionElements: null,
  );
}

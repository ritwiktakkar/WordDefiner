import 'package:WordDefiner/Analytics/analytics_form.dart';
import 'package:WordDefiner/Analytics/definition_form.dart';
import 'package:WordDefiner/Analytics/device_form.dart';
import 'package:WordDefiner/services/get_device_details.dart';
import 'package:WordDefiner/services/submit_analytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:WordDefiner/model/definition_model.dart';
import 'dart:convert';

var postURL = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

Future<DefinitionElementList> getDefinition(String wordToDefine) async {
  // set initial values for analytics
  String query = wordToDefine;
  String isFound = 'False';
  DefinitionForm definitionForm = DefinitionForm(query, isFound);
  DeviceForm deviceForm = await deviceDetails();
  AnalyticsForm analyticsForm = AnalyticsForm(definitionForm, deviceForm);

  try {
    final response = await http.get(
      Uri.parse(postURL + wordToDefine),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsedJson = json.decode(response.body);
      DefinitionElementList definitionList =
          DefinitionElementList.fromJson(parsedJson);
      // update definitionForm and analyticsForm with result isFound
      definitionForm = DefinitionForm(query, 'True');
      analyticsForm = AnalyticsForm(definitionForm, deviceForm);

      submitAnalytics(analyticsForm, (String response) {
        debugPrint(response);
      });
      return definitionList;
    } else if (response.statusCode == 404) {
      debugPrint(
          "analyticsForm (404 error): ${analyticsForm.toJson().toString()}");
      submitAnalytics(analyticsForm, (String response) {
        debugPrint(response);
      });
      return DefinitionElementList(
        definitionElements: null,
        isNotFound: true,
      );
    }
  } catch (e) {
    debugPrint('exception: $e');
  }
  debugPrint("analyticsForm (failed): ${analyticsForm.toJson().toString()}");
  submitAnalytics(analyticsForm, (String response) {
    debugPrint(response);
  });
  return DefinitionElementList(
    definitionElements: null,
    isNull: true,
  );
}

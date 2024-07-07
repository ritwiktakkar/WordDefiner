import 'package:WordDefiner/Analytics/analytics_form.dart';

import 'package:WordDefiner/Analytics/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

/// Async function which submits analytics
void submitAnalytics(
    AnalyticsForm analyticsForm, void Function(String) callback) async {
  try {
    await http
        .post(Uri.parse(Constants.gs_url), body: analyticsForm.toJson())
        .then((response) async {
      if (response.statusCode == 302) {
        var url = response.headers['location'];
        await http.get(Uri.parse(url!)).then((response) {
          callback(convert.jsonDecode(response.body)['status']);
        });
      } else {
        callback(convert.jsonDecode(response.body)['status']);
      }
    });
  } catch (e) {
    debugPrint(e as String?);
  }
}

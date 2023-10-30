import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:ui/config/strings.dart';
import 'package:ui/model/news&events/news_feed_model.dart';
import 'package:ui/utils/session_management.dart';

Future<NewsFeedMain?> getNewsFeed(
    {required String studentId, required int pageNumber}) async {
  var url = Uri.parse(studentId == ''
      ? "${Strings.baseURL}api/v2/mainscreen_view_newsevents?page=$pageNumber"
      : "${Strings.baseURL}api/v2/mainscreen_view_newsevents?student_id=$studentId&page=$pageNumber");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  print(token);

  try {
    final response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      print(response.body);
      final jsonResponse = jsonDecode(response.body);
      return NewsFeedMain.fromJson(jsonResponse);
    } else {
      if (kDebugMode) {
        print(
            ' News Feed issue:- Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    print("error $err");
    if (kDebugMode) {
      print("Error on news feed:- $err");
    }
    return null;
  }
}

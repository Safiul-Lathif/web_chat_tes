import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/news_feed_model.dart';
import 'package:ui/utils/session_management.dart';

Future<NewsFeed?> getNewsFeed() async {
  var url = Uri.parse("${Strings.baseURL}api/user/mainscreen_view_newsevents");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  try {
    final response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(response.body);
      return NewsFeed.fromJson(jsonResponse);
    } else {
      if (kDebugMode) {
        print(
            ' News Feed:- Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print(err);
    }
    return null;
  }
}

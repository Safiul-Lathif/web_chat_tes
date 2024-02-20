import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> likeDislikeNews(
    {required String id, required String status}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_liked_news");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map["news_id"] = id;
  map["like_status"] = status;

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      if (kDebugMode) {}
      return jsonDecode(response.body);
    } else {
      if (kDebugMode) {
        print(
            'store_liked_news:- Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print('store_liked_news-> error occurred: $err.');
    }
    return null;
  }
}

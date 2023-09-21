import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> deleteNews({required String id}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/delete_news_events");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map["news_events_id"] = id;

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      return jsonDecode(response.body);
    } else {
      if (kDebugMode) {
        print(
            'delete api:- Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print('Delete Api -> error occurred: $err.');
    }
    return null;
  }
}

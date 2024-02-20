import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> eventAcceptDecline(
    {required String id, required String status}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/event_accept_decline");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map["event_id"] = id;
  map["accept_status"] = status;
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      if (kDebugMode) {}
      return jsonDecode(response.body);
    } else {
      if (kDebugMode) {
        print(
            'event like:- Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print('event like-> error occurred: $err.');
    }
    return null;
  }
}

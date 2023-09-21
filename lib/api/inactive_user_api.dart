import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> inactiveUser() async {
  var url = Uri.parse(
      "${Strings.baseURL}api/user/send_not_installed_user_welcome_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  try {
    final response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      if (kDebugMode) {
        print(
            'Inactive User :- Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print('In Active User  -> error occurred: $err.');
    }
    return null;
  }
}

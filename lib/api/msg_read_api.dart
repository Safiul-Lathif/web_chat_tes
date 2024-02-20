import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';

import 'package:ui/utils/session_management.dart';

Future<dynamic> messageRead(
    {required String msgStatus, required String notifyid}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/message_read");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map["message_status"] = msgStatus;

  map["notification_id"] = notifyid;

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      //final jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {}
      return jsonDecode(response.body);
    } else {
      print(
          'message read:- Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occurred: $err.');
    return null;
  }
}

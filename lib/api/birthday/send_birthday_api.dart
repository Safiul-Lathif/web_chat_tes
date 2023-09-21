import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> sendBirthday(
    {required List<String> classIds, required String bDayMessage}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_birthday_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  for (int i = 0; i < classIds.length; i++) {
    map['visible_to[$i]'] = classIds[i];
  }
  map["chat_message"] = bDayMessage;
  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('bDay send  -> error occurred: $err.');
    return null;
  }
}

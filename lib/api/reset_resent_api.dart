import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> resetAndReSend(
    {required String id, required String role}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/reset_send_sms");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map["id"] = id;
  map["user_role"] = role;
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('changePassword -> error occured: $err.');
    return null;
  }
}

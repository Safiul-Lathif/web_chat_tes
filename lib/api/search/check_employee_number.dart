// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> checkEmployeeNumber(String number, int id, int role) async {
  var url = Uri.parse("${Strings.baseURL}api/user/checkEmployeeno");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["employee_no"] = number;
  map["user_role"] = role.toString();
  if (id != 0) map["id"] = id.toString();

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      return jsonResponse;
    } else {
      print(
          'check employee number:- Request failed with status: ${response.body}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

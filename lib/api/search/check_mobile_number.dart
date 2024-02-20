// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> checkMobileNumber(int number, int id, int category) async {
  var url = Uri.parse("${Strings.baseURL}api/user/checkMobileno");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["mobile_number"] = number.toString();
  map["user_category"] = category.toString();
  if (id != 0) map["id"] = id.toString();

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      return jsonResponse;
    } else {
      print(
          'check mobile number:- Request failed with status: ${response.body}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

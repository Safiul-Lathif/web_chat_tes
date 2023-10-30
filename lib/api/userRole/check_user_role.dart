import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> checkUserRole() async {
  var url = Uri.parse("${Strings.baseURL}api/user/check_user_role_changed");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  try {
    final response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(
          'User Role  :-Request failed with status ${response.statusCode} : ${response.body}.');
      return null;
    }
  } on Error catch (err) {
    print('User Role  -> error occurred: $err.');
    return null;
  }
}

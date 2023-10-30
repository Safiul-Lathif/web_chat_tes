import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';

import '../../utils/session_management.dart';

Future<dynamic> changeUserRole(String currentRole, String userId,
    String changedRole, String userCategory) async {
  var url = Uri.parse("${Strings.baseURL}api/user/user_role_change");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["changing_role"] = changedRole;
  map['original_role'] = currentRole;
  map['user_id'] = userId;
  if (userCategory != '0') map['user_category'] = userCategory;
  print("$map , $token , $url");
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
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

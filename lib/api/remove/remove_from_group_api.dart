import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> removeFromGroup(
    String number, String status, String role, String groupId) async {
  var url = Uri.parse("${Strings.baseURL}api/user/user_status_change");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["mobile_number"] = number;
  map['user_role'] = role;
  map['status'] = status;
  map['group_id'] = groupId;
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(
          'User Status change :-Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('User Status change -> error occurred: $err.');
    return null;
  }
}

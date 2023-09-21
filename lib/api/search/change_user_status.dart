import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> changeUserStatus(
    String number, String status, String role, String appDeactivation) async {
  var url = Uri.parse("${Strings.baseURL}api/user/user_status_change");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["mobile_number"] = number;
  map['user_role'] = role;
  map['status'] = status;
  map['app_deactivation'] = appDeactivation;
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      print(response.body);
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

Future<dynamic> changeUserStatusStudent(
    String status, String id, String appDeactivation) async {
  var url = Uri.parse("${Strings.baseURL}api/user/user_status_change");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["mobile_number"] = '';
  map['user_role'] = '4';
  map['status'] = status;
  map['student_id'] = id;
  appDeactivation == '' ? null : map['app_deactivation'] = appDeactivation;
  print("$status, $id , $appDeactivation");
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      print(response.body);
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

Future<dynamic> activateAnyUser(
  String number,
  String status,
  String role,
) async {
  var url = Uri.parse("${Strings.baseURL}api/user/user_status_change");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["mobile_number"] = number;
  map['user_role'] = role;
  map['status'] = status;
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      print(response.body);
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

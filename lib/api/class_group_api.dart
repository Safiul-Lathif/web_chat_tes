import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/all_group_list.dart';
import 'package:ui/model/classModel.dart';
import 'package:ui/utils/session_management.dart';
import 'package:ui/utils/utility.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<ClassGroup?> getClassGroup() async {
  var url = Uri.parse("${Strings.baseURL}api/user/classes_group");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print("class List With section ${response.body}");
      return ClassGroup.fromJson(jsonResponse);
    } else {
      print(
          'classes Group:-Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

Future<GroupList?> getClassList() async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_class_list");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return GroupList.fromJson(jsonResponse);
    } else {
      print(
          'classes Group:-Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

Future<ClassGroup?> getParentClassGroup(String id) async {
  var url =
      Uri.parse("${Strings.baseURL}api/user/classes_group?student_id=$id");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ClassGroup.fromJson(jsonResponse);
    } else {
      print(
          'parent class:-Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';

import 'package:ui/model/parenthomeworkmodel.dart';
import 'package:ui/model/staffhomeworkmodel.dart';

import 'package:ui/utils/session_management.dart';

Future<List<StaffHomework>?> getStaffHomework(
    String homeworkDate, String classId) async {
  var url = Uri.parse("${Strings.baseURL}api/user/homework");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};

  map["homework_date"] = homeworkDate;
  map["class_config"] = classId;
  print(homeworkDate);
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      print(response.body);
      return jsonResponse.map((json) => StaffHomework.fromJson(json)).toList();
    } else {
      // ignore: avoid_print
      print('Home Work:-Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print(err);
    return null;
  }
}

Future<List<HomeworkParent>?> getParentHomework(
    String homworkDate, String classId, String studId, String notifyId) async {
  var url = Uri.parse("${Strings.baseURL}api/user/homework");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();
  var map = <String, dynamic>{};
  //var request = http.MultipartRequest("POST", url);
  map["homework_date"] = homworkDate;
  map["class_config"] = classId;
  map["loginstudent_id"] = studId;
  map["notification_id"] = notifyId;

  // request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  //};
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => HomeworkParent.fromJson(json)).toList();
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print(err);
    return null;
  }
}

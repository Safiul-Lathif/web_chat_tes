import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/homeWork/homework_status_model.dart';
import 'package:ui/utils/session_management.dart';

Future<List<HomeworkStatusModel>?> getHomeworkStatusList(
    String id, String status) async {
  var url = Uri.parse("${Strings.baseURL}api/user/list_homework_status");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  var map = <String, dynamic>{};
  map["homework_id"] = id;
  map["status"] = status;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((json) => HomeworkStatusModel.fromJson(json))
          .toList();
    } else {
      if (kDebugMode) {
        ('Hw-Status :-Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print("Action required:- $err");
    }
    return null;
  }
}

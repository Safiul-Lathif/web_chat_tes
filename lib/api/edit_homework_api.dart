import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';

import 'package:ui/model/edit_homework_model.dart';

import 'package:ui/utils/session_management.dart';

Future<List<EditHomeworkModel>?> getEditHomeworklist(
    String homeworkDate, String classId) async {
  var url = Uri.parse("${Strings.baseURL}api/user/homework");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  var map = <String, dynamic>{};

  map["homework_date"] = homeworkDate;
  map["class_config"] = classId;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((json) => EditHomeworkModel.fromJson(json))
          .toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

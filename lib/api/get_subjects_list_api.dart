import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';

import 'package:ui/model/get_subjects_list.dart';
import 'package:ui/model/settings/index.dart';

import 'package:ui/utils/session_management.dart';

Future<List<Subjects>?> getSubjectsList({required String divId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_allsubjects_list");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  var map = <String, dynamic>{};
  map["division_id"] = divId;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)["subjects"];
      return jsonResponse.map((json) => Subjects.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

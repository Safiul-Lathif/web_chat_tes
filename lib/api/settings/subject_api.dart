// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/settings/index.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> addEditSubject(
    {required String subjectName,
    required int subjectId,
    required String divId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/subjects");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map['division_id'] = divId;
  map["subject[0][subject_name]"] = subjectName;
  if (subjectId != 0) map["subject[0][subject_id]"] = subjectId.toString();

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(
          'create update :Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log('create update subject -> error occurred: $err.');
    return null;
  }
}

Future<List<Subjects>?> getSubjectsList({required String divId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_subjects");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  var map = <String, dynamic>{};
  map["division_id"] = divId;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);

      return jsonResponse.map((json) => Subjects.fromJson(json)).toList();
    } else {
      log('get subject: Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log("get subject : $err");
    return null;
  }
}

Future<dynamic> deleteSubject(
    {required String subId, required String divId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/delete_subject");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};

  map["subject_id"] = subId;
  map["division_id"] = divId;

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      log('Delete subject Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log('Delete subject -> error occurred: $err.');
    return null;
  }
}

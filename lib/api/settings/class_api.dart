// ignore_for_file: unnecessary_string_interpolations, avoid_print
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/settings/index.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> addEditClass(
    {required String className,
    required int classId,
    required String divId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/create_update_class_manual");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map['division_id'] = divId;
  map["classes[0][class_name]"] = className;
  if (classId != 0) map["classes[0][class_id]"] = classId.toString();
  try {
    print("$map ");
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      log('create update :Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log('create update class -> error occurred: $err.');
    return null;
  }
}

Future<List<ListsClass>?> getClassList({required String dId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_classes_list");
  SessionManager? pref = SessionManager();
  String? token = await pref.getAuthToken();

  var map = <String, dynamic>{};
  map["division_id"] = dId;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)["classes"];
      return jsonResponse.map((json) => ListsClass.fromJson(json)).toList();
    } else {
      log('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log('$err');
    return null;
  } finally {
    pref = null;
  }
}

Future<dynamic> deleteClass(
    {required String clsId, required String divisionId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/delete_class");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map["class_id"] = clsId;
  map["division_id"] = divisionId;

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      log('Onboarding Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log('changePassword -> error occurred: $err.');
    return null;
  }
}

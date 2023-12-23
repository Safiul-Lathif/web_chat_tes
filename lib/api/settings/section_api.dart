import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/settings/index.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> addEditSection(
    {required String sectionName,
    required int sectionId,
    required String divId}) async {
  var url =
      Uri.parse("${Strings.baseURL}api/user/create_update_section_manual");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map['division_id'] = divId;
  map["sections[0][section_name]"] = sectionName;
  if (sectionId != 0) map["sections[0][section_id]"] = sectionId.toString();
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      log('create update section :Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log('create update section -> error occurred: $err.');
    return null;
  }
}

Future<SectionList?> getSectionList({required String dId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_sections");
  SessionManager? pref = SessionManager();
  String? token = await pref.getAuthToken();

  var map = <String, dynamic>{};
  map["division_id"] = dId;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return SectionList.fromJson(jsonResponse);
    } else {
      log('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log("$err");
    return null;
  } finally {
    pref = null;
  }
}

Future<dynamic> deleteSection(
    {required String secId, required String divId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/delete_section");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map["section_id"] = secId;
  map["division_id"] = divId;
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      log(response.body);

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

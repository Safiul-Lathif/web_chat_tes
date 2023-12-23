import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/settings/index.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> addEditDivision(
    {required String divisionName, required int divisionId}) async {
  var url =
      Uri.parse("${Strings.baseURL}api/user/create_update_division_manual");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map["divisions[0][division_name]"] = divisionName;
  if (divisionId != 0) map["divisions[0][division_id]"] = divisionId.toString();
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      log('create update :Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log('create update division -> error occurred: $err.');
    return null;
  }
}

Future<List<Division>?> getDivisionList() async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_divisions");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)["divisions"];
      return jsonResponse.map((json) => Division.fromJson(json)).toList();
    } else {
      log('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log("$err");
    return null;
  }
}

Future<dynamic> deleteDivision({required String divisionId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/delete_division");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};

  map["division_id"] = divisionId;

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

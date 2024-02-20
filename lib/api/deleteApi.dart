import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/ReviewSectionlistModel.dart';
import 'package:ui/model/verify_subject_model.dart';

import 'package:ui/utils/session_management.dart';

Future<dynamic> deleteNotification(
    {required String grpid, required String notifyid}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/delete_messages");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  //var request = http.MultipartRequest("POST", url);
  map["group_id"] = grpid;

  map["notification_id"] = notifyid;

  // request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  //};
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      //final jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {}
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> onboardingdelete(
    {required String id, required String divid}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/delete_class");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  //var request = http.MultipartRequest("POST", url);
  map["id"] = id;

  map["division_id"] = divid;

  // request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  //};
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      //final jsonResponse = jsonDecode(response.body);
      // ignore: avoid_print

      return jsonDecode(response.body);
    } else {
      // ignore: avoid_print
      print('Onboarding Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> editclassSection({
  required String clasId,
  required String divId,
  required List<ReviewSectionlist> secId,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/delete_class_section");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;

  var request = http.MultipartRequest("POST", url);

  for (int i = 0; i < secId.length; i++) {
    request.fields['data[$i][section_id]'] = secId[i].id.toString();
    request.fields['data[$i][is_checked]'] = secId[i].isChecked.toString();
  }

  // for (int i = 0; i < checked.length; i++) {
  //   request.fields['data[$i][is_checked]'] = checked[i];
  // }

  request.fields['class_id'] = clasId;
  request.fields['division_id'] = divId;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      // ignore: avoid_print
      print(
          'Delete Class and Sec Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> editSubject({
  required String configtype,
  required String updatetyep,
  required String clasId,
  required String divId,
  required List<VerifySubject> secId,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;

  var request = http.MultipartRequest("POST", url);

  for (int i = 0; i < secId.length; i++) {
    request.fields['data[$i][subject_id]'] = secId[i].id.toString();
    request.fields['data[$i][is_checked]'] = secId[i].isChecked.toString();
  }

  // for (int i = 0; i < checked.length; i++) {
  //   request.fields['data[$i][is_checked]'] = checked[i];
  // }

  request.fields['class_config'] = clasId;
  request.fields['division_id'] = divId;
  request.fields['update_type'] = updatetyep;
  request.fields['configuration_type'] = configtype;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      // ignore: avoid_print
      print(
          'Delete Class and Sec Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> deleteSubject(
    {required String subId, required String divid}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/onboarding_delete_subject");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  //var request = http.MultipartRequest("POST", url);

  map["subject_id"] = subId;
  map["division_id"] = divid;

  // request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  //};
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      //final jsonResponse = jsonDecode(response.body);
      // ignore: avoid_print

      return jsonDecode(response.body);
    } else {
      // ignore: avoid_print
      print('Onboarding Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> deleteStaff({required String staffId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/onboarding_delete_staff");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map["id"] = staffId;

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Onboarding Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> deleteManagement({required String managementId}) async {
  var url =
      Uri.parse("${Strings.baseURL}api/user/onboarding_delete_management");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  //var request = http.MultipartRequest("POST", url);

  map["id"] = managementId; //division_

  // request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  //};
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      //final jsonResponse = jsonDecode(response.body);
      // ignore: avoid_print

      return jsonDecode(response.body);
    } else {
      // ignore: avoid_print
      print('Onboarding Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> deleteStudent({required String divid}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/onboarding_delete_parent");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  //var request = http.MultipartRequest("POST", url);

  map["id"] = divid; //division_

  // request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  //};
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      //final jsonResponse = jsonDecode(response.body);
      // ignore: avoid_print

      return jsonDecode(response.body);
    } else {
      // ignore: avoid_print
      print('Onboarding Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> deleteHomework({required String fileId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/delete_homework_attachment");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  //var request = http.MultipartRequest("POST", url);

  map["id"] = fileId; //division_

  // request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  //};
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      //final jsonResponse = jsonDecode(response.body);
      // ignore: avoid_print

      return jsonDecode(response.body);
    } else {
      // ignore: avoid_print
      print('Onboarding Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('changePassword -> error occured: $err.');
    return null;
  }
}

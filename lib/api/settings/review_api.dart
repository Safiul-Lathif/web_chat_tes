import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/model/settings/index.dart';
import 'package:ui/utils/session_management.dart';
import '../../../config/strings.dart';

Future<List<SubjectList>?> getClassSectionSubjectDetails(
    {required int dId, required int cid}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_edit_subjects");
  SessionManager? pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["division_id"] = dId.toString();
  map["class_config"] = cid.toString();

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      print(response.body);
      return jsonResponse.map((json) => SubjectList.fromJson(json)).toList();
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

Future<List<SectionDetail>?> getClassSectionsList({required String dId}) async {
  var url =
      Uri.parse("${Strings.baseURL}api/user/get_combine_class_section_list");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};

  map["division_id"] = dId;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      print(response.body);

      return jsonResponse.map((json) => SectionDetail.fromJson(json)).toList();
    } else {
      log('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log('$err');
    return null;
  }
}

Future<dynamic> submitMappedSubject(
    {required int dId,
    required int cid,
    required List<SubjectList> subjectList}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_edit_subjects");
  SessionManager? pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["division_id"] = dId.toString();
  map["class_config"] = cid.toString();
  for (int i = 0; i < subjectList.length; i++) {
    map['mapsubjects[i][subject_id]'] = subjectList[i].id.toString();
    map['mapsubjects[i][is_checked]'] = subjectList[i].isSelected.toString();
  }

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return response.body;
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

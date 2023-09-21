import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/ReviewSectionlistModel.dart';
import 'package:ui/model/ReviewclassSecModel.dart';

import 'package:ui/utils/session_management.dart';

Future<List<ReviewClasssec>?> getReviewClassSec({required String dId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/class_section_review");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();

  var map = <String, dynamic>{};
  map["division_id"] = dId;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => ReviewClasssec.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

Future<List<ReviewSectionlist>?> getReviewSec(
    {required String dId, required String cId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_class_section");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();

  var map = <String, dynamic>{};
  map["division_id"] = dId;
  map['class_id'] = cId;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((json) => ReviewSectionlist.fromJson(json))
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

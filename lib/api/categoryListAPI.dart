import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/categorylistModel.dart';

import 'package:ui/utils/session_management.dart';

Future<List<Class_>?> getCategoryList() async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_staff_category_class");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)["classes"];
      print(response.body);
      return jsonResponse.map((json) => Class_.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

Future<List<Section>?> getsectionList() async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_staff_category_class");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)["sections"];
      return jsonResponse.map((json) => Section.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

Future<List<Category>?> getTeacherCategoryList() async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_staff_category_class");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)["categories"];
      return jsonResponse.map((json) => Category.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

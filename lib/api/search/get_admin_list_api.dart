// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/search/admin_list_model.dart';
import 'package:ui/utils/session_management.dart';

Future<List<AdminList>?> getAdminList() async {
  var url = Uri.parse("${Strings.baseURL}api/user/all_admin_list");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  try {
    final response = await http
        .post(url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      print(response.body);
      return jsonResponse.map((json) => AdminList.fromJson(json)).toList();
    } else {
      print('management:- Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

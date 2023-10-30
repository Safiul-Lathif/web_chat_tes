// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/search/admin_list_model.dart';
import 'package:ui/utils/session_management.dart';

Future<SearchAdminModel?> getAdminList(int pageNumber) async {
  var url = Uri.parse("${Strings.baseURL}api/user/all_admin_list");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  var map = <String, dynamic>{};
  map["page"] = pageNumber.toString();
  print("pagination of page  $pageNumber");
  try {
    final response = await http.post(url,
        body: pageNumber == 0 ? null : map,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return SearchAdminModel.fromJson(jsonResponse);
    } else {
      print('management:- Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

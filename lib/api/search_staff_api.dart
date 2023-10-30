import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/search_staff_model.dart';
import 'package:ui/utils/session_management.dart';

Future<SearchStaffModel?> getStaffList(int pageNumber) async {
  var url = Uri.parse("${Strings.baseURL}api/user/all_staff_list");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["page"] = pageNumber.toString();

  try {
    final response = await http.post(url,
        body: pageNumber == 0 ? null : map,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(response.body);
      return SearchStaffModel.fromJson(jsonResponse);
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print(err);
    return null;
  }
}

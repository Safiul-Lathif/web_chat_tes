import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/sibling_details_model.dart';
import 'package:ui/utils/session_management.dart';

Future<List<SiblingDetail>?> getSiblingList() async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_siblings_details");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  try {
    final response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => SiblingDetail.fromJson(json)).toList();
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

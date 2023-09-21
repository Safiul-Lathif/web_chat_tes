import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/dashboard/dashboard_model.dart';
import 'package:ui/utils/session_management.dart';

Future<Dashboard?> getDashboardDetails() async {
  var url = Uri.parse("${Strings.baseURL}api/user/users_count");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  try {
    final response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(response.body);
      return Dashboard.fromJson(jsonResponse);
    } else {
      print('Dashboard:Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

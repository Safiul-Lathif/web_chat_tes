import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/search/student_list_model.dart';
import 'package:ui/utils/session_management.dart';

Future<StudentInfo?> getSingleStudentProfile({required String id}) async {
  var url =
      Uri.parse("${Strings.baseURL}api/user/onboarding_fetch_single_parent");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["id"] = id;
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      return StudentInfo.fromJson(jsonResponse);
    } else {
      print('profile:Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

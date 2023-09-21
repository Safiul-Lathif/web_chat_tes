import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/profile_model.dart';

import 'package:ui/utils/session_management.dart';

Future<ProfileModel?> getProfile(
    {required String id, required String role}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/view_profile");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["id"] = id;
  map["user_role"] = role;
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(response.body);
      return ProfileModel.fromJson(jsonResponse);
      // return jsonDecode(response.body);
    } else {
      print('profile:Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';

import 'package:ui/model/fetch_staff_model.dart';

import 'package:ui/utils/session_management.dart';

Future<FetchStaffList?> fetchstaff({required String id}) async {
  var url =
      Uri.parse("${Strings.baseURL}api/user/onboarding_fetch_single_staff");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();

  var map = <String, dynamic>{};
  map["id"] = id;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return FetchStaffList.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

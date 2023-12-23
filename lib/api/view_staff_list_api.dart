import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/settings/index.dart';
import 'package:ui/utils/session_management.dart';

Future<List<StaffListModel>?> getStaffsList() async {
  var url = Uri.parse("${Strings.baseURL}api/user/onboarding_staff_list");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();

  // var map = <String, dynamic>{};

  // map["division_id"] = dId;

  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => StaffListModel.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';

import 'package:ui/model/map_staff_list.dart';

import 'package:ui/utils/session_management.dart';

Future<List<MapStaffList>?> getMapstafflist(
    {required String dId, required String cid, required String subid}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_staff_details");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();

  var map = <String, dynamic>{};

  map["division_id"] = dId;
  map["class_config"] = cid;
  map["subject_id"] = subid;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => MapStaffList.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

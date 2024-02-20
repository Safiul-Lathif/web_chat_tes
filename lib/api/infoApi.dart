import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';

import 'package:ui/model/infoModel.dart';

import 'package:ui/utils/session_management.dart';

Future<Info?> getInfo(String grpid, String notifyid) async {
  var url = Uri.parse("${Strings.baseURL}api/user/message_info");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();
  var map = <String, dynamic>{};
  //var request = http.MultipartRequest("POST", url);
  map["group_id"] = grpid;

  map["notification_id"] = notifyid;

  // request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  //};
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      return Info.fromJson(jsonResponse);
      // return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

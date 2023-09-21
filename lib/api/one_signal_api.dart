import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';

import 'package:ui/utils/session_management.dart';

Future<dynamic> registerDevice(String playerId, String deviceName,
    String externalUserId, String deviceType, String deviceVersion) async {
  var url =
      Uri.parse('${Strings.baseURL}api/user/onesignal_store_device_details');
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map['external_user_id'] = externalUserId;
  map['player_id'] = playerId;
  map['device_name'] = deviceName;
  map['device_type'] = deviceType;
  map['device_version'] = deviceVersion;

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      print(
          ' one signal:- Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  } finally {}
}

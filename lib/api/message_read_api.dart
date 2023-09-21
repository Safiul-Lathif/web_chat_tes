import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/message_read_info_model.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> messageRead(
    {required String msgStatus, required String notifyid}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/message_read");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  //var request = http.MultipartRequest("POST", url);
  map["message_status"] = msgStatus;

  map["notification_id"] = notifyid;

  // request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  //};
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      //final jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print(response.body);
      }
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<List<DeliveredUser>?> getReadinfo(
    String grpid, String notifyid, String communicationType) async {
  var url = Uri.parse("${Strings.baseURL}api/user/message_delivery_details");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["group_id"] = grpid;
  map["notification_id"] = notifyid;
  map['communication_type'] = communicationType;

  print("$grpid , $notifyid, $communicationType");
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)['delivered_users'];
      print("helo $jsonResponse");
      return jsonResponse.map((json) => DeliveredUser.fromJson(json)).toList();
    } else {
      print('read info:-Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print("read info:- $err");
    return null;
  }
}

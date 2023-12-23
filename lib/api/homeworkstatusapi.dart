import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> homeworkStatus(
    {required String aproval,
    required String notifyid,
    required String studentId,
    required String reason}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/update_homework_status");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var map = <String, dynamic>{};
  map["status"] = aproval;
  map["notification_id"] = notifyid;
  map["reason"] = reason;
  map["student_id"] = studentId;
  //};
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('changePassword -> error occured: $err.');
    return null;
  }
}

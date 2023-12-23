import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

import '../model/staff_home_work_model.dart';

Future<dynamic> aproveHomework(
    {required List<StaffHomework> homeworkList}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/homework_approval");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; i < homeworkList.length; i++) {
    if (homeworkList[i].approvalStatus == 0 &&
        homeworkList[i].notificationId != 0) {
      request.fields['notification_id[$i]'] =
          homeworkList[i].notificationId.toString();
    }
  }
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('changePassword -> error occured: $err.');
    return null;
  }
}

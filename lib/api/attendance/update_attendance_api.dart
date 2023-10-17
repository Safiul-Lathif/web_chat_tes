import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/attendance/school_attendance_list_model.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> updateAttendanceList({
  required String classConfig,
  required List<AttendanceSubmitList> attendanceList,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_attendance");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  for (int i = 0; i < attendanceList.length; i++) {
    map['attendance_records[${attendanceList[i].studentId}]'] =
        attendanceList[i].attendanceStatus;
  }
  map["class_config"] = classConfig;

  try {
    print(map);
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(
          'Attendance Update Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('update Attendance -> error occurred: $err.');
    return null;
  }
}

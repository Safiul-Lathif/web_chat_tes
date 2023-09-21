import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/attendance/students_attendance_model.dart';
import 'package:ui/utils/session_management.dart';

Future<List<StudentsAttendanceModel>?> getStudentsAttendanceList(
    String classConfigId) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_attendance");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["class_config"] = classConfigId;

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      print(response.body);
      return jsonResponse
          .map((json) => StudentsAttendanceModel.fromJson(json))
          .toList();
    } else {
      print('student list:Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(" student list :$err");
    return null;
  }
}

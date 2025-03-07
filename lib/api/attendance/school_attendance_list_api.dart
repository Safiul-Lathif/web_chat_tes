import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/attendance/school_attendance_list_model.dart';
import 'package:ui/utils/session_management.dart';

Future<SchoolAttendanceListModel?> getSchoolAttendanceList() async {
  var url =
      Uri.parse("${Strings.baseURL}api/user/attendance_class_section_listing");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      return SchoolAttendanceListModel.fromJson(jsonResponse);
    } else {
      print('Attendance :-Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

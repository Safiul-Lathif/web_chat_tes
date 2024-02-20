import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';
import 'package:ui/model/group/student_group_list_model.dart';

Future<List<StudentGroupList>?> getStudentGroupList(String groupId) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_group_students");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["group_id"] = groupId;
  print("$token , $groupId");
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);

      return jsonResponse
          .map((json) => StudentGroupList.fromJson(json))
          .toList();
    } else {
      print(
          'studentGroup Group:-Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

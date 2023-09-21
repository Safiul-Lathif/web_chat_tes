import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/birthday/birthday_model.dart';
import 'package:ui/utils/session_management.dart';

Future<BirthdayList?> getBirthdayList(String classConfigId) async {
  var url = Uri.parse("${Strings.baseURL}api/user/birthday_student_list");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["class_config"] = classConfigId;

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return BirthdayList.fromJson(jsonDecode(response.body));
    } else {
      print(
          'birthDay List:Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

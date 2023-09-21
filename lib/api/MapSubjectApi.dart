import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/model/mapSubjectModel.dart';
import 'package:ui/utils/session_management.dart';
import '../../../config/strings.dart';

Future<List<SubjectList>?> getSubjectList(
    {required String dId, required String cid}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_edit_subjects");
  SessionManager? pref = SessionManager();
  String? token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      await pref.getAuthToken();

  var map = <String, dynamic>{};
  map["division_id"] = dId;
  map["class_config"] = cid;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => SubjectList.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  } finally {
    pref = null;
  }
}

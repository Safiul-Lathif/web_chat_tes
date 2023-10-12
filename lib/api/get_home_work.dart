import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/class_group_model.dart';
import 'package:ui/utils/session_management.dart';
import 'package:ui/utils/utility.dart';

Future<ClassGroup?> getHomeWork(DateTime homeWorkDate) async {
  var dates = Utility.convertDateFormat(homeWorkDate.toString(), "yyyy-MM-dd");
  var url = Uri.parse(
      "${Strings.baseURL}api/user/classes_group?homework_date=$dates");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(response.body);
      return ClassGroup.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

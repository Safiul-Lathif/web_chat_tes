import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/verify_subject_model.dart';
import 'package:ui/utils/session_management.dart';

Future<List<VerifySubject>?> getVerifySub(
    {required String dId, required String cId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_subjects");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();

  var map = <String, dynamic>{};
  map["division_id"] = dId;
  map['class_id'] = cId;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => VerifySubject.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

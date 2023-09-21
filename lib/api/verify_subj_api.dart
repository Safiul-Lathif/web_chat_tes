import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/verify_subj_model.dart';
import 'package:ui/utils/session_management.dart';

Future<List<Verifysubjecteslist>?> getVerifySubjlist(
    {required String dId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/class_subjects_list");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  // String? playerId = await pref.getPlayerId();

  var map = <String, dynamic>{};
  map["division_id"] = dId;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      // 'sender': playerId
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((json) => Verifysubjecteslist.fromJson(json))
          .toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

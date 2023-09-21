import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';
import 'package:ui/model/group_info_model.dart';

Future<List<GroupInfoModel>?> getGroupInfo(String id) async {
  var url = Uri.parse("${Strings.baseURL}api/user/group_participants");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["group_id"] = id;

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      print('list of participants:${response.body}');
      return jsonResponse.map((json) => GroupInfoModel.fromJson(json)).toList();
    } else {
      print('grp info:Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('error on list of participants: $err');
    return null;
  }
}

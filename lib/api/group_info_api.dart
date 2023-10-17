import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';
import 'package:ui/model/group_info_model.dart';

Future<GroupInfoModel?> getGroupInfo(String id, int page) async {
  var url = Uri.parse("${Strings.baseURL}api/user/group_participants");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["group_id"] = id;
  map["page"] = page.toString();
  print(map);
  try {
    final response = await http.post(url,
        body: page == 0 ? null : map,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(response.body);
      return GroupInfoModel.fromJson(jsonResponse);
    } else {
      log('grp info:Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log('error on list of participants: $err');
    return null;
  }
}

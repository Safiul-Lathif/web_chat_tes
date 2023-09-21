import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';

import 'package:ui/model/MainpageModel.dart';

import 'package:ui/utils/session_management.dart';

Future<MainGroupList?> getMainGroup() async {
  var url = Uri.parse("${Strings.baseURL}api/user/user_group_list");
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
      return MainGroupList.fromJson(jsonResponse);
    } else {
      print('mainGroup:- Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

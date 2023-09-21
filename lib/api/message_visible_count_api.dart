import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/message_visiblecount.dart';

import 'package:ui/utils/session_management.dart';

Future<MessageVisibleCount?> getVisibleCount(String id) async {
  var url = Uri.parse("${Strings.baseURL}api/user/message_visible_count");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  var map = <String, dynamic>{};
  map["group_id"] = id;

  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      //final jsonResponse = jsonDecode(response.body);
      print(response.body);

      return MessageVisibleCount.fromJson(jsonDecode(response.body));
    } else {
      print(
          'msg visible:-Request failed wi th status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

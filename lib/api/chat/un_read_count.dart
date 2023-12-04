import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> getUnreadCount() async {
  var url = Uri.parse("${Strings.baseURL}api/user/unread_count");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      dynamic jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      print(
          'un read count:-Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print("un read count:- $err");
    return null;
  }
}

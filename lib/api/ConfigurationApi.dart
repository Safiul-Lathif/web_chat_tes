import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/configurationModel.dart';

import 'package:ui/utils/session_management.dart';

Future<Configurations?> getConfigList() async {
  var url = Uri.parse("${Strings.baseURL}api/user/configuration_tags");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Configurations.fromJson(jsonResponse);
    } else {
      print('config:- Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print("config:- $err");
    return null;
  }
}

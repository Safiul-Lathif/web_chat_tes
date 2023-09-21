import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/action_required_model.dart';
import 'package:ui/utils/session_management.dart';

Future<List<ActionRequiredModel>?> getActionRequiredList() async {
  var url = Uri.parse("${Strings.baseURL}api/user/approval_action_required");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);

      return jsonResponse
          .map((json) => ActionRequiredModel.fromJson(json))
          .toList();
    } else {
      print('action:-Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print("Action required:- $err");
    return null;
  }
}

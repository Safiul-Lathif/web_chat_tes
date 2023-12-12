import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> addEditDivision(
    {required String divisionName, required int divisionId}) async {
  var url =
      Uri.parse("${Strings.baseURL}api/user/create_update_division_manual");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map["divisions[0][division_name]"] = divisionName;
  if (divisionId != 0) map["divisions[0][division_id]"] = divisionId.toString();
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(
          'create update :Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('create update division -> error occurred: $err.');
    return null;
  }
}

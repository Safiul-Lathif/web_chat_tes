import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> addEditSection(
    {required String sectionName,
    required int sectionId,
    required String divId}) async {
  var url =
      Uri.parse("${Strings.baseURL}api/user/create_update_section_manual");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map['division_id'] = divId;
  map["sections[0][section_name]"] = sectionName;
  if (sectionId != 0) map["sections[0][section_id]"] = sectionId.toString();
  print(map);
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
    print('create update section -> error occurred: $err.');
    return null;
  }
}

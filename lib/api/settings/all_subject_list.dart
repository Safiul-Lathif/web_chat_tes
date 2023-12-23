import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/utils/session_management.dart';
import '../../../config/strings.dart';
import '../../model/categorylistModel.dart';

Future<List<Subject>?> getSubjectList() async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_staff_category_class");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)["subjects"];
      return jsonResponse.map((json) => Subject.fromJson(json)).toList();
    } else {
      log('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    log('$err');
    return null;
  }
}

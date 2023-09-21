import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> register(
    {required String schoolname,
    required String name,
    required String mail,
    required String mobileno,
    required String password,
    required String designation,
    required String academic,
    required String schoolcode}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/register");
  SessionManager pref = SessionManager();
  // Map data = {
  var map = Map<String, dynamic>();
  map["school_name"] = schoolname;
  map["name"] = name;
  map["email"] = mail;
  map["user_mobile_number"] = mobileno;
  map["password"] = password;
  map["designation"] = designation;
  map["academic_year"] = academic;
  map["school_code"] = schoolcode;
  //};
  try {
    final response = await http.post(
      url,
      body: map,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

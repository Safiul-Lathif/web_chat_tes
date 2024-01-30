// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';

Future<dynamic> register(
    {required String schoolName,
    required String name,
    required String mail,
    required String mobileNo,
    required String password,
    required String designation,
    required String academic,
    required String schoolCode}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/register");
  var map = <String, dynamic>{};
  map["school_name"] = schoolName;
  map["name"] = name;
  map["email"] = mail;
  map["user_mobile_number"] = mobileNo;
  map["password"] = password;
  map["designation"] = designation;
  map["academic_year"] = academic;
  map["school_code"] = schoolCode;

  print(map);
  print(url);

  try {
    final response = await http.post(
      url,
      body: map,
    );
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occurred: $err.');
    return null;
  }
}

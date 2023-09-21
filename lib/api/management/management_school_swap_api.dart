import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import '../../model/login_model.dart';

Future<Login?> getManagementSchoolSwap(
    String number, String password, String id, String role) async {
  var url = Uri.parse("${Strings.baseURL}api/user/login");
  var map = <String, dynamic>{};
  map["user_mobile_number"] = number;
  if (password != '') map['password'] = password;
  map['school_profile_id'] = id;
  map['user_role'] = role;
  try {
    final response = await http.post(
      url,
      body: map,
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      return Login.fromJson(jsonResponse);
    } else {
      if (kDebugMode) {
        print(
            'Management School Swap:-Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print("Management School Swap:- $err");
    }
    return null;
  }
}

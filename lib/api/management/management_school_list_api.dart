import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/management/management_school_list.dart';

Future<List<ManagementSchoolList>?> getManagementSchoolList(
    number, role) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_school");
  var map = <String, dynamic>{};
  map["mobile_number"] = number;
  map['user_role'] = role;
  try {
    final response = await http.post(
      url,
      body: map,
    );
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      print(response.body);
      return jsonResponse
          .map((json) => ManagementSchoolList.fromJson(json))
          .toList();
    } else {
      if (kDebugMode) {
        print(
            'Management School List:-Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print("Management School List:- $err");
    }
    return null;
  }
}

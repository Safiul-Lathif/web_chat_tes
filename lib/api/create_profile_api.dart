import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';

Future<dynamic> createProfile({required String token}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/create_profile");
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);

      // return jsonResponse
      //     .map((json) => ActionRequiredModel.fromJson(json))
      //     .toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/config/config_list_model.dart';

Future<ConfigList?> getAllConfigList({required String token}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/configuration_list");
  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return ConfigList.fromJson(jsonDecode(response.body));
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  }
}

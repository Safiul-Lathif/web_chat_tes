import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';
import 'package:http/http.dart' as http;

Future<dynamic> sendNewsText({
  required String title,
  required String msgCategory,
  required String description,
  // required List<XFile> img,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_news_events");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var map = <String, dynamic>{};
  map["title"] = title;
  map["module_type"] = '1';
  map["description"] = description;
  map["news_events_category"] = msgCategory;
  // map["images"] = img;
  //};
  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      if (kDebugMode) {
        print(
            'Send News:- Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print('Send News -> error occurred: $err.');
    }
    return null;
  }
}

Future<dynamic> sendNewsWithImage({
  required List<PlatformFile> img,
  required String title,
  required String msgCategory,
  required String description,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_news_events");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var request = http.MultipartRequest("POST", url);
  // map["chat_message"] = msg;
  for (int i = 0; img.length > i; i++) {
    request.fields["images[$i]"] = base64Encode(img[i].bytes!);
    request.fields["ext[$i]"] = img[i].extension!;
    request.fields["file_name[$i]"] = img[i].name;
  }

  request.fields["title"] = title;
  request.fields["module_type"] = '1';
  request.fields["description"] = description;
  request.fields["news_events_category"] = '2';
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
//};
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

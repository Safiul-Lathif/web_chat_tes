import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> sendNewsText(
    {required String title,
    required String msgCategory,
    required String description,
    required String newsId,
    required String link,
    required List<String> classIds}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_news_events");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  for (int i = 0; i < classIds.length; i++) {
    map['visible_to[$i]'] = classIds[i];
  }
  map["title"] = title;
  map["module_type"] = '1';
  map["description"] = description;
  map["news_events_category"] = msgCategory;
  map['youtube_link'] = link;
  if (newsId != '') map['newsevents_id'] = newsId;

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

Future<dynamic> sendNewsWithImage(
    {required List<PlatformFile> img,
    required String title,
    required String description,
    required String newsId,
    required String link,
    required List<String> classIds}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_news_events");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; img.length > i; i++) {
    request.fields["images[$i]"] = base64Encode(img[i].bytes!);
    request.fields["ext[$i]"] = img[i].extension!;
    request.fields["file_name[$i]"] = img[i].name;
    print(img[i].extension!);
  }
  for (int i = 0; i < classIds.length; i++) {
    request.fields['visible_to[$i]'] = classIds[i];
  }
  request.fields["title"] = title;
  request.fields["module_type"] = '1';
  request.fields["description"] = description;
  request.fields["youtube_link"] = link;
  request.fields["news_events_category"] = description == '' ? '2' : '3';
  if (newsId != '') request.fields['newsevents_id'] = newsId;

  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  print("news id: $newsId");

  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      if (kDebugMode) {
        print(
            ' sendNewsWithImage: -Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print('sendNewsWithImage -> error occurred: $err.');
    }
    return null;
  }
}

Future<dynamic> sendNewsWithMultiImage(
    {required List<PlatformFile> img,
    required String title,
    required String description,
    required String newsId,
    required String link,
    required List<String> classIds}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_news_events");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; img.length > i; i++) {
    request.fields["images[$i]"] = base64Encode(img[i].bytes!);
    request.fields["ext[$i]"] = img[i].extension!;
    request.fields["file_name[$i]"] = img[i].name;
  }
  for (int i = 0; i < classIds.length; i++) {
    request.fields['visible_to[$i]'] = classIds[i];
  }
  request.fields["title"] = title;
  request.fields["module_type"] = '1';
  request.fields["description"] = description;
  request.fields["youtube_link"] = link;
  request.fields["news_events_category"] = description == '' ? '4' : '5';
  if (newsId != '') request.fields['newsevents_id'] = newsId;

  print("news id: $newsId");

  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      if (kDebugMode) {
        print(
            'sendNewsWithMultiImage:- Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print('sendNewsWithMultiImage -> error occurred: $err.');
    }
    return null;
  }
}

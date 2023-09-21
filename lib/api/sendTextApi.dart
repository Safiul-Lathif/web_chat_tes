import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> sendText(
    {required String msg,
    required String distType,
    required String msgCategory,
    required String groupId,
    required String title,
    required String important,
    required List<String> classIds}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  for (int i = 0; i < classIds.length; i++) {
    map['visible_to[$i]'] = classIds[i];
  }
  map["chat_message"] = msg;
  map["distribution_type"] = distType;
  map["message_category"] = msgCategory;
  map["group_id"] = groupId;
  map["title"] = title;
  map["important"] = important;
  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print('changePassword -> error occurred: $err.');
    }
    return null;
  }
}

Future<dynamic> sendImg(
    {
    //Ticket No 31
    required List<PlatformFile> img,
    required String distType,
    required String msgCategory,
    required String groupId,
    required String title,
    required String important,
    required List<String> classIds}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var request = http.MultipartRequest("POST", url);
  // map["chat_message"] = msg;
  for (int i = 0; img.length > i; i++) {
    request.files
        .add(await http.MultipartFile.fromPath('attachment[$i]', img[i].path!));
  }
  for (int i = 0; i < classIds.length; i++) {
    request.fields['visible_to[$i]'] = classIds[i];
  }

  request.fields["distribution_type"] = distType;
  request.fields["message_category"] = msgCategory;
  request.fields["group_id"] = groupId;
  request.fields["caption_message"] = title;

  request.fields["important"] = important;
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

Future<dynamic> sendDocument(
    {required List<PlatformFile> img,
    required String distType,
    required String msgCategory,
    required String groupId,
    required String title,
    required String important,
    required List<String> classIds}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var request = http.MultipartRequest("POST", url);
  // map["chat_message"] = msg;
  for (int i = 0; img.length > i; i++) {
    request.files
        .add(await http.MultipartFile.fromPath('attachment[$i]', img[i].path!));
  }
  for (int i = 0; i < classIds.length; i++) {
    request.fields['visible_to[$i]'] = classIds[i];
  }
  request.fields["distribution_type"] = distType;
  request.fields["message_category"] = msgCategory;
  request.fields["group_id"] = groupId;
  request.fields["caption_message"] = title;
  request.fields["important"] = important;

  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
//};
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print('changePassword -> error occurred: $err.');
    }
    return null;
  }
}

Future<dynamic> sendAudio(
    {required List<PlatformFile> fileList,
    required String distType,
    required String msgCategory,
    required String groupId,
    required String title,
    required String important,
    required List<String> classIds}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var request = http.MultipartRequest("POST", url);
  // map["chat_message"] = msg;
  if (fileList.isNotEmpty && fileList.isNotEmpty) {
    for (int i = 0; fileList.length > i; i++) {
      if (kDebugMode) {
        print(fileList.length);
      }
      if (kDebugMode) {
        print(fileList[i].path);
      }
      request.files.add(await http.MultipartFile.fromPath(
          'attachment[$i]', fileList[i].path.toString()));
    }
    for (int i = 0; i < classIds.length; i++) {
      request.fields['visible_to[$i]'] = classIds[i];
    }
    request.fields["distribution_type"] = distType;
    request.fields["message_category"] = msgCategory;
    request.fields["group_id"] = groupId;
    // request.fields["caption_message"] = title;

    request.fields["important"] = important;
    request.headers.putIfAbsent('Authorization', () => "Bearer $token");
//};
    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        print(respStr);
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
}

Future<dynamic> sendVideo({
  required String msg,
  required String distType,
  required String msgCategory,
  required String groupId,
  required String title,
  required List<String> classIds,
  required String important,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var map = <String, dynamic>{};
  for (int i = 0; i < classIds.length; i++) {
    map['visible_to[$i]'] = classIds[i];
  }
  map["chat_message"] = msg;
  map["distribution_type"] = distType;
  map["message_category"] = msgCategory;
  map["group_id"] = groupId;
  map["caption_message"] = title;
  map["important"] = important;

  //};
  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
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

Future<dynamic> sendCircular(
    {required String msg,
    required String distType,
    required String msgCategory,
    required String groupId,
    required String title,
    required String important,
    required List<String> classIds}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var map = <String, dynamic>{};
  for (int i = 0; i < classIds.length; i++) {
    map['visible_to[$i]'] = classIds[i];
  }
  map["chat_message"] = msg;
  map["distribution_type"] = distType;
  map["message_category"] = msgCategory;
  map["group_id"] = groupId;
  map["title"] = title;
  map["important"] = important;

  //};
  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
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

Future<dynamic> sendSpeaks(
    {required String msg,
    required String distType,
    required String msgCategory,
    required String groupId,
    required String title,
    required String important,
    required List<String> classIds}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;

  // Map data = {
  var map = <String, dynamic>{};
  for (int i = 0; i < classIds.length; i++) {
    map['visible_to[$i]'] = classIds[i];
  }
  map["chat_message"] = msg;
  map["distribution_type"] = distType;
  map["message_category"] = msgCategory;
  map["group_id"] = groupId;
  map["title"] = title;
  map["important"] = important;

  //};
  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
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

Future<dynamic> sendQuotes(
    {required String msg,
    required String distType,
    required String msgCategory,
    required String groupId,
    required String title,
    required String important,
    required List<String> classIds}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  for (int i = 0; i < classIds.length; i++) {
    map['visible_to[$i]'] = classIds[i];
  }
  map["chat_message"] = msg;
  map["distribution_type"] = distType;
  map["message_category"] = msgCategory;
  map["group_id"] = groupId;
  map["title"] = title;
  map["important"] = important;
  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
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

Future<dynamic> sendHomework({
  required List<PlatformFile> fileList,
  required String classConfig,
  required String msgCategory,
  required String subId,
  required String msg,
  required String notifyId,
  required String homedate,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_homework");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var request = http.MultipartRequest("POST", url);
  // map["chat_message"] = msg;
  // ignore: prefer_is_empty
  if (fileList.isNotEmpty && fileList.length > 0) {
    for (int i = 0; fileList.length > i; i++) {
      request.files.add(await http.MultipartFile.fromPath(
          'attachment[$i]', fileList[i].path.toString()));
    }
  }
  request.fields["class_config"] = classConfig;
  request.fields["message_category"] = msgCategory;
  request.fields["subject_id"] = subId;
  request.fields["message"] = msg;
  request.fields['notification_id'] = notifyId;
  request.fields['homework_date'] = homedate;
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
    // ignore: duplicate_ignore
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> sendHomeworkedit({
  required dynamic fileList,
  required String classConfig,
  required String msgCategory,
  required String subId,
  required String msg,
  required String notifyId,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_homework");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var request = http.MultipartRequest("POST", url);
  // map["chat_message"] = msg;
  // ignore: prefer_is_empty
  //if (fileList.isNotEmpty && fileList.length > 0) {
  for (int i = 0; fileList.length > i; i++) {
    request.fields['attachment[$i]'] = fileList[i].toString();
  }
  //}

  request.fields["class_config"] = classConfig;
  request.fields["message_category"] = msgCategory;
  request.fields["subject_id"] = subId;
  request.fields["message"] = msg;
  request.fields['notification_id'] = notifyId;
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
    // ignore: duplicate_ignore
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

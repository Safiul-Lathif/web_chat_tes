// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> sendText({
  required String msg,
  required String distType,
  required String msgCategory,
  required String groupId,
  required String title,
  required String important,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var map = <String, dynamic>{};
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

Future<dynamic> sendImg({
  required List<PlatformFile> img,
  required String distType,
  required String msgCategory,
  required String groupId,
  required String title,
  required String important,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var request = http.MultipartRequest("POST", url);
  // map["chat_message"] = msg;
  for (int i = 0; img.length > i; i++) {
    request.fields["attachment[$i]"] = base64Encode(img[i].bytes!);
    request.fields["ext[$i]"] = img[i].extension!;
    request.fields["file_name[$i]"] = img[i].name;
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

Future<dynamic> sendAudio({
  required List<PlatformFile> fileList,
  required String distType,
  required String msgCategory,
  required String groupId,
  required String title,
  required String important,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var request = http.MultipartRequest("POST", url);
  // map["chat_message"] = msg;
  if (fileList.isNotEmpty && fileList.length > 0) {
    for (int i = 0; fileList.length > i; i++) {
      request.fields["attachment[$i]"] = base64Encode(fileList[i].bytes!);
      request.fields["ext[$i]"] = fileList[i].extension!;
      request.fields["file_name[$i]"] = fileList[i].name;
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
  required String important,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var map = <String, dynamic>{};
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

Future<dynamic> sendCircular({
  required String msg,
  required String distType,
  required String msgCategory,
  required String groupId,
  required String title,
  required String important,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var map = <String, dynamic>{};
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

Future<dynamic> sendSpeaks({
  required String msg,
  required String distType,
  required String msgCategory,
  required String groupId,
  required String title,
  required String important,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var map = <String, dynamic>{};
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

Future<dynamic> sendQuotes({
  required String msg,
  required String distType,
  required String msgCategory,
  required String groupId,
  required String title,
  required String important,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_message");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  // Map data = {
  var map = <String, dynamic>{};
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
  var map = <String, dynamic>{};

  map["class_config"] = classConfig;
  map["message_category"] = msgCategory;
  map["subject_id"] = subId;
  map["message"] = msg;
  map['notification_id'] = notifyId;
  map['homework_date'] = homedate;
  for (int i = 0; fileList.length > i; i++) {
    map["attachment[$i]"] = base64Encode(fileList[i].bytes!);
    map["ext[$i]"] = fileList[i].extension!;
    map["file_name[$i]"] = fileList[i].name;
  }
  log("$map");
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

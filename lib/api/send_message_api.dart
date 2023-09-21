import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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
  required List<XFile> img,
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
    request.files
        .add(await http.MultipartFile.fromPath('attachment[$i]', img[i].path));
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
      print(fileList.length);
      print(fileList[i].path);
      request.files.add(await http.MultipartFile.fromPath(
          'attachment[$i]', fileList[i].path.toString()));
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

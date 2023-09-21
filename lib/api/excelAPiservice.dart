import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> uploadExcel({
  required String configtype,
  required String updatetyep,
  // required List<PlatformFile> fileList,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  // var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  var request = http.MultipartRequest("POST", url);

  // if (fileList.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', fileList[0].path!));
  //   }
  request.fields['update_type'] = updatetyep;
  request.fields['configuration_type'] = configtype;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    // await http.post(
    //   url,
    //   body: map,
    // );
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

Future<dynamic> addData({
  required String configType,
  required String updateType,
  required String divId,
  required List<String> data,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  // var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  for (int i = 0; i < data.length; i++) {
    if (configType == "classes") {
      request.fields['data[$i][class_name]'] = data[i];
    } else if (configType == "sections") {
      request.fields['data[$i][section_name]'] = data[i];
    } else if (configType == "subjects") {
      request.fields['data[$i][subject_name]'] = data[i];
    }
  }

  request.fields['division_id'] = divId;

  request.fields['update_type'] = updateType;
  request.fields['configuration_type'] = configType;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print('classes Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> manualDivisionData({
  required String configType,
  required String updateType,
  required List<String> data,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;

  var request = http.MultipartRequest("POST", url);

  for (int i = 0; i < data.length; i++) {
    request.fields['data[$i][division_name]'] = data[i];
  }
  request.fields['update_type'] = updateType;
  request.fields['configuration_type'] = configType;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    // await http.post(
    //   url,
    //   body: map,
    // );
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

Future<dynamic> manualDataStaff({
  required String configType,
  required String updateType,
  required String teacherCategory,
  required String name,
  required String mob,
  required String mail,
  required String special,
  required String classTeacher,
  required String classSection,
  // required List<String> photo,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  // var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  // for (int i = 0; i < photo.length; i++) {
  //   request.fields['data[$i][photo]'] = photo[i];
  // }
  // for (int i = 0; i < name.length; i++) {
  request.fields['data[0][staff_name]'] = name;
  // }
  // for (int i = 0; i < mob.length; i++) {
  request.fields['data[0][mobile_number]'] = mob;
  // }
  // for (int i = 0; i < mail.length; i++) {
  request.fields['data[0][email_address]'] = mail;
  // }
  // for (int i = 0; i < tcategory.length; i++) {
  request.fields['data[0][teacher_category]'] = teacherCategory;
  // }
  // for (int i = 0; i < special.length; i++) {
  request.fields['data[0][specialized_in]'] = special;
  // }
  // for (int i = 0; i < ctclass.length; i++) {
  request.fields['data[0][class_teacher]'] = classTeacher;
  // }
  // for (int i = 0; i < ctsec.length; i++) {
  request.fields['data[0][class_section]'] = classSection;
  //}
  request.fields['update_type'] = updateType;
  request.fields['configuration_type'] = configType;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    // await http.post(
    //   url,
    //   body: map,
    // );
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          'Request failed with status: ${response.statusCode} + ${response.stream.bytesToString()}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> editManualDataStaff({
  required String id,
  required String teacherCategory,
  required String name,
  required String mob,
  required String mail,
  required String special,
  required String classTeacher,
  required String classConfig,
  // required List<String> photo,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/onboarding_edit_staff");
  SessionManager pref = SessionManager();
  String token;
  token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  // var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  // for (int i = 0; i < photo.length; i++) {
  //   request.fields['data[$i][photo]'] = photo[i];
  // }

  map['staff_name'] = name;
  map['mobile_number'] = mob;
  map['email_address'] = mail;
  map['teacher_category'] = teacherCategory;
  map['specialized_in'] = special;
  map['class_teacher'] = classTeacher;
  map['class_config'] = classConfig;
  map['id'] = id;

  // request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
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

Future<dynamic> manualDataManagement({
  required String configType,
  required String updateType,
  required String designation,
  required String name,
  required String mobileNumber,
  required String mail,
  // required List<String> photo,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token =
      //"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  // var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  // for (int i = 0; i < photo.length; i++) {
  //   request.fields['data[$i][photo]'] = photo[i];
  // }
  for (int i = 0; i < name.length; i++) {
    request.fields['data[0][management_person_name]'] = name;
  }
  for (int i = 0; i < mobileNumber.length; i++) {
    request.fields['data[0][mobile_number]'] = mobileNumber;
  }
  for (int i = 0; i < mail.length; i++) {
    request.fields['data[0][email_address]'] = mail;
  }
  for (int i = 0; i < designation.length; i++) {
    request.fields['data[0][designation]'] = designation;
  }
  request.fields['update_type'] = updateType;
  request.fields['configuration_type'] = configType;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          'Request failed with status: ${response.statusCode} + ${response.stream.bytesToString()}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> editManualDataManagement({
  required String id,
  required String designation,
  required String name,
  required String mob,
  required String mail,
  // required List<String> photo,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/onboarding_edit_management");
  SessionManager pref = SessionManager();
  String token;
  token =
      //"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;

  var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  // for (int i = 0; i < photo.length; i++) {
  //   request.fields['data[$i][photo]'] = photo[i];
  // }

  request.fields['management_name'] = name;

  request.fields['mobile_number'] = mob;

  request.fields['email_address'] = mail;

  request.fields['user_Category'] = designation;

  request.fields['id'] = id;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          'Request failed with status: ${response.statusCode} + ${response.stream.bytesToString()}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> manualdataStudent({
  required String configtype,
  required String updatetyep,
  // required List<String> photo,
  required String fname,
  required String mname,
  required String gname,
  required String fmob,
  required String mmob,
  required String gmob,
  required String fmail,
  required String mmail,
  required String gmail,
  required String id,
  required String gender,
  required String rollno,
  required String temporaryStud,
  required String sname,
  required String clasname,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token =
      //"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  // var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  // for (int i = 0; i < photo.length; i++) {
  //   request.fields['data[$i][photo]'] = photo[i];
  // }
  for (int i = 0; i < sname.length; i++) {
    request.fields['data[0][student_name]'] = sname;
  }
  for (int i = 0; i < fname.length; i++) {
    request.fields['data[0][father_name]'] = fname;
  }
  for (int i = 0; i < mname.length; i++) {
    request.fields['data[0][mother_name]'] = mname;
  }
  for (int i = 0; i < gname.length; i++) {
    request.fields['data[0][gaurdian_name]'] = gname;
  }
  for (int i = 0; i < fmob.length; i++) {
    request.fields['data[0][father_mobile_number]'] = fmob;
  }
  for (int i = 0; i < mmob.length; i++) {
    request.fields['data[0][mother_mobile_number]'] = mmob;
  }
  for (int i = 0; i < gmob.length; i++) {
    request.fields['data[0][gaurdian_mobile_number]'] = gmob;
  }
  for (int i = 0; i < fmail.length; i++) {
    request.fields['data[0][father_email_address]'] = fmail;
  }
  for (int i = 0; i < mmail.length; i++) {
    request.fields['data[0][mother_email_address]'] = mmail;
  }
  for (int i = 0; i < gmail.length; i++) {
    request.fields['data[0][gaurdian_email_address]'] = gmail;
  }
  for (int i = 0; i < id.length; i++) {
    request.fields['data[0][admission_no]'] = id;
  }
  for (int i = 0; i < gender.length; i++) {
    request.fields['data[0][gender]'] = gender;
  }
  // for (int i = 0; i < clasname.length; i++) {
  request.fields['class_config'] = clasname;
  //  }
  for (int i = 0; i < rollno.length; i++) {
    request.fields['data[0][rollno]'] = rollno;
  }
  for (int i = 0; i < temporaryStud.length; i++) {
    request.fields['data[0][temporary_student]'] = temporaryStud;
  }
  request.fields['update_type'] = updatetyep;
  request.fields['configuration_type'] = configtype;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    // await http.post(
    //   url,
    //   body: map,
    // );
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          'Request failed with status: ${response.statusCode} + ${response.stream.bytesToString()}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> editmanualdataStudent({
  required String fId,
  required String mId,
  required String gId,
  required String sId,
  // required List<String> photo,
  required String fname,
  required String mname,
  required String gname,
  required String fmob,
  required String mmob,
  required String gmob,
  required String fmail,
  required String mmail,
  required String gmail,
  required String id,
  required String gender,
  required String rollno,
  // required String temporaryStud,
  required String sname,
  required String clasname,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/onboarding_edit_parent");
  SessionManager pref = SessionManager();
  String token;
  token =
      //"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  // var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  // for (int i = 0; i < photo.length; i++) {
  //   request.fields['data[$i][photo]'] = photo[i];
  // }
  for (int i = 0; i < sname.length; i++) {
    request.fields['data[0][student_name]'] = sname;
  }
  for (int i = 0; i < fname.length; i++) {
    request.fields['data[0][father_name]'] = fname;
  }
  for (int i = 0; i < mname.length; i++) {
    request.fields['data[0][mother_name]'] = mname;
  }
  for (int i = 0; i < gname.length; i++) {
    request.fields['data[0][gaurdian_name]'] = gname;
  }
  for (int i = 0; i < fmob.length; i++) {
    request.fields['data[0][father_mobile_number]'] = fmob;
  }
  for (int i = 0; i < mmob.length; i++) {
    request.fields['data[0][mother_mobile_number]'] = mmob;
  }
  for (int i = 0; i < gmob.length; i++) {
    request.fields['data[0][gaurdian_mobile_number]'] = gmob;
  }
  for (int i = 0; i < fmail.length; i++) {
    request.fields['data[0][father_email_address]'] = fmail;
  }
  for (int i = 0; i < mmail.length; i++) {
    request.fields['data[0][mother_email_address]'] = mmail;
  }
  for (int i = 0; i < gmail.length; i++) {
    request.fields['data[0][gaurdian_email_address]'] = gmail;
  }
  for (int i = 0; i < id.length; i++) {
    request.fields['data[0][admission_no]'] = id;
  }
  for (int i = 0; i < gender.length; i++) {
    request.fields['data[0][gender]'] = gender;
  }
  // for (int i = 0; i < clasname.length; i++) {
  request.fields['class_config'] = clasname;
  //  }
  for (int i = 0; i < rollno.length; i++) {
    request.fields['data[0][rollno]'] = rollno;
  }
  // for (int i = 0; i < temporaryStud.length; i++) {
  //   request.fields['data[0][temporary_student]'] = temporaryStud;
  // }
  request.fields['father_id'] = fId;
  request.fields['mother_id'] = mId;
  request.fields['gaurdian_id'] = gId;
  request.fields['student_id'] = sId;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    // await http.post(
    //   url,
    //   body: map,
    // );
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          'Request failed with status: ${response.statusCode} + ${response.stream.bytesToString()}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> manualdivision({
  required String configtype,
  required String updatetyep,
  required List<String> secOrclassName,
  required int dId,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  // var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  for (int i = 0; i < secOrclassName.length; i++) {
    request.fields['data[$i][section_name]'] = secOrclassName[i];
  }

  request.fields['division_id'] = dId.toString();

  request.fields['update_type'] = updatetyep;
  request.fields['configuration_type'] = configtype;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    // await http.post(
    //   url,
    //   body: map,
    // );
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

Future<dynamic> manualdivisionClass({
  required String configtype,
  required String updatetyep,
  required List<String> secOrclassName,
  required int dId,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  // var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  for (int i = 0; i < secOrclassName.length; i++) {
    request.fields['data[$i][class_name]'] = secOrclassName[i];
  }

  request.fields['division_id'] = dId.toString();

  request.fields['update_type'] = updatetyep;
  request.fields['configuration_type'] = configtype;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    // await http.post(
    //   url,
    //   body: map,
    // );
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

Future<dynamic> contactStaff({
  required String configtype,
  required String updatetyep,
  // required List<String> photo,
  required List<String> name,
  required List<String> mob,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  // var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  // for (int i = 0; i < photo.length; i++) {
  //   request.fields['data[$i][photo]'] = photo[i];
  // }
  for (int i = 0; i < name.length; i++) {
    request.fields['data[$i][staff_name]'] = name[i];
  }
  for (int i = 0; i < mob.length; i++) {
    request.fields['data[$i][mobile_number]'] = mob[i];
  }
  request.fields['update_type'] = updatetyep;
  request.fields['configuration_type'] = configtype;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    // await http.post(
    //   url,
    //   body: map,
    // );
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          'Request failed with status: ${response.statusCode} + ${response.stream.bytesToString()}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> verifyStaffs({
  required String configtype,
  required String updatetyep,
  required String divId,
  required String clsConfig,
  required List<String> subId, //SelectedStaffList
  required List<String> stafId, //MapStaffList
  required List<String> isChecked,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  // var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  for (int i = 0; i < subId.length; i++) {
    request.fields['data[$i][subject_id]'] = subId[i].toString();
  }
  for (int i = 0; i < stafId.length; i++) {
    request.fields['data[$i][staff_id]'] = stafId[i].toString();
  }
  for (var i = 0; i < isChecked.length; i++) {
    request.fields['data[$i][is_checked]'] = isChecked[i].toString();
  }
  request.fields['division_id'] = divId;
  request.fields['class_config'] = clsConfig;
  request.fields['update_type'] = updatetyep;
  request.fields['configuration_type'] = configtype;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    // await http.post(
    //   url,
    //   body: map,
    // );
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          'Request failed with status: ${response.statusCode} + ${response.stream.bytesToString()}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> contactManagement({
  required String configType,
  required String updateType,
  //required List<String> photo,
  required List<String> name,
  required List<String> mob,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  // var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  // for (int i = 0; i < photo.length; i++) {
  //   request.fields['data[$i][photo]'] = photo[i];
  // }
  for (int i = 0; i < name.length; i++) {
    request.fields['data[$i][management_person_name]'] = name[i];
  }
  for (int i = 0; i < mob.length; i++) {
    request.fields['data[$i][mobile_number]'] = mob[i];
  }
  request.fields['update_type'] = updateType;
  request.fields['configuration_type'] = configType;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    // await http.post(
    //   url,
    //   body: map,
    // );
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          'Request failed with status: ${response.statusCode} + ${response.stream.bytesToString()}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> contactStudent({
  required String configtype,
  required String updatetyep,
  // required List<String> photo,
  required List<String> name,
  required List<String> mob,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/import_configuration");
  SessionManager pref = SessionManager();
  String token;
  token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      (await pref.getAuthToken())!;
  // Map data = {
  // var map = <String, dynamic>{};
  // map["configuration_type"] = configtype;
  // map["update_type"] = updatetyep;
  // map["import_file"] = file;
  //};
  var request = http.MultipartRequest("POST", url);

  // if (data.isNotEmpty) {
  //   for (int i = 0; 10 > i; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('import_file', data[0].!));
  //   }
  // for (int i = 0; i < photo.length; i++) {
  //   request.fields['data[$i][photo]'] = photo[i];
  // }
  for (int i = 0; i < name.length; i++) {
    request.fields['data[$i][father_name]'] = name[i];
  }
  for (int i = 0; i < mob.length; i++) {
    request.fields['data[$i][mobile_number]'] = mob[i];
  }
  request.fields['update_type'] = updatetyep;
  request.fields['configuration_type'] = configtype;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    // await http.post(
    //   url,
    //   body: map,
    // );
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          'Request failed with status: ${response.statusCode} + ${response.stream.bytesToString()}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

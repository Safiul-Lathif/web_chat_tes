// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/settings/index.dart';
import 'package:ui/utils/session_management.dart';

class StudentController {
  SessionManager pref = SessionManager();
  var getAllParentUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_parent_list");
  var getSingleParentUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_fetch_single_parent");
  var createParentUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_create_students");
  var editParentUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_edit_parent");
  var deleteParentUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_delete_parent");
  var getParentCategoryUrl =
      Uri.parse("${Strings.baseURL}api/user/get_parent_category");

  Future<List<ParentList>?> getAllParentList() async {
    String? token = await pref.getAuthToken();
    try {
      final response = await http.get(getAllParentUrl, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        print(response.body);
        return jsonResponse.map((json) => ParentList.fromJson(json)).toList();
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } on Error catch (err) {
      print(err);
      return null;
    }
  }

  Future<SingleParent?> fetchSingleStaff({required int id}) async {
    print(id);
    String? token = await pref.getAuthToken();
    var map = <String, dynamic>{};
    map["id"] = id.toString();

    try {
      final response = await http.post(getSingleParentUrl, body: map, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(response.body);
        return SingleParent.fromJson(jsonResponse);
      } else {
        print('Request failed with status: ${response.body}.');
        return null;
      }
    } on Error catch (err) {
      print(err);
      return null;
    }
  }

  Future<dynamic> addParent({
    required SingleParent student,
    required List<PlatformFile> fatherPhoto,
    required List<PlatformFile> motherPhoto,
    required List<PlatformFile> guardianPhoto,
    required List<PlatformFile> studentPhoto,
  }) async {
    String token;
    token = (await pref.getAuthToken())!;
    var map = <String, dynamic>{};
    map["data[0][student_name]"] = student.studentName;
    map["data[0][father_mobile_number]"] =
        student.fatherMobileNumber.toString();
    map["data[0][father_email_address]"] =
        student.fatherEmailAddress.toString();
    map["data[0][father_name]"] = student.fatherName.toString();
    map["data[0][mother_mobile_number]"] =
        student.motherMobileNumber.toString();
    map["data[0][mother_email_address]"] =
        student.motherEmailAddress.toString();
    map["data[0][mother_name]"] = student.motherName.toString();
    map["data[0][guardian_mobile_number]"] =
        student.guardianMobileNumber.toString();
    map["data[0][guardian_email_address]"] =
        student.guardianEmailAddress.toString();
    map["data[0][guardian_name]"] = student.guardianName;
    map["data[0][admission_no]"] = student.admissionNumber.toString();
    map["data[0][roll_no]"] = student.rollNo.toString();
    map["data[0][dob]"] = student.dob.toString();
    map["data[0][gender]"] = student.gender.toString();
    for (int i = 0; i < fatherPhoto.length; i++) {
      map["data[0][father_photo]"] = base64Encode(fatherPhoto[i].bytes!);
      map["data[0][father_ext]"] = fatherPhoto[i].extension.toString();
      map["data[0][father_file_name]"] = fatherPhoto[i].name;
    }
    for (int i = 0; i < motherPhoto.length; i++) {
      map["data[0][mother_photo]"] = base64Encode(motherPhoto[i].bytes!);
      map["data[0][mother_ext]"] = motherPhoto[i].extension.toString();
      map["data[0][mother_file_name]"] = motherPhoto[i].name;
    }
    for (int i = 0; i < guardianPhoto.length; i++) {
      map["data[0][guardian_photo]"] = base64Encode(guardianPhoto[i].bytes!);
      map["data[0][guardian_ext]"] = motherPhoto[i].extension.toString();
      map["data[0][guardian_file_name]"] = motherPhoto[i].name;
    }
    for (int i = 0; i < studentPhoto.length; i++) {
      map["data[0][student_photo]"] = base64Encode(studentPhoto[i].bytes!);
      map["data[0][student_ext]"] = studentPhoto[i].extension.toString();
      map["data[0][student_file_name"] = studentPhoto[i].name;
    }
    map["data[0][class_config]"] = student.classSection.toString();
    print(map);
    try {
      final response = await http.post(createParentUrl,
          body: map,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } on Error catch (err) {
      print('create edit staff -> error occurred: $err.');
      return null;
    }
  }

  Future<dynamic> editParent({
    required SingleParent student,
    required List<PlatformFile> fatherPhoto,
    required List<PlatformFile> motherPhoto,
    required List<PlatformFile> guardianPhoto,
    required List<PlatformFile> studentPhoto,
  }) async {
    String token;
    token = (await pref.getAuthToken())!;
    var map = <String, dynamic>{};
    map["student_id"] = student.studentId.toString();
    map["student_name"] = student.studentName;
    map["father_mobile_number"] = student.fatherMobileNumber.toString();
    map["father_email_address"] = student.fatherEmailAddress.toString();
    map["father_name"] = student.fatherName.toString();
    map["father_id"] = student.fatherId.toString();
    map["mother_mobile_number"] = student.motherMobileNumber.toString();
    map["mother_email_address"] = student.motherEmailAddress.toString();
    map["mother_name"] = student.motherName.toString();
    map["mother_id"] = student.motherId.toString();
    map["guardian_mobile_number"] = student.guardianMobileNumber.toString();
    map["guardian_email_address"] = student.guardianEmailAddress.toString();
    map["guardian_name"] = student.guardianName;
    map["guardian_id"] = student.guardianId.toString();
    map["admission_no"] = student.admissionNumber.toString();
    map["roll_no"] = student.rollNo.toString();
    map["dob"] = student.dob.toString();
    map["gender"] = student.gender.toString();
    for (int i = 0; i < fatherPhoto.length; i++) {
      map["father_photo"] = base64Encode(fatherPhoto[i].bytes!);
      map["father_ext"] = fatherPhoto[i].extension.toString();
      map["father_file_name"] = fatherPhoto[i].name;
    }
    for (int i = 0; i < motherPhoto.length; i++) {
      map["mother_photo"] = base64Encode(motherPhoto[i].bytes!);
      map["mother_ext"] = motherPhoto[i].extension.toString();
      map["mother_file_name"] = motherPhoto[i].name;
    }
    for (int i = 0; i < guardianPhoto.length; i++) {
      map["guardian_photo"] = base64Encode(guardianPhoto[i].bytes!);
      map["guardian_ext"] = motherPhoto[i].extension.toString();
      map["guardian_file_name"] = motherPhoto[i].name;
    }
    for (int i = 0; i < studentPhoto.length; i++) {
      map["student_photo"] = base64Encode(studentPhoto[i].bytes!);
      map["student_ext"] = studentPhoto[i].extension.toString();
      map["student_file_name"] = studentPhoto[i].name;
    }
    map["class_config"] = student.classSection.toString();
    print(map);
    try {
      final response = await http.post(editParentUrl,
          body: map,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } on Error catch (err) {
      print('create edit staff -> error occurred: $err.');
      return null;
    }
  }

  Future<dynamic> deleteParent({required String id}) async {
    String token;
    token = (await pref.getAuthToken())!;
    var map = <String, dynamic>{};
    map["id"] = id;

    try {
      final response = await http.post(deleteParentUrl,
          body: map,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode == 200) {
        print(response.body);

        return jsonDecode(response.body);
      } else {
        print('Onboarding Request failed with status: ${response.statusCode}.');
        return null;
      }
    } on Error catch (err) {
      print('changePassword -> error occurred: $err.');
      return null;
    }
  }

  Future<List<ParentCategoryList>?> getParentCategoryList() async {
    SessionManager pref = SessionManager();
    String? token = await pref.getAuthToken();
    try {
      final response = await http.get(getParentCategoryUrl, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body)["categories"];
        return jsonResponse
            .map((json) => ParentCategoryList.fromJson(json))
            .toList();
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } on Error catch (err) {
      print(err);
      return null;
    }
  }
}

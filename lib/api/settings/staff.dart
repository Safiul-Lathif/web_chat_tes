// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/fetch_staff_model.dart';
import 'package:ui/model/settings/index.dart';
import 'package:ui/utils/session_management.dart';

class StaffController {
  SessionManager pref = SessionManager();
  var getAllStaffUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_staff_list");
  var getSingleStaffUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_fetch_single_staff");
  var createStaffUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_create_user");
  var editStaffUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_edit_staff");
  var deleteStaffUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_delete_staff");
  var staffCategoryUrl =
      Uri.parse("${Strings.baseURL}api/user/get_staff_category_class");

  Future<List<StaffListModel>?> getAllStaffList() async {
    String? token = await pref.getAuthToken();
    try {
      final response = await http.get(getAllStaffUrl, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse
            .map((json) => StaffListModel.fromJson(json))
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

  Future<FetchStaffList?> fetchSingleStaff({required String id}) async {
    String? token = await pref.getAuthToken();
    var map = <String, dynamic>{};
    map["id"] = id;

    try {
      final response = await http.post(getSingleStaffUrl, body: map, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        return FetchStaffList.fromJson(jsonResponse);
      } else {
        print('Request failed with status: ${response.body}.');
        return null;
      }
    } on Error catch (err) {
      print(err);
      return null;
    }
  }

  Future<dynamic> addStaff({
    required FetchStaffList staffList,
    required List<PlatformFile> profileImage,
    required int divId,
  }) async {
    String token;
    token = (await pref.getAuthToken())!;
    var map = <String, dynamic>{};
    map['role'] = '2';
    map["data[0][name]"] = staffList.firstName.toString();
    map["data[0][division_id]"] = divId.toString();
    map["data[0][mobile_number]"] = staffList.mobileNumber.toString();
    map["data[0][specialized_in]"] = staffList.specializedIn.toString();
    map["data[0][class_teacher_class_config]"] =
        staffList.classConfig == 0 ? '' : staffList.classConfig.toString();
    for (int i = 0; i < profileImage.length; i++) {
      map["data[0][photo]"] = base64Encode(profileImage[i].bytes!);
      map["data[0][ext]"] = profileImage[i].extension!.toString();
      map["data[0][file_name]"] = profileImage[i].name.toString();
    }
    map["data[0][dob]"] = staffList.dob.toString();
    map["data[0][doj]"] = staffList.doj.toString();
    map["data[0][employee_no]"] = staffList.employeeNumber.toString();
    map["data[0][email_address]"] = staffList.emailId.toString();
    map["data[0][user_category]"] = staffList.userCategory.toString();
    for (int i = 0; i < staffList.subjectTeacher.length; i++) {
      map["data[0][teacher_class_config][i][class_config]"] =
          staffList.subjectTeacher[i].classConfig.toString();
      map["data[0][teacher_class_config][i][subject_id]"] =
          staffList.subjectTeacher[i].subject.toString();
    }

    try {
      final response = await http.post(createStaffUrl,
          body: map,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode == 200) {
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

  Future<dynamic> editStaff({
    required FetchStaffList staffList,
    required List<PlatformFile> profileImage,
    required int divId,
  }) async {
    String token;
    token = (await pref.getAuthToken())!;
    var map = <String, dynamic>{};
    map['id'] = staffList.id.toString();
    map['staff_name'] = staffList.firstName.toString();
    map['division_id'] = divId.toString();
    map['mobile_number'] = staffList.mobileNumber.toString();
    map['specialized_in'] = staffList.specializedIn.toString();
    map['class_teacher_class_config'] =
        staffList.classConfig == 0 ? '' : staffList.classConfig.toString();
    for (int i = 0; i < profileImage.length; i++) {
      map['photo'] = base64Encode(profileImage[i].bytes!);
      map['ext'] = profileImage[i].extension!.toString();
      map['file_name'] = profileImage[i].name.toString();
    }
    map['dob'] = staffList.dob.toString();
    map['doj'] = staffList.doj.toString();
    map['employee_no'] = staffList.employeeNumber.toString();
    map['email_address'] = staffList.emailId.toString();
    map['teacher_category'] = staffList.userCategory.toString();
    for (int i = 0; i < staffList.subjectTeacher.length; i++) {
      map['teacher_class_config'][i]['class_config'] =
          staffList.subjectTeacher[i].classConfig.toString();
      map['teacher_class_config'][i]['subject_id'] =
          staffList.subjectTeacher[i].subject.toString();
    }

    try {
      final response = await http.post(editStaffUrl,
          body: map,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode == 200) {
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

  Future<dynamic> deleteStaff({required String staffId}) async {
    String token;
    token = (await pref.getAuthToken())!;
    var map = <String, dynamic>{};
    map["id"] = staffId;

    try {
      final response = await http.post(deleteStaffUrl,
          body: map,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode == 200) {
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

  Future<ParentCategory?> getTeacherCategoryList() async {
    SessionManager pref = SessionManager();
    String? token = await pref.getAuthToken();
    try {
      final response = await http.get(staffCategoryUrl, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return ParentCategory.fromJson(jsonResponse);
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

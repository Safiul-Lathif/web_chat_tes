// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/settings/management_model.dart';
import 'package:ui/utils/session_management.dart';
import '../../model/search/management_list_model.dart';
import '../../model/settings/designation_model.dart';

class ManagementController {
  SessionManager pref = SessionManager();
  var getManagementUrl =
      Uri.parse("${Strings.baseURL}api/user/get_management_list");
  var getManagementDesignationUrl =
      Uri.parse("${Strings.baseURL}api/user/get_management_designation");
  var fetchSingleManagementUrl = Uri.parse(
      "${Strings.baseURL}api/user/onboarding_fetch_single_management");
  var createManagementUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_create_user");
  var editManagementUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_edit_management");
  var deleteManagementUrl =
      Uri.parse("${Strings.baseURL}api/user/onboarding_delete_management");

  Future<List<ManagementListModel>?> getManagementList() async {
    String? token = await pref.getAuthToken();
    try {
      final response = await http.get(getManagementUrl, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        print(response.body);
        return jsonResponse
            .map((json) => ManagementListModel.fromJson(json))
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

  Future<List<DesignationList>?> getManagementCategoryList() async {
    String? token = await pref.getAuthToken();
    try {
      final response = await http.get(getManagementDesignationUrl, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        print(response.body);
        return jsonResponse
            .map((json) => DesignationList.fromJson(json))
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

  Future<ManagementList?> fetchSingleManagementList(
      {required String id}) async {
    String? token = await pref.getAuthToken();
    var map = <String, dynamic>{};
    map["id"] = id;

    try {
      final response =
          await http.post(fetchSingleManagementUrl, body: map, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(response.body);
        return ManagementList.fromJson(jsonResponse);
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } on Error catch (err) {
      print(err);
      return null;
    }
  }

  Future<dynamic> createNewManagement(
      {required ManagementList managementList,
      required List<PlatformFile> profileImage}) async {
    SessionManager pref = SessionManager();
    String token;
    token = (await pref.getAuthToken())!;
    var map = <String, dynamic>{};
    map['role'] = '5';
    map["data[0][name]"] = managementList.firstName.toString();
    map["data[0][mobile_number]"] = managementList.mobileNumber.toString();
    for (int i = 0; i < profileImage.length; i++) {
      map["data[0][photo]"] = base64Encode(profileImage.first.bytes!);
      map["data[0][ext]"] = profileImage.first.extension.toString();
    }
    map["data[0][dob]"] = managementList.dob.toString();
    map["data[0][doj]"] = managementList.doj.toString();
    map["data[0][employee_no]"] = managementList.employeeNo.toString();
    map["data[0][email_address]"] = managementList.emailId.toString();
    map["data[0][user_category]"] = managementList.userCategory.toString();
    print(map);
    try {
      final response = await http.post(createManagementUrl,
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
      print('changePassword -> error occurred: $err.');
      return null;
    }
  }

  Future<dynamic> editManagement(
      {required ManagementList managementList,
      required List<PlatformFile> profileImage}) async {
    SessionManager pref = SessionManager();
    String token;
    token = (await pref.getAuthToken())!;
    var map = <String, dynamic>{};
    map['id'] = managementList.id.toString();
    map['name'] = managementList.firstName.toString();
    map['mobile_number'] = managementList.mobileNumber.toString();
    for (int i = 0; i < profileImage.length; i++) {
      map['photo'] = base64Encode(profileImage.first.bytes!).toString();
      map['ext'] = profileImage.first.extension.toString();
    }
    map['dob'] = managementList.dob.toString();
    map['doj'] = managementList.doj.toString();
    map['employee_no'] = managementList.employeeNo.toString();
    map['email_address'] = managementList.emailId.toString();
    map['user_category'] = managementList.userCategory.toString();
    print(map);
    try {
      final response = await http.post(editManagementUrl,
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
      print('changePassword -> error occurred: $err.');
      return null;
    }
  }

  Future<dynamic> deleteManagement({required String staffId}) async {
    SessionManager pref = SessionManager();
    String token;
    token = (await pref.getAuthToken())!;
    var map = <String, dynamic>{};
    map["id"] = staffId;
    try {
      final response = await http.post(deleteManagementUrl,
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
}

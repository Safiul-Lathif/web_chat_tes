// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/search/management_list_model.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> addEditManagement(ManagementList managementList,
    List<PlatformFile> profileImage, bool isEdit) async {
  var url = Uri.parse("${Strings.baseURL}api/user/onboarding_edit_management");
  SessionManager pref = SessionManager();
  var token = (await pref.getAuthToken())!;
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; profileImage.length > i; i++) {
    request.fields["photo"] = base64Encode(profileImage[i].bytes!);
    request.fields["ext"] = profileImage[i].extension!;
    request.fields["file_name"] = profileImage[i].name;
  }
  if (isEdit) request.fields['id'] = managementList.id.toString();
  request.fields['module'] = 'singleuser';
  request.fields['user_role'] = '5';
  request.fields['name'] = managementList.firstName.toString();
  request.fields['email_address'] = managementList.emailId.toString();
  request.fields['mobile_number'] = managementList.mobileNumber.toString();
  request.fields['dob'] = managementList.dob.toString();
  request.fields['doj'] = managementList.doj.toString();
  request.fields['employee_no'] = managementList.employeeNo.toString();
  request.fields['user_category'] = managementList.userCategory.toString();
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          'create update management :-Request failed with status ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('create update management  -> error occurred: $err.');
    return null;
  }
}

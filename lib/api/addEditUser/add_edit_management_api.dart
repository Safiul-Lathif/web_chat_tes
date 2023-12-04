import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';
import '../../model/search/management_list_model.dart';

Future<dynamic> addEditManagement(ManagementList managementList,
    List<XFile> profileImage, bool isEdit, String module) async {
  var url = Uri.parse("${Strings.baseURL}api/user/onboarding_edit_management");
  SessionManager pref = SessionManager();
  var token = (await pref.getAuthToken())!;
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; profileImage.length > i; i++) {
    request.files
        .add(await http.MultipartFile.fromPath('photo', profileImage[i].path));
  }
  if (isEdit) request.fields['id'] = managementList.id.toString();
  request.fields['module '] = module;
  request.fields['management_name'] = managementList.firstName.toString();
  request.fields['email_address'] = managementList.emailId.toString();
  request.fields['mobile_number'] = managementList.mobileNumber.toString();
  request.fields['email_address'] = managementList.emailId.toString();
  request.fields['dob'] = managementList.dob.toString();
  request.fields['doj'] = managementList.doj.toString();
  request.fields['employee_no'] = managementList.employeeNo.toString();
  request.fields['user_category'] = managementList.userCategory.toString();

  request.headers.putIfAbsent('Authorization', () => "Bearer $token");

  print(request.headers);
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

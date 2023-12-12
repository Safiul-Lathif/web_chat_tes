import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:ui/config/strings.dart';
import 'package:ui/model/search/admin_list_model.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> addEditAdmin(
    AdminList adminList, List<XFile> profileImage, bool isEdit) async {
  var url = Uri.parse("${Strings.baseURL}api/user/create_update_admin");
  SessionManager pref = SessionManager();
  var token = (await pref.getAuthToken())!;
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; profileImage.length > i; i++) {
    request.files
        .add(await http.MultipartFile.fromPath('photo', profileImage[i].path));
  }
  if (isEdit) request.fields['id'] = adminList.id.toString();
  request.fields['name'] = adminList.firstName.toString();
  request.fields['user_role'] = '1';
  request.fields['email_address'] = adminList.emailId.toString();
  request.fields['mobile_number'] = adminList.mobileNumber.toString();
  request.fields['email_address'] = adminList.emailId.toString();
  request.fields['dob'] = adminList.dob.toString();
  request.fields['doj'] = adminList.doj.toString();
  request.fields['employee_no'] = adminList.employeeNo.toString();

  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          'create update admin :-Request failed with status ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('create update admin  -> error occurred: $err.');
    return null;
  }
}

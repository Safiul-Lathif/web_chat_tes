import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';
import '../../model/search/staff_list_model.dart';

Future<dynamic> addEditStaff(StaffSearchList staffList,
    List<PlatformFile> profileImage, bool isEdit) async {
  var url = Uri.parse("${Strings.baseURL}api/user/create_update_staff");
  SessionManager pref = SessionManager();
  var token = (await pref.getAuthToken())!;
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; profileImage.length > i; i++) {
    request.fields["photo"] = base64Encode(profileImage[i].bytes!);
    request.fields["ext"] = profileImage[i].extension!;
    request.fields["file_name"] = profileImage[i].name;
  }
  if (isEdit) request.fields['id'] = staffList.id.toString();
  request.fields['name'] = staffList.firstName.toString();
  request.fields['user_role'] = '2';
  request.fields['email_address'] = staffList.emailId.toString();
  request.fields['mobile_number'] = staffList.mobileNumber.toString();
  request.fields['email_address'] = staffList.emailId.toString();
  request.fields['dob'] = staffList.dob.toString();
  request.fields['doj'] = staffList.doj.toString();
  request.fields['employee_no'] = staffList.employeeNo.toString();
  request.fields['user_category'] = staffList.designation.toString();

  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          'create update staff :-Request failed with status ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('create update staff  -> error occurred: $err.');
    return null;
  }
}

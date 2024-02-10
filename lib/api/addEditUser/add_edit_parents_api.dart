import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

import '../../model/search_parent_model.dart';

Future<dynamic> addEditParent(ParentSearchList singleParent,
    List<PlatformFile> profileImage, bool isEdit) async {
  var url = Uri.parse("${Strings.baseURL}api/user/update_parent_details");
  SessionManager pref = SessionManager();
  var token = (await pref.getAuthToken())!;
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; profileImage.length > i; i++) {
    request.fields["photo"] = base64Encode(profileImage[i].bytes!);
    request.fields["ext"] = profileImage[i].extension!;
    request.fields["file_name"] = profileImage[i].name;
  }
  request.fields['student_id'] = singleParent.studentId.toString();
  request.fields['id'] = singleParent.id.toString();
  request.fields['email_address'] = singleParent.emailId.toString();
  request.fields['mobile_number'] = singleParent.mobileNumber.toString();
  request.fields['name'] = singleParent.firstName.toString();
  request.fields['user_role'] = '3';
  request.fields['user_category'] = singleParent.userCategory.toString();

  print(token);

  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          ' update parent :-Request failed with status ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(' update parent  -> error occurred: $err.');
    return null;
  }
}

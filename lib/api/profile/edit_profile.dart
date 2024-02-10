import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> editYourProfile(
    {required List<PlatformFile> profileImage,
    required String userName}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/save_profile");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; profileImage.length > i; i++) {
    request.fields["profile_image"] = base64Encode(profileImage[i].bytes!);
    request.fields["ext"] = profileImage[i].extension!;
    request.fields["file_name"] = profileImage[i].name;
  }
  if (userName != '') request.fields["first_name"] = userName;

  request.headers.putIfAbsent('Authorization', () => "Bearer $token");

  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          ' Edit Profile: -Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(' Edit Profile -> error occurred: $err.');
    return null;
  }
}

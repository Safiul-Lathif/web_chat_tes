import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';
import 'package:ui/utils/utility.dart';

Future<dynamic> addNewStudent({
  required String fatherName,
  required String motherName,
  required String guardianName,
  required String studentName,
  required String fatherMobileNumber,
  required String motherMobileNumber,
  required String guardianMobileNumber,
  required String fatherEmailId,
  required String motherEmailId,
  required String guardianEmailId,
  required List<PlatformFile> studentPicture,
  required String admissionNumber,
  required String rollNumber,
  required String groupId,
  required String classConfig,
  required String gender,
  required DateTime dob,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/onboarding_edit_parent");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var dateOfBirth = Utility.convertDateFormat(dob.toString(), "yyyy-MM-dd");
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; studentPicture.length > i; i++) {
    request.fields["student_photo"] = base64Encode(studentPicture[i].bytes!);
    request.fields["ext"] = studentPicture[i].extension!;
  }
  request.fields["father_name"] = fatherName;
  request.fields["mother_name"] = motherName;
  request.fields["guardian_name"] = guardianName;
  request.fields["student_name"] = studentName;
  request.fields["father_mobile_number"] = fatherMobileNumber;
  request.fields["mother_mobile_number"] = motherMobileNumber;
  request.fields["guardian_mobile_number"] = guardianMobileNumber;
  request.fields["father_email_address"] = fatherEmailId;
  request.fields["mother_email_address"] = motherEmailId;
  request.fields["guardian_email_address"] = guardianEmailId;
  request.fields["admission_no"] = admissionNumber;
  request.fields["roll_no"] = rollNumber;
  request.fields["class_config"] = classConfig;
  request.fields["group_id"] = groupId;
  request.fields["dob"] = dateOfBirth;
  request.fields["gender"] = gender;

  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      print(respStr);
      return jsonDecode(respStr);
    } else {
      print(
          ' Add student: -Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('Add student -> error occurred: $err.');
    return null;
  }
}

Future<dynamic> editStudentProfile({
  required String studentName,
  required String studentId,
  required List<PlatformFile> studentPicture,
  required String admissionNumber,
  required String rollNumber,
  required String groupId,
  required String classConfig,
  required String dob,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/onboarding_edit_parent");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var dateOfBirth = Utility.convertDateFormat(dob, "yyyy-MM-dd");
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; studentPicture.length > i; i++) {
    request.fields["student_photo"] = base64Encode(studentPicture[i].bytes!);
    request.fields["ext"] = studentPicture[i].extension!;
  }
  request.fields["student_name"] = studentName;
  request.fields["student_id"] = studentId;
  request.fields["admission_no"] = admissionNumber;
  request.fields["roll_no"] = rollNumber;
  request.fields["class_config"] = classConfig;
  request.fields["group_id"] = groupId;
  request.fields["dob"] = dateOfBirth;
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  print("$dateOfBirth $dob");
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      print(
          ' Edit student: -Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('Edit student -> error occurred: $err.');
    return null;
  }
}

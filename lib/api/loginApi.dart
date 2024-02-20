import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/loginModel.dart';
import 'package:ui/utils/session_management.dart';

bool isPhone(String input) =>
    RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
        .hasMatch(input);
Future<Login?> login(
    {required String mobileNumber,
    required String password,
    required String role}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/login");
  var map = <String, dynamic>{};
  isPhone(mobileNumber)
      ? map["user_mobile_number"] = mobileNumber
      : map["user_email_id"] = mobileNumber;

  map["password"] = password;
  map["user_role"] = role;
  //};
  try {
    final response = await http.post(
      url,
      body: map,
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Login.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> forgotOtp(
    {required String mobileNumber, required String role}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/forgot_password");
  var map = <String, dynamic>{};
  map["mobile_no"] = mobileNumber;
  map['user_role'] = role;
  //};
  try {
    final response = await http.post(
      url,
      body: map,
    );
    if (response.statusCode == 200) {
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

Future<dynamic> changePassword(
    {required String oldPassword, required String newPassword}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/change_password");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var map = <String, dynamic>{};
  map["current_password"] = oldPassword;
  map["new_password"] = newPassword;
  try {
    final response = await http.post(
      url,
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      body: map,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('changePassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> resetPassword(
  String userId,
  String pin,
  String role,
) async {
  var url = Uri.parse("${Strings.baseURL}api/user/resetPassword");
  var map = <String, dynamic>{};
  map["user_mobile_number"] = userId;
  map["pin"] = pin;
  map['user_role'] = role;
  try {
    final response = await http.post(
      url,
      body: map,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('resetPassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> resetNewPassword(
    String userId, String pin, String role, String password) async {
  var url = Uri.parse("${Strings.baseURL}api/user/resetPassword");
  var map = <String, dynamic>{};
  map["user_mobile_number"] = userId;
  map["pin"] = pin;
  map['user_role'] = role;
  map['user_password'] = password;
  try {
    final response = await http.post(
      url,
      body: map,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('resetPassword -> error occured: $err.');
    return null;
  }
}

Future<dynamic> otpLogin(
  String mobile,
  String pin,
  String role,
) async {
  var url = Uri.parse("${Strings.baseURL}api/user/otplogin");
  var map = <String, dynamic>{};
  map["user_mobile_number"] = mobile;
  map["pin"] = pin;
  map['user_role'] = role;
  try {
    final response = await http.post(
      url,
      body: map,
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print('login OTP -> error occured: $err.');
    return null;
  }
}

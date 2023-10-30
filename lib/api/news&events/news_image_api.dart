import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/news&events/news_image_model.dart';
import 'package:ui/utils/session_management.dart';

Future<ImagesList?> getAllNewsImage(
    {required String studentId, required int pageNumber}) async {
  var url = Uri.parse(studentId == ''
      ? "${Strings.baseURL}api/v2/view_all_images?page=$pageNumber"
      : "${Strings.baseURL}api/v2/view_all_images?student_id=$studentId?page=$pageNumber");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  try {
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return ImagesList.fromJson(jsonDecode(response.body));
    } else {
      if (kDebugMode) {
        print(
            'News Image:-Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print("News Image:- $err");
    }
    return null;
  }
}

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/config/strings.dart';

import 'package:http/http.dart' as http;
import 'package:ui/utils/session_management.dart';

Future<dynamic> sendEvents(
    {required List<PlatformFile> img,
    required String title,
    required String description,
    required DateTime eventDate,
    required String link,
    required String eventTime,
    required List<String> classIds}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/store_news_events");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var eventDates =
      Utility.convertDateFormat(eventDate.toString(), "yyyy-MM-dd");
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; img.length > i; i++) {
    request.fields["images[$i]"] = base64Encode(img[i].bytes!);
    request.fields["ext[$i]"] = img[i].extension!;
    request.fields["file_name[$i]"] = img[i].name;
  }
  for (int i = 0; i < classIds.length; i++) {
    request.fields['visible_to[$i]'] = classIds[i];
  }
  request.fields["title"] = title;
  request.fields["module_type"] = '2';
  request.fields["description"] = description;
  request.fields["news_events_category"] = '1';
  request.fields["event_date"] = eventDates;
  request.fields["event_time"] = eventTime;
  request.fields["youtube_link"] = link;

  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      if (kDebugMode) {
        print(
            ' Send Events: -Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print('Send Events -> error occurred: $err.');
    }
    return null;
  }
}

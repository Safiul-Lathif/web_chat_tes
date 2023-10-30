import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/news&events/events_feed_model.dart';
import 'package:ui/model/news&events/single_news_events_model.dart';
import 'package:ui/utils/session_management.dart';
import '../../model/news&events/news_feed_model.dart';

Future<SingleNewsEvents?> getSingleNews(String id) async {
  var url = Uri.parse("${Strings.baseURL}api/user/view_individual_news_events");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["news_events_id"] = id;
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(response.body);
      return SingleNewsEvents.fromJson(jsonResponse);
    } else {
      print(
          ' Single news events:- Request failed with status: ${response.statusCode}.');

      return null;
    }
  } on Error catch (err) {
    print("Error on Single news events:- $err");

    return null;
  }
}

Future<SingleEvent?> getSingleEvent(String id) async {
  var url = Uri.parse("${Strings.baseURL}api/user/view_individual_news_events");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["news_events_id"] = id;
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return SingleEvent.fromJson(jsonResponse);
    } else {
      if (kDebugMode) {
        print(
            ' Single news events:- Request failed with status: ${response.statusCode}.');
      }
      return null;
    }
  } on Error catch (err) {
    if (kDebugMode) {
      print("Error on Single news events:- $err");
    }
    return null;
  }
}

// Future<UpcomingEvent?> getSingleEvent(String id) async {
//   var url = Uri.parse("${Strings.baseURL}api/user/view_individual_news_events");
//   SessionManager pref = SessionManager();
//   String? token = await pref.getAuthToken();
//   var map = <String, dynamic>{};
//   map["news_events_id"] = id;
//   try {
//     final response = await http.post(url,
//         body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       if (kDebugMode) {
//         print(response.body);
//       }
//       return UpcomingEvent.fromJson(jsonResponse);
//     } else {
//       if (kDebugMode) {
//         print(
//             ' Single news events:- Request failed with status: ${response.statusCode}.');
//       }
//       return null;
//     }
//   } on Error catch (err) {
//     if (kDebugMode) {
//       print("Error on Single news events:- $err");
//     }
//     return null;
//   }


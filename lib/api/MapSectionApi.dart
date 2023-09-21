import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/model/MapClassModel.dart';
import 'package:ui/model/MapSectionModel.dart';
import 'package:ui/utils/session_management.dart';
import '../../../config/strings.dart';

// Future<List<ClassList>?> getClassList({required String dId}) async {
//   var url = Uri.parse("${Strings.baseURL}api/user/get_classes_list");
//   SessionManager? pref = SessionManager();
//   String? token =
//       //"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
//       await pref.getAuthToken();

//   var map = <String, dynamic>{};
//   map["division_id"] = dId;

//   try {
//     final response = await http.post(url, body: map, headers: {
//       HttpHeaders.authorizationHeader: 'Bearer $token',
//     });
//     if (response.statusCode == 200) {
//       List jsonResponse = jsonDecode(response.body)["classes"];
//       return jsonResponse.map((json) => ClassList.fromJson(json)).toList();
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//       return null;
//     }
//   } on Error catch (err) {
//     print(err);
//     return null;
//   } finally {
//     pref = null;
//   }
// }

// Future<SectionList?> getSectionList({required String dId}) async {
//   var url = Uri.parse("${Strings.baseURL}api/user/get_edit_allsection_list");
//   SessionManager? pref = SessionManager();
//   String? token =
//       // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
//       await pref.getAuthToken();

//   var map = <String, dynamic>{};
//   map["division_id"] = dId;

//   try {
//     final response = await http.post(url, body: map, headers: {
//       HttpHeaders.authorizationHeader: 'Bearer $token',
//     });
//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       return SectionList.fromJson(jsonResponse);
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//       return null;
//     }
//   } on Error catch (err) {
//     print(err);
//     return null;
//   } finally {
//     pref = null;
//   }
// }

Future<List<ListsClass>?> getClassList({required String dId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_classes_list");
  SessionManager? pref = SessionManager();
  String? token =
      //"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      await pref.getAuthToken();

  var map = <String, dynamic>{};
  map["division_id"] = dId;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)["classes"];
      print(response.body);
      return jsonResponse.map((json) => ListsClass.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  } finally {
    pref = null;
  }
}

Future<SectionList?> getSectionList({required String dId}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/get_edit_allsection_list");
  SessionManager? pref = SessionManager();
  String? token =
      // "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdWF0bGl0ZWFwaS50aW1ldG9zY2hvb2wuY29tL2FwaS91c2VyL2xvZ2luIiwiaWF0IjoxNjczMjY4MDg3LCJleHAiOjE3MDQ4MDQwODcsIm5iZiI6MTY3MzI2ODA4NywianRpIjoiTzBqOEU5UjhaTVFjc0t3SiIsInN1YiI6IjEiLCJwcnYiOiIxYmMyNDY0NzA5NjkzYTM3NDc0NWQyMThkMTVmZmNhMGMyODZmYzk1In0.UCjO9gcvlotExGWb17tOSWllya3nYe75VqxEwmjAVsE";
      await pref.getAuthToken();

  var map = <String, dynamic>{};
  map["division_id"] = dId;

  try {
    final response = await http.post(url, body: map, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return SectionList.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print(err);
    return null;
  } finally {
    pref = null;
  }
}

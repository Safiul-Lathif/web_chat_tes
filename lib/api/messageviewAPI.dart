import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/utils/session_management.dart';

Future<MessageView?> getMsgFeed(String id, int pageNumber) async {
  var url = Uri.parse("${Strings.baseURL}api/v2/view_messages");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();
  var map = <String, dynamic>{};
  map["group_id"] = id;
  if (pageNumber != 0) map['page'] = pageNumber.toString();
  try {
    final response = await http.post(url,
        body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      print("page number:$pageNumber");
      return MessageView.fromJson(jsonDecode(response.body));
    } else {
      print('msg feed:- Request failed wi th status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    print("message Feed:- $err");
    return null;
  }
}

// Future<List<Message>?> getMsgDetailFeed(String id) async {
//   var url = Uri.parse("${Strings.baseURL}api/user/view_messages");
//   SessionManager pref = SessionManager();
//   String? token = await pref.getAuthToken();

//   var map = <String, dynamic>{};
//   map["group_id"] = id;

//   try {
//     final response = await http.post(url,
//         body: map, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
//     if (response.statusCode == 200) {
//       List jsonResponse = jsonDecode(response.body);
//       return jsonResponse.map((json) => Message.fromJson(json)).toList();
//     } else {
//       print('Request failed wi th status: ${response.statusCode}.');
//       return null;
//     }
//   } on Error catch (err) {
//     print(err);
//     return null;
//   }
// }

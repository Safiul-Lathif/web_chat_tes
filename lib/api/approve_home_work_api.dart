import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/utils/session_management.dart';

Future<dynamic> approveHomework({required List<String> notifyid}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/homework_approval");
  SessionManager pref = SessionManager();
  String token;
  token = (await pref.getAuthToken())!;
  var request = http.MultipartRequest("POST", url);
  for (int i = 0; i < notifyid.length; i++) {
    request.fields['notification_id[$i]'] = notifyid[i];
  }
  request.headers.putIfAbsent('Authorization', () => "Bearer $token");
  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('changePassword -> error occured: $err.');
    return null;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/config/strings.dart';
import 'package:ui/model/Fees/fees_history_model.dart';
import 'package:ui/utils/session_management.dart';

Future<List<FeesHistoryModel>?> getfeesHistory({
  required String id,
}) async {
  var url = Uri.parse("${Strings.baseURL}api/user/paymentHistory?stu_id=$id");
  SessionManager pref = SessionManager();
  String? token = await pref.getAuthToken();

  try {
    final response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((json) => FeesHistoryModel.fromJson(json))
          .toList();
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } on Error catch (err) {
    // ignore: avoid_print
    print('Fee History -> error occured: $err.');
    return null;
  }
}

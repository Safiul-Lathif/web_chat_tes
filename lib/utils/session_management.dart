import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final String authToken = "auth_token";
  final String lang = "language";
  final String prefLang = "prefLanguage";
  final String studentId = "studentId";
  final String studentName = "studentName";
  final String playerId = "playerId";
  final String studentClass = "studentClass";
  final String date = "date";
  final String count = "count";
  final String tagData = "tagData";
  final String classes = "classes";
  final String sec = "sec";
  final String externalId = "externalId";
  final String mob = "mobile_number";
  final String role = "user_role";
  final String res = "response";

//set data into shared preferences like this
  Future<void> setAuthToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(authToken, token);
  }

//get value from shared preferences
  Future<String?> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? authToken;
    authToken = pref.getString(this.authToken);
    return authToken;
  }

  Future<void> setRes(String respon) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(res, respon);
  }

//get value from shared preferences
  Future<dynamic> getRes() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(res);
  }

  Future<void> setLang(dynamic val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(lang, val);
  }

  Future<dynamic> getLang() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(lang);
  }

  Future<void> setRole(dynamic roles) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(role, roles);
  }

  Future<dynamic> getRole() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(role);
  }

  Future<void> setPrefLang(String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefLang, val);
  }

  Future<String> getPrefLang() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(prefLang) ?? "english";
  }

  Future<void> setStudentId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(studentId, id);
  }

  Future<String?> getStudentId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(studentId);
  }

  Future<void> setStudentName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(studentName, name);
  }

  Future<String?> getStudentName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(studentName);
  }

  Future<void> setStudentClass(String className) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(studentClass, className);
  }

  Future<String?> getStudentClass() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(studentClass);
  }

  Future<void> removeToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(authToken);
  }

  Future<void> setPlayerId(String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(playerId, val);
  }

  Future<String?> getPlayerId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(playerId);
  }

  Future<void> setLoginDate(String date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(date, date);
  }

//get value from shared preferences
  Future<String?> getLoginDate() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(date);
  }

  Future<void> setDayCount(int daycount) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(count, daycount);
  }

//get value from shared preferences
  Future<int?> getDayCount() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(count);
  }

  Future<void> setTag(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(tagData, data);
  }

  Future<String?> getTag() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(tagData);
  }

  Future<void> setExternalId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(externalId, id);
  }

  Future<String?> getExternalId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(externalId);
  }

  Future<void> setMobNumber(String num) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(mob, num);
  }

  Future<String?> getMobNumber() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(mob);
  }
}

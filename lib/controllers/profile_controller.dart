import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/model/login_model.dart';
import 'package:ui/model/profile_swap_model.dart';
import 'package:ui/utils/session_management.dart';

class ProfileController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> listOfProfiles = [];
  Future<bool> userValidate(
      Login response, String role, String schoolName, String number) async {
    SessionManager prefs = SessionManager();
    await prefs.setAuthToken(response.token.toString());
    await prefs.setStudentId(response.loginStudentId.toString());
    await prefs.setRole(role);
    await prefs.setExternalId(response.userId.substring(0, 4));
    await prefs.setTag(response.userId);
    getAllStoredProfile(response.userId);
    saveTheData(
        response.token.toString(), response.userId, role, schoolName, number);
    return false;
  }

  Future<bool> roleChange(String role, String schoolName, String token,
      String userId, String number) async {
    SessionManager prefs = SessionManager();
    await prefs.setAuthToken(token);
    await prefs.setStudentId('');
    await prefs.setRole(role == '5'
        ? "Management"
        : role == '1'
            ? "Admin"
            : role == '3'
                ? "Parent"
                : "Staff");
    if (userId != '') {
      await prefs.setExternalId(userId);
      await prefs.setTag(userId);
    }

    print("user role:  ${await prefs.getRole()}");
    getBool(
        userId,
        token,
        userId,
        role == '5'
            ? "Management"
            : role == '1'
                ? "Admin"
                : role == '3'
                    ? "Parent"
                    : "Staff",
        schoolName,
        number);

    return false;
  }

  void saveData(String token, String tag, String role, String schoolName,
      String number) async {
    final SharedPreferences prefs = await _prefs;
    final String encodedData = ProfileSwap.encode([
      ProfileSwap(
          token: token,
          tag: tag,
          role: role,
          schoolName: schoolName,
          number: number)
    ]);
    listOfProfiles = (prefs.getStringList('ProfileDetails') ?? []);
    listOfProfiles.add(encodedData);
    prefs.setStringList('ProfileDetails', listOfProfiles);
  }

  void saveTheData(String token, String tag, String role, String schoolName,
      String number) async {
    final SharedPreferences prefs = await _prefs;
    final String encodedData = ProfileSwap.encode([
      ProfileSwap(
          token: token,
          tag: tag,
          role: role,
          schoolName: schoolName,
          number: number)
    ]);
    listOfProfiles = (prefs.getStringList('ProfileDetails') ?? []);
    var profile = await getAllStoredProfile(tag);
    profile ? null : listOfProfiles.add(encodedData);
    prefs.setStringList('ProfileDetails', listOfProfiles);
  }

  Future<bool> getBool(String rfId, String token, String tag, String role,
      String schoolName, String number) async {
    bool result = false;
    final SharedPreferences prefs = await _prefs;
    listOfProfiles = (prefs.getStringList('ProfileDetails') ?? []);
    var fetchedProfile = [];
    var pendingProfiles = [];
    List<String> encodedData = [];

    for (int i = 0; i < listOfProfiles.length; i++) {
      fetchedProfile.add(json.decode(listOfProfiles[i]));
    }
    pendingProfiles =
        fetchedProfile.where((element) => element[0]['tag'] != rfId).toList();
    fetchedProfile =
        fetchedProfile.where((element) => element[0]['tag'] == rfId).toList();
    fetchedProfile.removeWhere((element) => element[0]['tag'] == rfId);

    for (int i = 0; i < pendingProfiles.length; i++) {
      encodedData.add(ProfileSwap.encode([
        ProfileSwap(
            token: pendingProfiles[i][0]['token'],
            tag: pendingProfiles[i][0]['tag'],
            role: pendingProfiles[i][0]['role'],
            number: pendingProfiles[i][0]['number'],
            schoolName: pendingProfiles[i][0]['schoolName'])
      ]));
    }

    prefs.setStringList('ProfileDetails', encodedData);

    saveData(token, tag, role, schoolName, number);

    return result;
  }

  Future<bool> getAllStoredProfile(String rfId) async {
    bool result = false;
    final SharedPreferences prefs = await _prefs;
    listOfProfiles = (prefs.getStringList('ProfileDetails') ?? []);
    for (int i = 0; i < listOfProfiles.length; i++) {
      var fetchedProfile = json.decode(listOfProfiles[i]);
      if (fetchedProfile[0]['tag'] == rfId) {
        result = true;
      }
    }
    return result;
  }
}

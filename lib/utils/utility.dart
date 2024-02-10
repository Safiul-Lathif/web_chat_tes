import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ui/config/strings.dart';
import 'package:ui/model/config/config_list_model.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/widget/settings/classes.dart';
import 'package:ui/widget/settings/division.dart';
import 'package:ui/widget/settings/management.dart';
import 'package:ui/widget/settings/sections.dart';
import 'package:ui/widget/settings/staff.dart';
import 'package:ui/widget/settings/student.dart';
import 'package:ui/widget/settings/subject.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/settings/review_section.dart';

class Utility {
  static Future<void> callLauncher(String url) async {
    //String link = _isEmail(url) ? "mailto:$url" : url;
    try {
      if (!await launchUrl(Uri.parse(
        url,
        // forceSafariVC: false,
        // forceWebView: false,
        // headers: <String, String>{'my_header_key': 'my_header_value'},
      ))) {
        throw 'Could not launch $url';
      }
      //   if (await canLaunch(link)) {
      //     await launch(link);
      //   } else {
      //     print('Could not launch $link');
      //   }
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static String convertDateFormat(String date, String outFormat,
      {String inFormat = ""}) {
    try {
      var newDate = DateTime.now();
      if (inFormat != "") {
        DateFormat inputFormat = DateFormat(inFormat);
        newDate = inputFormat.parse(date);
      } else {
        newDate = DateTime.parse(date);
      }
      return DateFormat(outFormat).format(newDate);
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }
      rethrow;
    }
  }

  static void popUpDialog(BuildContext context, String data) async {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: AlertDialog(
              content: SingleChildScrollView(
                child: Text(data.toString()),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: data.toString()))
                          .then((_) {
                        Utility.displaySnackBar(
                            context, 'Copied to your clipboard !');
                      });
                    },
                    icon: const Icon(Icons.copy)),
                IconButton(
                    onPressed: () async {
                      await Share.share(data.toString());
                    },
                    icon: const Icon(Icons.share)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
        );
      },
    );
  }

  static List<Map<String, dynamic>> settingsPageConfig(ConfigList tabs) {
    return [
      {"name": "Division", "pages": const DivisionWidget(), "config": true},
      {
        "name": "Sections",
        "pages": const SectionWidget(),
        "config": tabs.configuration.sections
      },
      {
        "name": "Class",
        "pages": const ClassWidget(),
        "config": tabs.configuration.classes
      },
      {
        "name": "Subject",
        "pages": const SubjectWidget(),
        "config": tabs.configuration.mapSubjects
      },
      {
        "name": "Map Subject",
        "pages": const ReviewSectionWidget(),
        "config": tabs.configuration.mapClassesSections
      },
      {
        "name": "Staff",
        "pages": const StaffWidget(),
        "config": tabs.configuration.staffs
      },
      {
        "name": "Management",
        "pages": const ManagementWidget(),
        "config": tabs.configuration.management
      },
      {
        "name": "Student",
        "pages": const StudentWidget(),
        "config": tabs.configuration.students
      },
    ];
  }

  static String convertTimeFormat(String time) {
    try {
      return DateFormat.jm().format(DateFormat("HH:mm:ss").parse(time));
    } catch (e) {
      return time;
    }
  }

  static int getTimeDifference(String startTime, String endTime) {
    try {
      DateTime start = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.tryParse(startTime.split(":").first) ?? 0,
          int.tryParse(startTime.split(":").last) ?? 0);
      DateTime end = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.tryParse(endTime.split(":").first) ?? 0,
          int.tryParse(endTime.split(":").last) ?? 0);
      return end.difference(start).inMinutes;
    } catch (e) {
      return 0;
    }
  }

  static String getYoutubeThumbnail(String videoUrl) {
    if (videoUrl.contains("<iframe")) {
      const start = "src=\"";
      const end = "\" frameborder";
      final startIndex = videoUrl.indexOf(start);
      final endIndex = videoUrl.indexOf(end, startIndex + start.length);
      String code = videoUrl
          .substring(startIndex + start.length, endIndex)
          .split('/')
          .last;

      return 'https://img.youtube.com/vi/$code/0.jpg';
    }

    final Uri? uri = Uri.tryParse(videoUrl);
    if (uri == null) {
      return "";
    }
    return 'https://img.youtube.com/vi/${uri.queryParameters['v']}/0.jpg';
  }

  static String getYoutubeEmbedLink(String videoUrl) {
    final Uri? uri = Uri.tryParse(videoUrl);
    if (uri == null) {
      return "http://kyc365pro.com/themes/metronic/assets/img/logo_new.png";
    }
    return "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/${uri.queryParameters['v']}?autoplay=1\" ></iframe>";
  }

  static Future<String?> convertBase64(String path) async {
    try {
      File file = File(path);
      file.openRead();
      List<int> fileBytes = await file.readAsBytes();
      String base64String = base64Encode(fileBytes);
      return base64String;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<Directory?> _getDirectory() async {
    if (Platform.isAndroid) {
      final Directory _downloadDir = Directory(Strings.downloadPath);
      final checkPathExist = await _downloadDir.exists();
      if (checkPathExist)
        return _downloadDir;
      else
        return await getExternalStorageDirectory();
    }
    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  // static bool _isEmail(String input) {
  //   final matcher = new RegExp(
  //       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //   return matcher.hasMatch(input);
  // }

  static Future<String> createFolderDownloadDir(String folderName) async {
    //Get this App Download Directory
    final Directory? _appDir = await _getDirectory();
    //App Download Directory + folder name
    final Directory _appDirFolder = Directory('${_appDir!.path}/$folderName/');

    if (await _appDirFolder.exists()) {
      //if folder already exists return path
      return _appDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  static Future<String> downloadFileHttp(
    String url,
    String filename,
    String defaultFolder,
  ) async {
    // String folderName
    final status = await Permission.storage.request();
    if (status.isGranted) {
      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse(url.contains("http://")
          ? url
          : url.contains("https://")
              ? url
              : Strings.http + url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      //  String dir = await createFolderDownloadDir(folderName);
      File file = File('$filename'); // String folderName
      await file.writeAsBytes(bytes);
      return url; //dir
    } else {
      return "Permission required to download the file";
    }
  }

  static void displaySnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20.0),
        content: Text(msg),
      ),
    );
  }

  static void openDownloadedFile(
      BuildContext context, String msg, String filePath) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20.0),
        action: SnackBarAction(
          label: 'Open',
          textColor: Colors.white,
          //to open the file
          onPressed: () async {
            final message = await OpenFile.open(filePath);
            print(message);
          },
        ),
      ),
    );
  }

  /// check is the feature exists
  // static bool checkFeatureIsExist(
  //     List<FeaturesDetail> featureList, String featureName) {
  //   final value = featureList.firstWhere(
  //       (element) => element.feature == featureName && element.isActive == true,
  //       orElse: () {
  //     return null;
  //   });
  //   if (value != null) {
  //     return true;
  //   } else
  //     return false;
  // }

  static bool checkFileExists(filePath) {
    var result = File(Strings.downloadPath + filePath).existsSync();
    return result;
  }
}

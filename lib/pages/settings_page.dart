// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/api/config/config_list.dart';
import 'package:ui/screens/login_page.dart';
import 'package:ui/screens/splash_screen.dart';
import 'package:ui/utils/session_management.dart';
import 'package:ui/widget/settings/classes.dart';
import 'package:ui/widget/settings/division.dart';
import 'package:ui/widget/settings/management.dart';
import 'package:ui/widget/settings/review_section.dart';
import 'package:ui/widget/settings/sections.dart';
import 'package:ui/widget/settings/student.dart';
import 'package:ui/widget/settings/subject.dart';
import 'package:vertical_tabs_flutter/vertical_tabs.dart';

import '../widget/settings/staff.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await getConfig();
  }

  List<Map<String, dynamic>> tabs = [];

  Future<void> getConfig() async {
    String authToken = await SessionManager().getAuthToken() ?? '';
    await getAllConfigList(token: authToken).then((value) {
      if (value != null) {
        setState(() {
          var configuration = value.configuration;
          tabs = [
            {
              "name": "Division",
              "pages": const DivisionWidget(),
              "config": true
            },
            {
              "name": "Sections",
              "pages": const SectionWidget(),
              "config": configuration.sections
            },
            {
              "name": "Class",
              "pages": const ClassWidget(),
              "config": configuration.classes
            },
            {
              "name": "Subject",
              "pages": const SubjectWidget(),
              "config": configuration.mapSubjects
            },
            {
              "name": "Map Subject",
              "pages": const ReviewSectionWidget(),
              "config": configuration.mapClassesSections
            },
            {
              "name": "Staff",
              "pages": const StaffWidget(),
              "config": configuration.staffs
            },
            {
              "name": "Management",
              "pages": const ManagementWidget(),
              "config": configuration.management
            },
            {
              "name": "Student",
              "pages": const StudentWidget(),
              "config": configuration.students
            },
          ];
        });
      }
    });
  }

  Future<bool> exitApp() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout & Exit'),
            content: const Text('Do you want to exit?'),
            actions: [
              ElevatedButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                onPressed: () async {
                  Navigator.pop(context);
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.clear();
                  navigateToLogin();
                },
                child: const Text('Logout and exit'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void navigateToLogin() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return tabs.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : WillPopScope(
            onWillPop: exitApp,
            child: Scaffold(
                body: VerticalTabs(
              initialIndex: 0,
              tabsWidth: 200,
              direction: TextDirection.ltr,
              changePageDuration: const Duration(milliseconds: 500),
              tabs: <Tab>[
                for (int i = 0; i < tabs.length; i++)
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tabs[i]['name'],
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16)),
                          ),
                          tabs[i]['config'] == false
                              ? const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                        ],
                      ),
                    ),
                  ),
              ],
              contents: [
                for (int i = 0; i < tabs.length; i++) tabs[i]['pages']
              ],
            )),
          );
  }
}

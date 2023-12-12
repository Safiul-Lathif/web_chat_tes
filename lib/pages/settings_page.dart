// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/widget/settings/classes.dart';
import 'package:ui/widget/settings/division.dart';
import 'package:ui/widget/settings/management.dart';
import 'package:ui/widget/settings/sections.dart';
import 'package:ui/widget/settings/staff.dart';
import 'package:ui/widget/settings/student.dart';
import 'package:ui/widget/settings/subject.dart';
import 'package:vertical_tabs_flutter/vertical_tabs.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  List<Map<String, dynamic>> tabs = [
    {"name": "Division", "pages": const DivisionWidget()},
    {"name": "Sections", "pages": const SectionWidget()},
    {"name": "Class", "pages": const ClassWidget()},
    {"name": "Subject", "pages": const SubjectWidget()},
    // {"name": "Review Section", "pages": Container()},
    {"name": "Staff", "pages": const StaffWidget()},
    {"name": "Management", "pages": const ManagementWidget()},
    {"name": "Student", "pages": const StudentWidget()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: VerticalTabs(
      initialIndex: 6,
      tabsWidth: 200,
      direction: TextDirection.ltr,
      changePageDuration: const Duration(milliseconds: 500),
      tabs: <Tab>[
        for (int i = 0; i < tabs.length; i++)
          Tab(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                tabs[i]['name'],
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 16)),
              ),
            ),
          ),
      ],
      contents: [for (int i = 0; i < tabs.length; i++) tabs[i]['pages']],
    ));
  }
}

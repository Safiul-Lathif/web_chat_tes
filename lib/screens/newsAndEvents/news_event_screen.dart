// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/screens/newsAndEvents/event/event_screen.dart';
import 'package:ui/screens/newsAndEvents/images/images_screen.dart';
import 'package:ui/screens/newsAndEvents/news/news_screen.dart';
import 'package:ui/utils/session_management.dart';
import 'package:vertical_tabs_flutter/vertical_tabs.dart';

class NewsEventsScreens extends StatefulWidget {
  NewsEventsScreens({super.key, required this.studentId});
  String studentId;

  @override
  State<NewsEventsScreens> createState() => _NewsEventsScreensState();
}

class _NewsEventsScreensState extends State<NewsEventsScreens> {
  @override
  void initState() {
    super.initState();
    getRole();
  }

  String userRole = '';
  bool accessiblePerson = false;
  Future getRole() async {
    var role = await SessionManager().getRole();
    setState(() {
      userRole = role.toUpperCase();
      if (userRole == 'MANAGEMENT' || userRole == 'ADMIN') {
        accessiblePerson = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: VerticalTabs(
      tabsWidth: 250,
      direction: TextDirection.ltr,
      changePageDuration: const Duration(milliseconds: 500),
      tabs: <Tab>[
        Tab(
          icon: Text(
            "News",
            style: GoogleFonts.lato(
                textStyle:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
          ),
        ),
        Tab(
          icon: Text(
            "Events",
            style: GoogleFonts.lato(
                textStyle:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
          ),
        ),
        Tab(
          icon: Text(
            "Images",
            style: GoogleFonts.lato(
                textStyle:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
          ),
        ),
      ],
      contents: [
        NewsScreen(
          accessiblePerson: accessiblePerson,
          studentId: widget.studentId,
        ),
        EventScreen(
          accessiblePerson: accessiblePerson,
          studentId: widget.studentId,
        ),
        ImageScreenNews(
          studentId: widget.studentId,
        )
      ],
    ));
  }
}

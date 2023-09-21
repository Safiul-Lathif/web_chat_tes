// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ui/screens/newsAndEvents/event/event_screen.dart';
import 'package:ui/screens/newsAndEvents/images/images_screen.dart';
import 'package:ui/screens/newsAndEvents/news/news_screen.dart';
import 'package:ui/utils/session_management.dart';

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //     onPressed: () => Navigator.pop(context),
          //     icon: const Icon(
          //       Icons.arrow_back_ios,
          //       color: Colors.black,
          //     )),
          // systemOverlayStyle: SystemUiOverlayStyle.dark,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade50,
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                  image: const AssetImage("assets/images/bg_image_tes.jpg"),
                  fit: BoxFit.cover,
                )),
          ),
          // elevation: 0,
          // actions: [
          //   Align(
          //     alignment: Alignment.centerRight,
          //     child: Text(
          //       DateFormat('d MMMM, yyyy').format(DateTime.now()),
          //       style: const TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black),
          //     ),
          //   ),
          //   const SizedBox(
          //     width: 20,
          //   )
          // ],
          bottom: const TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                  icon: Text(
                "News",
                style: TextStyle(color: Colors.black),
              )),
              Tab(
                  icon: Text(
                "Events",
                style: TextStyle(color: Colors.black),
              )),
              Tab(
                  icon: Text(
                "Images",
                style: TextStyle(color: Colors.black),
              )),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Colors.blue.shade50,
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                  image: const AssetImage("assets/images/bg_image_tes.jpg"),
                  repeat: ImageRepeat.repeatX)),
          child: TabBarView(
            children: [
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
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/api/profile_api.dart';
import 'package:ui/model/profile_model.dart';
import 'package:ui/pages/attendance_page.dart';
import 'package:ui/pages/birthday_page.dart';
import 'package:ui/pages/main_web_screen.dart';
import 'package:ui/screens/action_required_page.dart';
import 'package:ui/screens/login_page.dart';
import 'package:ui/screens/newsAndEvents/news_event_screen.dart';
import 'package:ui/screens/searchScreen/search_screen.dart';
import 'package:ui/screens/splash_screen.dart';
import 'package:ui/screens/user_details.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_strategy/url_strategy.dart';
import 'utils/session_management.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 300));
  runApp(const ThisApp());
}

class ThisApp extends StatefulWidget {
  const ThisApp({super.key});

  @override
  State<ThisApp> createState() => _ThisAppState();
}

class _ThisAppState extends State<ThisApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ProfileModel? profiles;
  int selectedIndex = 1;
  String role = '';
  @override
  void initState() {
    super.initState();
    profile();
    getId();
  }

  String userId = '';
  void getId() async {
    SessionManager pref = SessionManager();
    userId = await pref.getTag() ?? '';
  }

  void profile() async {
    await getProfile(id: "", role: "").then((value) {
      if (value != null) {
        setState(() {
          profiles = value;
        });
      }
    });
  }

  final List<Widget> screens = [
    UserDetailsScreen(
      isGrp: false,
    ),
    const MainWebScreen(),
    const ActionRequiredPage(),
    // const HomeWorkScreen(),
    NewsEventsScreens(studentId: ''),
    const BirthdayPage(),
    const AttendancePage(),
    const SearchPage()
    // searc
    // SettingsPage(),
  ];
  Future<bool> exitApp() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit'),
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
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitApp,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Row(
          children: [
            NavigationRail(
                minWidth: 65,
                backgroundColor: Colors.green.shade600,
                labelType: NavigationRailLabelType.all,
                onDestinationSelected: (value) {
                  var data = base64.encode(userId.codeUnits);
                  var data2 = base64.encode(data.codeUnits);
                  if (value == 7) {
                    launchUrl(Uri.parse(
                        "https://qaliteapi.timetoschool.com/apptoweblogin?id=$data2&menu=students"));
                    setState(() {
                      selectedIndex = 2;
                    });
                  } else {
                    if (value == 8) {
                      logoutAlert();
                    } else {
                      setState(() {
                        selectedIndex = value;
                      });
                    }
                  }
                },
                selectedIconTheme:
                    const IconThemeData(color: Colors.white, size: 30),
                selectedLabelTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 14),
                unselectedIconTheme:
                    const IconThemeData(color: Colors.white, size: 20),
                unselectedLabelTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 12),
                destinations: [
                  NavigationRailDestination(
                      selectedIcon: const CircleAvatar(
                        radius: 18.0,
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpCKq1XnPYYDaUIlwlsvmLPZ-9-rdK28RToA&usqp=CAU'),
                        backgroundColor: Colors.transparent,
                      ),
                      icon: const Tooltip(
                          message: 'Profile', child: Icon(Icons.person)),
                      label: Text(
                        profiles == null ? 'Profile' : profiles!.name,
                      )),
                  const NavigationRailDestination(
                      icon: Tooltip(
                          message: 'Chat', child: Icon(Icons.chat_outlined)),
                      label: Text("Chat")),
                  const NavigationRailDestination(
                      icon: Tooltip(
                          message: 'Action Required', child: Icon(Icons.info)),
                      label: Text("Action")),
                  // const NavigationRailDestination(
                  //     icon: Tooltip(
                  //         message: 'Home Work', child: Icon(Icons.home_work)),
                  //     label: Text("Work")),
                  const NavigationRailDestination(
                      icon: Tooltip(
                          message: 'News and Events',
                          child: Icon(Icons.newspaper)),
                      label: Text("News")),
                  const NavigationRailDestination(
                      icon: Tooltip(
                          message: 'Birthday Wish',
                          child: Icon(Icons.celebration)),
                      label: Text("Birthday")),
                  NavigationRailDestination(
                      icon: const Tooltip(
                          message: 'Student  Attendance',
                          child: Icon(Icons.class_)),
                      label: SizedBox(
                        width: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("School"),
                            FittedBox(child: Text("Attendance")),
                          ],
                        ),
                      )),
                  const NavigationRailDestination(
                    icon: Tooltip(message: 'Search', child: Icon(Icons.search)),
                    label: Text('Search'),
                  ),
                  // const NavigationRailDestination(
                  //   icon: Tooltip(
                  //       message: 'Settings', child: Icon(Icons.settings)),
                  //   label: Text("Settings"),
                  // ),
                  const NavigationRailDestination(
                    icon: Tooltip(
                        message: 'User Management',
                        child: Icon(Icons.manage_accounts)),
                    label: Text("User"),
                  ),
                  const NavigationRailDestination(
                    icon: Tooltip(message: 'logout', child: Icon(Icons.logout)),
                    label: Text("Logout"),
                  ),
                ],
                selectedIndex: selectedIndex),
            Expanded(child: screens[selectedIndex])
          ],
        ),
      ),
    );
  }

  void navigateToLogin() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
  }

  void logoutAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: AlertDialog(
                  title: Text(
                    "Are you sure want to Logout?",
                    style: GoogleFonts.lato(fontSize: 17),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          await preferences.clear();
                          navigateToLogin();
                        },
                        child: const Text("Ok")),
                  ]));
        });
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ui/config/images.dart';
import 'package:ui/config/size_config.dart';
import 'package:ui/main.dart';
import 'package:ui/utils/session_management.dart';
import 'package:ui/utils/utils_file.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SessionManager pref = SessionManager();

  String? roles;

  @override
  void initState() {
    super.initState();

    Timer(
        const Duration(seconds: 3),
        () => {
              _checkLogin().then((value) => {
                    if (value) {navigateToHome()} else {navigateToLogin()}
                  })
            });
  }

  void navigateToLogin() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
  }

  void navigateToHome() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ));
  }

  Future<bool> _checkLogin() async {
    SessionManager pref = SessionManager();
    String? token = await pref.getAuthToken();

    if (token != null && token != "") {
      return true;
    } else {
      return false;
    }
  }

  Future<String> checkRole() async {
    SessionManager pref = SessionManager();
    String? role = await pref.getRole();

    if (role != null && role != "") {
      return role;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(2.5 * SizeConfig.heightMultiplier),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.blue.shade50,
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.blue.withOpacity(0.2), BlendMode.dstATop),
                  image: const AssetImage(Images.bgImage),
                  repeat: ImageRepeat.repeat)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Images.appLogo,
                width: 200,
                height: 200,
              ),
              Text(
                'TES Chat Web',
                textAlign: TextAlign.center,
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  height: 1.2125,
                  color: const Color(0xff505050),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

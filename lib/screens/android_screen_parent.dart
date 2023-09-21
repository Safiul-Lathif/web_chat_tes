import 'package:flutter/material.dart';
import 'package:ui/config/images.dart';
import 'package:url_launcher/url_launcher.dart';

class AndroidScreenParent extends StatefulWidget {
  const AndroidScreenParent({super.key});

  @override
  State<AndroidScreenParent> createState() => _AndroidScreenParentState();
}

class _AndroidScreenParentState extends State<AndroidScreenParent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                image: const AssetImage(Images.bgImage),
                repeat: ImageRepeat.repeat)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Images.appLogo),
              Text(
                "Welcome to TimeToSchool LITE",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "A Simple and Effective Way to communicate with school",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Click here to get our Lite Application",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        'https://play.google.com/store/apps/details?id=com.heptahives.timetoschoollite'));
                  },
                  child: const Text("TES Lite"))
            ],
          ),
        ),
      ),
    );
  }
}

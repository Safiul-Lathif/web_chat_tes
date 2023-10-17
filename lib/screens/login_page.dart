import 'package:flutter/material.dart';
import 'package:ui/config/images.dart';
import 'package:ui/screens/user_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                image: const AssetImage(Images.bgImage),
                repeat: ImageRepeat.repeat)),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.only(left: 10, right: 10),
            // decoration: const BoxDecoration(
            //   //   // ignore: prefer_const_constructors
            //   // color: Colors.blue.withOpacity(0.1),
            //   color: Colors.white,
            //   borderRadius: BorderRadius.only(
            //       topLeft: Radius.elliptical(475.0, 85.0),
            //       topRight: Radius.circular(35.0)),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black12,
            //       blurRadius: 7.0,
            //     ),
            //   ],
            // ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.13,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserLogin(name: "Admin")));
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            primary: Colors.white,
                            onPrimary: Colors.blue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.admin_panel_settings_outlined),
                            Text("Admin"),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.pink,
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width * 0.15,
                  //   height: MediaQuery.of(context).size.height * 0.1,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(15.0)),
                  //   child: ElevatedButton(
                  //       onPressed: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) =>
                  //                     UserLogin(name: "Parent")));
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //           shape: const StadiumBorder(),
                  //           primary: Colors.white,
                  //           onPrimary: Colors.blue),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: const [
                  //           Icon(Icons.account_circle),
                  //           Text("Parent"),
                  //           Icon(
                  //             Icons.arrow_forward_ios,
                  //             color: Colors.green,
                  //           ),
                  //         ],
                  //       )),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.13,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             UserLogin(name: "Staff")));
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            primary: Colors.grey.shade300,
                            onPrimary: Colors.blue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.account_circle),
                            Text("Staff"),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.yellow,
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.13,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserLogin(name: "Management")));
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            primary: Colors.grey.shade300,
                            onPrimary: Colors.blue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.account_circle),
                            Text("Managment"),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.purple,
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

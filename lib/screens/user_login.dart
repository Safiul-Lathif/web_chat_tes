// ignore_for_file: must_be_immutable

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/api/config_api.dart';
import 'package:ui/api/loginApi.dart';
import 'package:ui/config/images.dart';
import 'package:ui/main.dart';
import 'package:ui/model/profile_swap_model.dart';
import 'package:ui/screens/forget_password.dart';
import 'package:ui/screens/login_with_otp.dart';
import 'package:ui/utils/session_management.dart';
import 'package:ui/utils/utility.dart';
import '../model/loginModel.dart';

class UserLogin extends StatefulWidget {
  String name;
  UserLogin({Key? key, required this.name}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  bool value = false;
  String roles = "";
  late Login details;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isEmail(String input) => EmailValidator.validate(input);
  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);

  bool obscureText2 = true;

  @override
  void initState() {
    super.initState();
    if (widget.name == "Admin") {
      setState(() {
        roles = "1";
      });
    } else if (widget.name == "Parent") {
      setState(() {
        roles = "3";
      });
    } else if (widget.name == "Staff") {
      setState(() {
        roles = "2";
      });
    } else if (widget.name == "Management") {
      setState(() {
        roles = "5";
      });
    } else {}
  }

  Future<bool> _userValidate() async {
    Login? response = await login(
        mobileNumber: nameController.text,
        password: passwordController.text,
        role: roles);
    SessionManager prefs = SessionManager();
    if (response != null) {
      await prefs.setAuthToken(response.token.toString());
      await prefs.setRole(widget.name);
      await prefs.setExternalId(response.userid.substring(0, 4));
      await prefs.setTag(response.userid);
      saveTheData(response.token.toString(), response.userid, widget.name);
    }
    return false;
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> listOfProfiles = [];
  void saveTheData(String token, String tag, String role) async {
    final SharedPreferences prefs = await _prefs;
    final String encodedData = ProfileSwap.encode([
      ProfileSwap(
          token: token, tag: tag, role: role, number: '', schoolName: '')
    ]);
    listOfProfiles = (prefs.getStringList('ProfileDetails') ?? []);
    listOfProfiles.add(encodedData);
    prefs.setStringList('ProfileDetails', listOfProfiles);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
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
              // decoration: BoxDecoration(
              //   // ignore: prefer_const_constructors
              //   color: Colors.blue.withOpacity(0.3),

              //   borderRadius: const BorderRadius.only(
              //       topLeft: Radius.elliptical(475.0, 85.0),
              //       topRight: Radius.circular(35.0)),
              // ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(Images.appLogo),
                    Text(
                      "${widget.name} Login",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: const Text(
                        "Login with your registered E-Mail Address/ Mobile No.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (!isEmail(value!) && !isPhone(value)) {
                              return _displaySnackBar(context,
                                  "Please Enter Mobile No /E-Mail Address");
                            }
                            return null;
                          },
                          controller: nameController,

                          style: Theme.of(context).textTheme.bodyText1,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          // textAlignVertical: TextAlignVertical.center,
                          //readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(12),
                            border: InputBorder.none,
                            //fillColor: Colors.grey[300],
                            filled: true,
                            hintText: 'E-Mail Address / Mobile No',
                            prefixIcon: Icon(
                              Icons.account_box,
                              // size: 4 * SizeConfig.heightMultiplier,
                              color: Colors.green.shade400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return _displaySnackBar(
                                  context, "Password cannot be Empty");
                            }
                            return null;
                          },
                          controller: passwordController,
                          obscureText: obscureText2,
                          style: Theme.of(context).textTheme.bodyText1,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          // textAlignVertical: TextAlignVertical.center,
                          //readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            //fillColor: Colors.grey[300],
                            contentPadding: const EdgeInsets.all(12),

                            filled: true,
                            hintText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.green.shade400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: value,
                                //this.value,
                                onChanged: (bool? values) {
                                  setState(() {
                                    value = values!;
                                    obscureText2 = !obscureText2;
                                  });
                                },
                                activeColor: Colors.blueAccent,
                                checkColor: Colors.white,
                              ),
                              const Text("Show Password"),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            child: const Text(
                              "Forgot Password?",
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword(
                                            name: widget.name,
                                            role: roles,
                                          )));
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container(
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(15.0)),
                          //   child: ElevatedButton(
                          //     onPressed: () async {
                          //       nameController.text.isEmpty ||
                          //               nameController.text == ""
                          //           ? Utility.displaySnackBar(context,
                          //               "Please enter E-Mail/Mobile No")
                          //           : await forgotOtp(
                          //                   mobileNumber: nameController.text,
                          //                   role: roles)
                          //               .then((value) {
                          //               if (value['status'] != false) {
                          //                 Navigator.push(
                          //                     context,
                          //                     MaterialPageRoute(
                          //                         builder: (context) => OtpPage(
                          //                               name: widget.name,
                          //                               number:
                          //                                   nameController.text,
                          //                             )));
                          //                 _snackBar(value['message']);
                          //               } else {
                          //                 _snackBar(value['message']);
                          //               }
                          //             });
                          //     },
                          //     style: ElevatedButton.styleFrom(
                          //         shape: const StadiumBorder(),
                          //         primary: Colors.blueAccent,
                          //         onPrimary: Colors.white),
                          //     child: const Text(
                          //       "LOGIN with OTP",
                          //       style: TextStyle(fontSize: 15),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 5,
                          // ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (isEmail(nameController.text) == false &&
                                    isPhone(nameController.text) == false) {
                                  _displaySnackBar(context,
                                      "Please Enter Valid E-Mail/Mobile No");
                                } else {
                                  if (formKey.currentState!.validate()) {
                                    bool value = await _userValidate();
                                    if (widget.name == "Management" ||
                                        widget.name == "Staff") {
                                      await login(
                                              mobileNumber: nameController.text,
                                              password: passwordController.text,
                                              role: roles)
                                          .then((response) {
                                        if (response != null) {
                                          _snackBar('Login Successful!!');
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyApp()),
                                            (Route<dynamic> route) => false,
                                          );
                                          // : Container();
                                        } else {
                                          Utility.displaySnackBar(
                                              context, "Invalid Credentials");
                                        }
                                      });
                                    } else if (widget.name == "Admin") {
                                      await getConfigList().then((response) {
                                        // data!.configuration.classesSections == false ||
                                        //         data!.configuration.management ==
                                        //             false ||
                                        //         data!.configuration.mapStaffs ==
                                        //             false ||
                                        //         data!.configuration.mapStudents ==
                                        //             false ||
                                        //         data!.configuration
                                        //                 .mapSubjects ==
                                        //             false ||
                                        //         data!.configuration.staffs ==
                                        //             false ||
                                        //         data!.configuration.students ==
                                        //             false ||
                                        //         data!.configuration
                                        //                 .subjects ==
                                        //             false
                                        //     ? Navigator.pushReplacement(
                                        //         context,
                                        //         MaterialPageRoute(
                                        //             builder: (context) =>
                                        //                 const OnBoarding()))
                                        //     :
                                        login(
                                                mobileNumber:
                                                    nameController.text,
                                                password:
                                                    passwordController.text,
                                                role: roles)
                                            .then((response) {
                                          if (response != null) {
                                            _snackBar('"Login Successful!!!"');
                                            navigateToHome();
                                          } else {
                                            Utility.displaySnackBar(
                                                context, "Invalid Credentials");
                                          }
                                        });
                                      });
                                    } else {
                                      await login(
                                              mobileNumber: nameController.text,
                                              password: passwordController.text,
                                              role: roles)
                                          .then((response) {
                                        if (response != null) {
                                          _snackBar('"Login Successful!!!"');
                                        } else {
                                          Utility.displaySnackBar(
                                              context, "Invalid Credentials");
                                        }
                                      });
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  primary: Colors.blueAccent,
                                  onPrimary: Colors.white),
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void navigateToHome() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
      (Route<dynamic> route) => false,
    );
  }

  _displaySnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _snackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

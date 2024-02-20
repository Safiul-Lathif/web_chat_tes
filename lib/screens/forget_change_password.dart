// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:ui/api/loginApi.dart';
import 'package:ui/config/images.dart';
import 'package:ui/config/size_config.dart';
import 'package:ui/screens/login_page.dart';

class ForgotChangePassword extends StatefulWidget {
  String name, role, pin, userId;
  ForgotChangePassword(
      {Key? key,
      required this.name,
      required this.pin,
      required this.role,
      required this.userId})
      : super(key: key);

  @override
  State<ForgotChangePassword> createState() => _ForgotChangePasswordState();
}

class _ForgotChangePasswordState extends State<ForgotChangePassword> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool value = false;
  bool obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(Images.appLogo),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Forgot Your Password",
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              "Don't worry we will follow this method to reset"),
                          const SizedBox(
                            height: 30,
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
                                controller: nameController,
                                style: Theme.of(context).textTheme.bodyText1,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                textAlignVertical: TextAlignVertical.center,
                                //readOnly: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  border: InputBorder.none,
                                  //fillColor: Colors.grey[300],
                                  filled: true,
                                  hintText: 'New Password',
                                  prefixIcon: Icon(
                                    Icons.account_box,
                                    size: 4 * SizeConfig.heightMultiplier,
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
                                controller: passwordController,
                                obscureText: obscureText2,
                                style: Theme.of(context).textTheme.bodyText1,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                textAlignVertical: TextAlignVertical.center,
                                //readOnly: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  border: InputBorder.none,
                                  //fillColor: Colors.grey[300],
                                  filled: true,
                                  hintText: 'Re-Type New Password',
                                  prefixIcon: Icon(
                                    Icons.account_box,
                                    size: 4 * SizeConfig.heightMultiplier,
                                    color: Colors.green.shade400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
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
                            height: 30,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (nameController.text.isEmpty ||
                                    passwordController.text.isEmpty) {
                                  _displaySnackBar(
                                      context, "Please Enter All the fields");
                                } else {
                                  if (nameController.text !=
                                      passwordController.text) {
                                    _displaySnackBar(
                                        context, "Password MisMatch");
                                  } else {
                                    resetNewPassword(widget.userId, widget.pin,
                                            widget.role, nameController.text)
                                        .then((value) {
                                      if (value['status'] != false) {
                                        _displaySnackBar(context,
                                            'Password Changed Successfully!!');
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()));
                                      } else {
                                        _displaySnackBar(
                                            context, value['message']);
                                      }
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  primary: Colors.blueAccent,
                                  onPrimary: Colors.white),
                              child: const Text("LOGIN"),
                            ),
                          ),
                        ])
                  ]),
            ),
          )),
    ));
  }

  _displaySnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

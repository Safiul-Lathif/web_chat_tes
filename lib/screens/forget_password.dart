import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:ui/api/loginApi.dart';
import 'package:ui/config/images.dart';
import 'package:ui/config/size_config.dart';
import 'package:ui/screens/forget_otp.dart';
import 'package:ui/utils/utility.dart';

class ForgotPassword extends StatefulWidget {
  String name, role;
  ForgotPassword({Key? key, required this.name, required this.role})
      : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isEmail(String input) => EmailValidator.validate(input);
  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.blue.shade50,
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                  image: const AssetImage(Images.bgImage),
                  repeat: ImageRepeat.repeat)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Images.appLogo),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    "Forgot Your Password",
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Don't worry we will follow this method to reset"),
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
                        validator: (value) {
                          if (!isEmail(value!)) {
                            return _displaySnackBar(context,
                                "Please Enter E-Mail Address/Mobile No");
                          }
                          return null;
                        },
                        controller: nameController,
                        style: Theme.of(context).textTheme.bodyText1,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        textAlignVertical: TextAlignVertical.center,
                        //readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //fillColor: Colors.grey[300],
                          filled: true,
                          hintText: 'E-Mail Address / Mobile No',
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
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty) {
                          _displaySnackBar(context,
                              "Please Enter Mobile No /E-Mail Address");
                        } else if (isEmail(nameController.text) == false &&
                            isPhone(nameController.text) == false) {
                          _displaySnackBar(
                              context, "Please Enter Valid E-Mail/ Mobile No");
                        } else {
                          if (nameController.text.isNotEmpty) {
                            await forgotOtp(
                                    mobileNumber: nameController.text,
                                    role: widget.role)
                                .then((value) {
                              print(value);
                              if (value['status'] != false) {
                                Utility.displaySnackBar(
                                    context, value['message']);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ForgotOtpPage(
                                            role: widget.role,
                                            name: widget.name,
                                            method: nameController.text)));
                              } else {
                                Utility.displaySnackBar(
                                    context, value['message']);
                              }
                            });
                          } else {
                            Utility.displaySnackBar(
                                context, "Please Enter MobileNo/E-Mail");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          primary: Colors.blueAccent,
                          onPrimary: Colors.white),
                      child: const Text("NEXT"),
                    ),
                  ),
                ])
              ])),
    ));
  }

  _displaySnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

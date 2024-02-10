import 'package:flutter/material.dart';
import 'package:ui/api/loginApi.dart';
import 'package:ui/config/images.dart';
import 'package:ui/screens/login_page.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key, this.callback}) : super(key: key);
  Function? callback;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool value = false;
  bool obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
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
            child: Stack(
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Center(
                          child: Image.asset(Images.appLogo),
                        ),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Change Your Password",
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: const Text(
                                "Don't worry we wil follow this method to Change Password",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
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
                                    hintText: 'Old Password',
                                    prefixIcon: Icon(
                                      Icons.account_box,
                                      color: Colors.green.shade400,
                                    ),
                                  ),
                                ),
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
                                    hintText: 'New Password',
                                    prefixIcon: Icon(
                                      Icons.account_box,
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
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (nameController.text.isEmpty ||
                                      passwordController.text.isEmpty) {
                                    _displaySnackBar(
                                        context, "Please Enter Password");
                                  } else {
                                    await changePassword(
                                            oldPassword: nameController.text,
                                            newPassword:
                                                passwordController.text)
                                        .then((value) {
                                      if (value != null &&
                                          value['status'] == true) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()));
                                        _displaySnackBar(
                                            context, value['message']);
                                      } else {
                                        _displaySnackBar(context,
                                            'InValid Current Password');
                                      }
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    primary: Colors.blueAccent,
                                    onPrimary: Colors.white),
                                child: const Text("DONE"),
                              ),
                            ),
                          ])
                    ]),
                Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: () => widget.callback!(),
                        icon: const Icon(Icons.close)))
              ],
            )),
      )),
    );
  }

  _displaySnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.all(20),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

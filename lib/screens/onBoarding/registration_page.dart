import 'package:flutter/material.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/create_profile_api.dart';
import 'package:ui/api/registerApi.dart';
import 'package:ui/config/images.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController academicController = TextEditingController();
  TextEditingController codeController = TextEditingController();

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
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextFormField(
                      controller: schoolController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textAlignVertical: TextAlignVertical.center,
                      //readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(17),
                        border: InputBorder.none,
                        //fillColor: Colors.grey[300],
                        filled: true,
                        hintText: 'Name of your School',
                        prefixIcon: Icon(
                          Icons.school,
                          // size: 4 * SizeConfig.heightMultiplier,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextFormField(
                      controller: nameController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textAlignVertical: TextAlignVertical.center,
                      //readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(17),
                        border: InputBorder.none,
                        //fillColor: Colors.grey[300],
                        filled: true,
                        hintText: 'Your Name',
                        prefixIcon: Icon(
                          Icons.account_circle,
                          // size: 4 * SizeConfig.heightMultiplier,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextFormField(
                      controller: mailController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textAlignVertical: TextAlignVertical.center,
                      //readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(17),
                        border: InputBorder.none,
                        //fillColor: Colors.grey[300],
                        filled: true,
                        hintText: 'E-Mail Address',
                        prefixIcon: Icon(
                          Icons.email,
                          // size: 4 * SizeConfig.heightMultiplier,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextFormField(
                      controller: contactController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      textAlignVertical: TextAlignVertical.center,
                      //readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(17),
                        border: InputBorder.none,
                        //fillColor: Colors.grey[300],
                        filled: true,
                        hintText: 'Contact No',
                        prefixIcon: Icon(
                          Icons.contact_phone,
                          // size: 4 * SizeConfig.heightMultiplier,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textAlignVertical: TextAlignVertical.center,
                      //readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(17),
                        border: InputBorder.none,
                        //fillColor: Colors.grey[300],
                        filled: true,
                        hintText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          // size: 4 * SizeConfig.heightMultiplier,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextFormField(
                      controller: designationController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textAlignVertical: TextAlignVertical.center,
                      //readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(17),
                        border: InputBorder.none,
                        //fillColor: Colors.grey[300],
                        filled: true,
                        hintText: 'Designation',
                        prefixIcon: Icon(
                          Icons.work,
                          // size: 4 * SizeConfig.heightMultiplier,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextFormField(
                      controller: academicController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      textAlignVertical: TextAlignVertical.center,
                      //readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(17),
                        border: InputBorder.none,
                        //fillColor: Colors.grey[300],
                        filled: true,
                        hintText: 'Academic Year',
                        prefixIcon: Icon(
                          Icons.calendar_month,
                          // size: 4 * SizeConfig.heightMultiplier,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextFormField(
                      controller: codeController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      textAlignVertical: TextAlignVertical.center,
                      //readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(17),
                        border: InputBorder.none,
                        //fillColor: Colors.grey[300],
                        filled: true,
                        hintText: 'School Code (Optional)',
                        prefixIcon: Icon(
                          Icons.numbers,
                          // size: 4 * SizeConfig.heightMultiplier,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.27,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                      border: Border.all(color: Colors.red),
                    ),
                    child: const Center(
                      child: Text(
                        "All further configurations are recommended to be done in a web browser or in a desktop system for easy navigation",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.26,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.blueAccent),
                            child: const Text("Cancel"),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (schoolController.text.isEmpty ||
                                  nameController.text.isEmpty ||
                                  mailController.text.isEmpty ||
                                  contactController.text.isEmpty ||
                                  passwordController.text.isEmpty ||
                                  designationController.text.isEmpty ||
                                  academicController.text.isEmpty) {
                                Utility.displaySnackBar(
                                    context, "Please Fill All TextFields");
                              } else {
                                await register(
                                        schoolName: schoolController.text,
                                        name: nameController.text,
                                        mail: mailController.text,
                                        mobileNo: contactController.text,
                                        password: passwordController.text,
                                        designation: designationController.text,
                                        academic: academicController.text,
                                        schoolCode: codeController.text)
                                    .then((response) async {
                                  if (response != null) {
                                    if (response['error'] != "") {
                                      Utility.displaySnackBar(
                                          context, response['error']);
                                    } else {
                                      Utility.displaySnackBar(
                                          context, "Register Successfully");
                                      Navigator.pop(context);
                                    }
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueAccent,
                                shape: const StadiumBorder()),
                            child: const Text("Register"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])),
      ),
    );
  }
}

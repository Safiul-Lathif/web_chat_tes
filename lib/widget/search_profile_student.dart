// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:ui/api/search/get_student_list_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/utils/utils_file.dart';

import '../model/search/student_list_model.dart';

class StudentProfileInfo extends StatefulWidget {
  late StudentList studentList;

  StudentProfileInfo({super.key, required this.studentList});

  @override
  State<StudentProfileInfo> createState() => _StudentProfileInfoState();
}

class _StudentProfileInfoState extends State<StudentProfileInfo> {
  initialize() async {
    await getStudentList(0).then((value) {
      if (value != null) {
        var data = value.data
            .where((element) => element.id == widget.studentList.id)
            .toList();
        setState(() {
          widget.studentList = data[0];
        });
      }
    });
  }

  bool onError = false;
  Future<bool> onBack() async {
    Navigator.pop(context, true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade300,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Center(
              child: Text("Student Profile Information",
                  style: SafeGoogleFont(
                    'Inter',
                    fontSize: 21 * ffem,
                    fontWeight: FontWeight.w500,
                    height: 0.9152272542 * ffem / fem,
                    letterSpacing: 1.4 * fem,
                    color: const Color(0xff575757),
                  ))),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
              width: double.maxFinite,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.blueGrey,
                Colors.blueGrey,
                Colors.transparent,
                Colors.transparent
              ])),
              height: 0.3,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                          child: widget.studentList.profileImage == '' ||
                                  onError
                              ? Image.asset(
                                  'assets/images/profile.png',
                                  width: 88.28 * fem,
                                  height: 81 * fem,
                                )
                              : Container(
                                  height: 88,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(.5),
                                            offset: const Offset(3, 2),
                                            blurRadius: 7)
                                      ],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      image: DecorationImage(
                                          onError: (exception, stackTrace) {
                                            setState(() {
                                              onError = true;
                                            });
                                          },
                                          image: NetworkImage(widget
                                              .studentList.profileImage
                                              .toString()),
                                          fit: BoxFit.cover)),
                                )),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Name : ",
                          style: TextStyle(
                              color: Color(0xff575757),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.studentList.firstName, //mail
                          style: const TextStyle(
                              color: Color(0xff575757),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Class : ",
                          style: TextStyle(
                              color: Color(0xff575757),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.studentList.studentListClass, //mail
                          style: const TextStyle(
                              color: Color(0xff575757),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.only(top: 20),
                  height: MediaQuery.of(context).size.height * 0.42,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.blue.withOpacity(0.2), BlendMode.dstATop),
                          image: const AssetImage(Images.bgImage),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                            bottomRight: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Wrap(
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0, // gap between lines
                        children: [
                          // ticket no :- 92
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: ListTile(
                              title: const Text(
                                "Date of Birth",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff575757)),
                              ),
                              subtitle: Text(widget.studentList.dob == ''
                                  ? "N/A"
                                  : widget.studentList.dob),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: ListTile(
                                title: const Text(
                                  "Admission Number",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff575757)),
                                ),
                                subtitle: Text(
                                    widget.studentList.admissionNumber == ''
                                        ? "N/A"
                                        : widget.studentList.admissionNumber)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: ListTile(
                                title: const Text(
                                  "Class Teacher",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff575757)),
                                ),
                                subtitle: Text(
                                    widget.studentList.classTeacher == ''
                                        ? "N/A"
                                        : widget.studentList.classTeacher)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: ListTile(
                                title: const Text(
                                  "Roll Number",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff575757)),
                                ),
                                subtitle: Text(
                                    widget.studentList.rollNumber == 0
                                        ? "N/A"
                                        : widget.studentList.rollNumber
                                            .toString())),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

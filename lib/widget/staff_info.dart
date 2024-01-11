import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui/config/images.dart';
import 'package:ui/model/profile_model.dart';
import 'package:ui/model/search/staff_list_model.dart';
import 'package:ui/utils/utils_file.dart';

class StaffProfileInfo extends StatefulWidget {
  final StaffSearchList staffProfile;
  final ProfileModel profileModel;

  const StaffProfileInfo(
      {super.key, required this.staffProfile, required this.profileModel});

  @override
  State<StaffProfileInfo> createState() => _StaffProfileInfoState();
}

class _StaffProfileInfoState extends State<StaffProfileInfo> {
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
              child: Text("Staff Profile Info",
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
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: widget.profileModel.profile == ''
                          ? Image.asset(
                              'assets/images/userprofilesymbol.png',
                              width: 88.28 * fem,
                              height: 81 * fem,
                            )
                          : Image.network(
                              widget.profileModel.profile,
                              width: 88.28 * fem,
                              height: 81 * fem,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/userprofilesymbol.png',
                                  width: 88.28 * fem,
                                  height: 81 * fem,
                                );
                              },
                            ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.staffProfile.firstName,
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
                          "Class :",
                          style: TextStyle(
                              color: Color(0xff575757),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          widget.profileModel.className == ''
                              ? "N/A"
                              : widget.profileModel.className,
                          softWrap: true,
                          style: const TextStyle(
                            color: Color(0xff575757),
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: ListTile(
                                title: const Text(
                                  "Mobile Number",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff575757)),
                                ),
                                subtitle: Text(widget.staffProfile.mobileNumber
                                    .toString()),
                              ),
                            ),
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
                                subtitle: Text(widget.profileModel.dob == ''
                                    ? "N/A"
                                    : widget.profileModel.dob),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: ListTile(
                                  title: const Text(
                                    "Date of Joining",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff575757)),
                                  ),
                                  subtitle: Text(widget.profileModel.doj == ''
                                      ? "N/A"
                                      : widget.profileModel.doj)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: ListTile(
                                  title: const Text(
                                    "Employee Number",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff575757)),
                                  ),
                                  subtitle: Text(
                                      widget.profileModel.employeeNo == ''
                                          ? "N/A"
                                          : widget.profileModel.employeeNo)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: ListTile(
                                  title: const Text(
                                    "Designation",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff575757)),
                                  ),
                                  subtitle: Text(
                                    widget.staffProfile.userCategory,
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: Color(0xff575757),
                                      fontSize: 15,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: ListTile(
                                  title: const Text(
                                    "Department",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff575757)),
                                  ),
                                  subtitle: Text(
                                      widget.profileModel.department == ''
                                          ? "N/A"
                                          : widget.profileModel.department)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: ListTile(
                                  title: const Text(
                                    "Last Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff575757)),
                                  ),
                                  subtitle: Text(widget
                                              .profileModel.lastLogin ==
                                          ''
                                      ? "N/A"
                                      : "${(DateFormat.yMMMMEEEEd().format(DateTime.parse(widget.profileModel.lastLogin)))}, ${DateFormat.jms().format(DateTime.parse(widget.profileModel.lastLogin))}  ")),
                            )
                          ],
                        )),
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

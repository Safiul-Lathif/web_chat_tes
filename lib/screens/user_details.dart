// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ui/api/dashboard/dashboard_api.dart';
import 'package:ui/api/main_group_api.dart';
import 'package:ui/api/profile/edit_profile.dart';
import 'package:ui/api/profile_api.dart';
import 'package:ui/config/const.dart';
import 'package:ui/config/images.dart';
import 'package:ui/controllers/image_controller.dart';
import 'package:ui/model/dashboard/dashboard_model.dart';
import 'package:ui/model/main_group_model.dart';
import 'package:ui/model/profile_model.dart';
import 'package:ui/screens/forget_password.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class UserDetailsScreen extends StatefulWidget {
  UserDetailsScreen(
      {super.key,
      this.mobileNumber,
      this.name,
      this.role,
      required this.isGrp});
  String? name;
  String? mobileNumber;
  String? role;
  bool isGrp;
  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  MainGroupList? mainGroup;
  ProfileModel? profiles;
  int installed = 0;
  Dashboard? dashboard;
  int selectedIndex = 0;
  String roles = '';
  @override
  void initState() {
    super.initState();
    initialize();
    if (widget.role == "admin") {
      setState(() {
        roles = "1";
      });
    } else if (widget.role == "Parent") {
      setState(() {
        roles = "3";
      });
    } else if (widget.role == "staff") {
      setState(() {
        roles = "2";
      });
    } else if (widget.role == "management") {
      setState(() {
        roles = "5";
      });
    }
  }

  void initialize() async {
    await getMainGroup().then((value) {
      if (mounted) {
        setState(() {
          mainGroup = value;
        });
      }
    });
    await getProfile(id: "", role: "", studentId: '').then((value) {
      if (value != null) {
        setState(() {
          profiles = value;
        });
      }
    });
    await getDashboardDetails().then((value) {
      setState(() {
        dashboard = value;
      });
    });
  }

  bool isForgetPasswordScreen = true;
  bool isChangePasswordScreen = true;

  List<PlatformFile> selectedPicture = [];
  Uint8List? image;

  void selectImages() async {
    var getImage = await ImageController.pickAndProcessImage();
    if (getImage.images.isNotEmpty) {
      setState(() {
        selectedPicture.clear();
        selectedPicture.addAll(getImage.images);
      });
    }
    if (getImage.errorText != '') _snackBar(getImage.errorText);
  }

  _snackBar(String message) {
    if (message != '') {
      final snackBar = SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        duration: const Duration(milliseconds: 1000),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void onSave(image, BuildContext ctx) {
    editYourProfile(profileImage: selectedPicture, userName: '');
    Navigator.pop(ctx);
    _snackBar('Profile Updated Successfully');
  }

  @override
  Widget build(BuildContext context) {
    return !isForgetPasswordScreen
        ? ForgotPassword(
            name: 'Admin',
            role: '1',
            callback: () {
              setState(() {
                isForgetPasswordScreen = true;
              });
            },
          )
        : Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                      image: const AssetImage(Images.bgImage),
                      repeat: ImageRepeat.repeat)),
              child: mainGroup == null || profiles == null || dashboard == null
                  ? Center(
                      child: Lottie.network(
                        'https://assets8.lottiefiles.com/packages/lf20_fzmasdx7.json',
                        height: 100.0,
                        repeat: true,
                        reverse: true,
                        animate: true,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: MediaQuery.of(context).size.height *
                                        0.92,
                                    padding: const EdgeInsets.only(
                                        top: 100, left: 40),
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade200,
                                        borderRadius: const BorderRadius.only(
                                            topLeft:
                                                Radius.elliptical(600.0, 85.0),
                                            topRight: Radius.circular(35.0)),
                                        image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                                Colors.blue.withOpacity(0.3),
                                                BlendMode.dstATop),
                                            image: const AssetImage(
                                                Images.bgImage),
                                            repeat: ImageRepeat.repeat)),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text('Name :',
                                                style: TextStyle(
                                                    color: Color(0xff575757),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                                widget.isGrp
                                                    ? widget.name!
                                                    : profiles!.name,
                                                style: const TextStyle(
                                                  color: Color(0xff575757),
                                                  fontSize: 18,
                                                )),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Text('Mobile Number :',
                                                style: TextStyle(
                                                    color: Color(0xff575757),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                                widget.isGrp
                                                    ? widget.mobileNumber!
                                                    : profiles!.mobileNo
                                                        .toString(),
                                                style: const TextStyle(
                                                  color: Color(0xff575757),
                                                  fontSize: 18,
                                                )),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            const Text('Forget password',
                                                style: TextStyle(
                                                    color: Color(0xff575757),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isForgetPasswordScreen =
                                                        false;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.password_rounded))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text('Change  password',
                                                style: TextStyle(
                                                    color: Color(0xff575757),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isForgetPasswordScreen =
                                                        false;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.password_rounded))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                    right: 25,
                                    top: 0,
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 70,
                                              backgroundImage: NetworkImage(
                                                  profiles!.profile != ''
                                                      ? profiles!.profile
                                                      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpCKq1XnPYYDaUIlwlsvmLPZ-9-rdK28RToA&usqp=CAU'),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  "Profile Update"),
                                                              actionsAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              actions: [
                                                                selectedPicture
                                                                        .isEmpty
                                                                    ? Center(
                                                                        child:
                                                                            Container(
                                                                        height:
                                                                            130,
                                                                        width:
                                                                            130,
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.transparent,
                                                                            shape: BoxShape.circle,
                                                                            image: DecorationImage(
                                                                                onError: (exception, stackTrace) {
                                                                                  setState(() {
                                                                                    profiles!.profile = "https://cdn.iconscout.com/icon/premium/png-256-thumb/add-user-2639844-2214705.png?f=webp";
                                                                                  });
                                                                                },
                                                                                image: NetworkImage(profiles!.profile == '' ? "https://cdn.iconscout.com/icon/premium/png-256-thumb/add-user-2639844-2214705.png?f=webp" : profiles!.profile),
                                                                                fit: BoxFit.cover),
                                                                            border: Border.all(color: Colors.blueGrey.shade600, width: 2)),
                                                                      ))
                                                                    : Center(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              130,
                                                                          width:
                                                                              130,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.transparent,
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(image: MemoryImage(selectedPicture[0].bytes!), fit: BoxFit.cover),
                                                                              border: Border.all(color: Colors.blueGrey.shade600, width: 2)),
                                                                        ),
                                                                      ),
                                                                Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                    child: ElevatedButton.icon(
                                                                        icon: const Icon(Icons.upload),
                                                                        style: buttonStyle,
                                                                        onPressed: () async {
                                                                          var getImage =
                                                                              await ImageController.pickAndProcessImage();
                                                                          if (getImage
                                                                              .images
                                                                              .isNotEmpty) {
                                                                            setState(() {
                                                                              selectedPicture.clear();
                                                                              selectedPicture.addAll(getImage.images);
                                                                            });
                                                                          }
                                                                          if (getImage.errorText !=
                                                                              '') {
                                                                            _snackBar(getImage.errorText);
                                                                          }
                                                                        },
                                                                        label: const Text("Upload images")),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                    style:
                                                                        buttonStyle,
                                                                    onPressed: () => onSave(
                                                                        profiles!
                                                                            .profile,
                                                                        context),
                                                                    child: const Text(
                                                                        "Save"))
                                                              ],
                                                            );
                                                          });
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          widget.isGrp
                                              ? widget.role!
                                              : mainGroup!.userRole
                                                  .toUpperCase(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: 1),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                            Expanded(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.83,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.blue.withOpacity(0.3),
                                            BlendMode.dstATop),
                                        image: const AssetImage(Images.bgImage),
                                        repeat: ImageRepeat.repeat)),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Text(
                                          mainGroup!.schoolName.toUpperCase(),
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20,
                                                  letterSpacing: 1)),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade300,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(.5),
                                                  offset: const Offset(3, 2),
                                                  blurRadius: 7)
                                            ],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Total Users',
                                                  style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ),
                                                Text(
                                                  dashboard!.totalUsers
                                                      .toString(),
                                                  style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 19,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'DeActive Users',
                                                  style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ),
                                                Text(
                                                  dashboard!.deActiveUserCount
                                                      .toString(),
                                                  style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 19,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ),
                                              ],
                                            ),
                                            Image.asset(
                                              DashboardUi.schoolIcon,
                                              height: 100,
                                              width: 100,
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Wrap(
                                        runSpacing: 15,
                                        spacing: 15,
                                        children: [
                                          dashboardCard(
                                              6,
                                              dashboard!.student.toString(),
                                              DashboardUi.studentsIcon,
                                              (dashboard!.student /
                                                      dashboard!.totalUsers)
                                                  .toDouble(),
                                              'Students',
                                              dashboard!.totalInstalledFather +
                                                  dashboard!
                                                      .totalInstalledMother +
                                                  dashboard!
                                                      .totalInstalledGuardian,
                                              Colors.green),
                                          dashboardCard(
                                              1,
                                              dashboard!.parent.toString(),
                                              DashboardUi.parentsIcon,
                                              (dashboard!.parent /
                                                      dashboard!.totalUsers)
                                                  .toDouble(),
                                              'Parents',
                                              dashboard!.totalInstalledFather +
                                                  dashboard!
                                                      .totalInstalledMother +
                                                  dashboard!
                                                      .totalInstalledGuardian,
                                              Colors.purple),
                                          dashboardCard(
                                              4,
                                              dashboard!.totalTeachingStaff
                                                  .toString(),
                                              DashboardUi.teachingStaffIcon,
                                              (dashboard!.totalTeachingStaff /
                                                      dashboard!.totalUsers)
                                                  .toDouble(),
                                              'Teaching Staff',
                                              dashboard!.totalInstalledTeaching,
                                              Colors.pink),
                                          dashboardCard(
                                              2,
                                              dashboard!.totalNonTeachingStaff
                                                  .toString(),
                                              DashboardUi.nonTeachingIcon,
                                              (dashboard!.totalNonTeachingStaff /
                                                      dashboard!.totalUsers)
                                                  .toDouble(),
                                              'Non Teaching',
                                              dashboard!
                                                  .totalInstalledNonteaching,
                                              Colors.brown),
                                          dashboardCard(
                                              5,
                                              dashboard!.totalAdmin.toString(),
                                              DashboardUi.adminIcon,
                                              (dashboard!.totalAdmin /
                                                      dashboard!.totalUsers)
                                                  .toDouble(),
                                              'Admin',
                                              dashboard!.totalInstalledAdmin,
                                              Colors.yellow),
                                          dashboardCard(
                                              3,
                                              dashboard!.management.toString(),
                                              DashboardUi.managementIcon,
                                              (dashboard!.management /
                                                      dashboard!.totalUsers)
                                                  .toDouble(),
                                              'Management',
                                              dashboard!
                                                  .totalInstalledManagement,
                                              Colors.blue),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
            ),
          );
  }

  dashboardCard(int index, String count, String logo, double percentage,
      String title, int installed, Color color) {
    double height = selectedIndex == index
        ? MediaQuery.of(context).size.height * 0.2
        : MediaQuery.of(context).size.height * 0.17;
    double width = selectedIndex == index
        ? MediaQuery.of(context).size.width * 0.31
        : MediaQuery.of(context).size.width * 0.28;
    return AnimatedContainer(
      height: height,
      width: width,
      duration: const Duration(seconds: 1),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.blueGrey.shade300,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    offset: const Offset(3, 2),
                    blurRadius: 7)
              ],
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: selectedIndex == index
              ? title == 'Parents'
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "$title($count)",
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'F(${dashboard!.totalFather})',
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Text(
                                  dashboard!.totalInstalledFather.toString(),
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'M(${dashboard!.totalMother})',
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Text(
                                  dashboard!.totalInstalledMother.toString(),
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'G(${dashboard!.totalGuardian})',
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Text(
                                  dashboard!.totalInstalledGuardian.toString(),
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          title == 'Inactive Users'
                              ? "Inactive App Users"
                              : title,
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Total',
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Text(
                                  title == 'Inactive Users'
                                      ? dashboard!.totalUsers.toString()
                                      : count,
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  title == 'Inactive Users'
                                      ? 'Inactive'
                                      : 'Installed',
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Text(
                                  installed.toString(),
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                        Text(
                          count,
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold)),
                        ),
                        LinearPercentIndicator(
                          width: 200.0,
                          lineHeight: 5.0,
                          percent: percentage.toDouble(),
                          progressColor: title == 'Inactive Users'
                              ? Colors.red
                              : Colors.black,
                        )
                      ],
                    ),
                    Image.asset(
                      logo,
                      height: 100,
                      width: 100,
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

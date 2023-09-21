import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/api/attendance/attendance_api.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/attendance/attendance_model.dart';
import 'package:ui/widget/attendance/school_attendance_list.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key, required this.schoolName});
  final String schoolName;

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  AttendanceModel? attendanceModel;
  @override
  void initState() {
    super.initState();
    getAttendance();
    initialize();
  }

  void initialize() async {
    await getAttendanceInfo().then((value) {
      if (value != null) {
        setState(() {
          attendanceModel = value;
        });
      }
    });
  }

  void getAttendance() async {
    await getAttendanceInfo().then((value) {
      if (value != null) {
        setState(() {
          AttendanceInfo.allAttendanceInfos.clear();
          AttendanceInfo.allAttendanceInfos = [
            AttendanceInfo(
                'P',
                [const Color(0xff64a78b), const Color(0xff69c767)],
                value.presentTotal.toString(),
                value.presentPercentage.toString()),
            AttendanceInfo(
                'A',
                [Colors.pinkAccent, Colors.pink],
                value.absentTotal.toString(),
                value.absentPercentage.toString()),
          ];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.blue.withOpacity(0.3), BlendMode.dstATop),
              image: const AssetImage("assets/images/bg_image_tes.jpg"),
              fit: BoxFit.fill,
            )),
        child: attendanceModel == null
            ? LoadingAnimator()
            : Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                        top: 20,
                        bottom: MediaQuery.of(context).size.height * 0.11),
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          size: 30,
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.elliptical(450.0, 50.0),
                            topRight: Radius.circular(35.0)),
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                          image: const AssetImage(
                              "assets/images/bg_image_tes.jpg"),
                          fit: BoxFit.fill,
                        )),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 20),
                              child: Text(
                                widget.schoolName,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Number of Students : ",
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey)),
                                ),
                                Text(
                                  attendanceModel!.studentsCount.toString(),
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              "Today's Attendance",
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int i = 0;
                                    i <
                                        AttendanceInfo
                                            .allAttendanceInfos.length;
                                    i++)
                                  Column(
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0.0, 1.0), //(x,y)
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                          gradient: LinearGradient(
                                              colors: AttendanceInfo
                                                  .allAttendanceInfos[i].colors,
                                              begin: Alignment.topLeft,
                                              end: Alignment.centerRight),
                                        ),
                                        child: Center(
                                          child: Text(
                                              AttendanceInfo
                                                  .allAttendanceInfos[i].title,
                                              style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 50))),
                                        ),
                                      ),
                                      Text(
                                        AttendanceInfo
                                            .allAttendanceInfos[i].attendance,
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28)),
                                      ),
                                      Text(
                                        "${AttendanceInfo.allAttendanceInfos[i].percentage}%",
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey)),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Attendance Completed",
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900)),
                            ),
                            const Spacer(),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.blue.shade900)),
                                onPressed: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const SchoolAttendanceList(),
                                  //     ));
                                },
                                child: Text("Explore",
                                    style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)))),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

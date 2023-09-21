import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/api/attendance/attendance_api.dart';
import 'package:ui/api/attendance/school_attendance_list_api.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/attendance/attendance_model.dart';
import 'package:ui/model/attendance/school_attendance_list_model.dart';

class SchoolAttendanceList extends StatefulWidget {
  const SchoolAttendanceList({super.key, required this.callBack});
  final Function callBack;

  @override
  State<SchoolAttendanceList> createState() => _SchoolAttendanceListState();
}

class _SchoolAttendanceListState extends State<SchoolAttendanceList> {
  SchoolAttendanceListModel? attendanceModel;
  String totalStudents = '';
  @override
  void initState() {
    super.initState();
    initialize();
  }

  int selectedIndex = 0;

  void initialize() async {
    await getSchoolAttendanceList().then((value) {
      if (value != null) {
        setState(() {
          attendanceModel = value;
          widget.callBack(
              attendanceModel!.attendance[0].classConfigId.toString(),
              attendanceModel!.attendance[0].classSectionName.toString());
          selectedIndex = attendanceModel!.attendance[0].classConfigId;
          AttendanceInfo.allAttendanceInfos.clear();
          AttendanceInfo.allAttendanceInfos = [
            AttendanceInfo(
                'P',
                [const Color(0xff64a78b), const Color(0xff69c767)],
                value.schoolAttendance.presentTotal.toString(),
                value.schoolAttendance.presentPercentage.toString()),
            AttendanceInfo(
                'A',
                [Colors.pinkAccent, Colors.pink],
                value.schoolAttendance.absentTotal.toString(),
                value.schoolAttendance.absentPercentage.toString()),
          ];
        });
      }
    });
    await getAttendanceInfo().then((value) {
      if (value != null) {
        setState(() {
          totalStudents = value.studentsCount.toString();
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
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                image: const AssetImage("assets/images/bg_image_tes.jpg"),
                repeat: ImageRepeat.repeatX)),
        child: attendanceModel == null
            ? LoadingAnimator()
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0;
                          i < AttendanceInfo.allAttendanceInfos.length;
                          i++)
                        Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.only(bottom: 5),
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
                                    AttendanceInfo.allAttendanceInfos[i].title,
                                    style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30))),
                              ),
                            ),
                            Text(
                              AttendanceInfo.allAttendanceInfos[i].attendance,
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                            Text(
                              "${AttendanceInfo.allAttendanceInfos[i].percentage}%",
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey)),
                            ),
                          ],
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Total Students : $totalStudents",
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.red)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Attendance Left : ${attendanceModel!.leftStudents.toString()} Students",
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.red)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Total Classes : ${attendanceModel!.attendance.length.toString()}",
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.red)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey.shade200)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            "Class Name",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                          ),
                        ),
                        for (int i = 0;
                            i < AttendanceInfo.allAttendanceInfos.length;
                            i++)
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Container(
                              height: 30,
                              width: 30,
                              margin: const EdgeInsets.only(bottom: 5),
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
                                    AttendanceInfo.allAttendanceInfos[i].title,
                                    style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20))),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView.builder(
                      itemCount: attendanceModel!.attendance.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.callBack(
                                        attendanceModel!
                                            .attendance[index].classConfigId
                                            .toString(),
                                        attendanceModel!
                                            .attendance[index].classSectionName
                                            .toString());
                                    selectedIndex = attendanceModel!
                                        .attendance[index].classConfigId;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: Text(
                                        attendanceModel!
                                            .attendance[index].classSectionName
                                            .toString(),
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: Center(
                                          child: Column(
                                        children: [
                                          Text(
                                            attendanceModel!
                                                .attendance[index].presentTotal
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            )),
                                          ),
                                          Text(
                                            "${attendanceModel!.attendance[index].presentPercentage.toString()}%",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.blueGrey)),
                                          ),
                                        ],
                                      )),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: Center(
                                          child: Column(
                                        children: [
                                          Text(
                                            attendanceModel!
                                                .attendance[index].absentTotal
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            )),
                                          ),
                                          Text(
                                            "${attendanceModel!.attendance[index].absentPercentage.toString()}%",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.blueGrey)),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider()
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

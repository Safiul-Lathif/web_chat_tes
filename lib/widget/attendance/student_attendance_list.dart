import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/api/attendance/update_attendance_api.dart';
import 'package:ui/model/attendance/attendance_model.dart';
import 'package:ui/model/attendance/school_attendance_list_model.dart';
import 'package:ui/utils/utils_file.dart';
import '../../model/attendance/students_attendance_model.dart';

class StudentAttendanceList extends StatefulWidget {
  const StudentAttendanceList(
      {super.key,
      required this.configId,
      required this.className,
      required this.callback,
      required this.studentList,
      required this.attendanceList});
  final String configId;
  final String className;
  final Function callback;
  final List<StudentsAttendanceModel> studentList;
  final List<AttendanceSubmitList> attendanceList;

  @override
  State<StudentAttendanceList> createState() => _StudentAttendanceListState();
}

class _StudentAttendanceListState extends State<StudentAttendanceList> {
  List<AttendanceSubmitList> absentList = [];

  bool onError = false;

  Future<bool> goBack() async {
    Navigator.pop(context, true);
    return true;
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
                repeat: ImageRepeat.repeatX)),
        child: widget.studentList.isEmpty
            ? Center(
                child: Lottie.asset(
                  'assets/lottie/no_data.json',
                  width: MediaQuery.of(context).size.width * 0.3,
                  repeat: true,
                  reverse: true,
                  animate: true,
                ),
              )
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey.shade200)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.33,
                          child: Text(
                            "Student Name (${widget.className})",
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
                    height: MediaQuery.of(context).size.height * 0.83,
                    child: ListView.builder(
                      itemCount: widget.studentList.length,
                      itemBuilder: (context, index) {
                        var student = widget.studentList[index];
                        student.attendanceStatus == 0
                            ? student.attendanceStatus = 1
                            : null;

                        return Column(
                          children: [
                            InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    child: Image.network(
                                      student.profileImage,
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.network(
                                          "https://cdn-icons-png.flaticon.com/512/3177/3177440.png",
                                          height: 40,
                                          width: 40,
                                        );
                                      },
                                    ),
                                  )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              titlePadding:
                                                  const EdgeInsets.all(8.0),
                                              title: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    child: Image.network(
                                                      student.profileImage,
                                                      height: 80,
                                                      width: 80,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Image.network(
                                                          "https://cdn-icons-png.flaticon.com/512/3177/3177440.png",
                                                          height: 80,
                                                          width: 80,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Name : ",
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        student.firstName,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Admission Number : ",
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        student.admissionNumber,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Roll Number : ",
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        student.rollNumber
                                                            .toString(),
                                                        style: GoogleFonts.lato(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Total Days: ",
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        student.totalDays
                                                            .toString(),
                                                        style: GoogleFonts.lato(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Total Present : ",
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        student.presentTotal
                                                            .toString(),
                                                        style: GoogleFonts.lato(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Total Absent: ",
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        student.absentTotal
                                                            .toString(),
                                                        style: GoogleFonts.lato(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Overall Percentage: ",
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        "${student.presentPercentage.toString()} %",
                                                        style: GoogleFonts.lato(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Attendance Status : ",
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        student.attendanceStatus ==
                                                                1
                                                            ? "Present"
                                                            : "Absent",
                                                        style: GoogleFonts.lato(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Attendance Date : ",
                                                        style: GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                                'd MMMM, yyyy')
                                                            .format(student
                                                                .attendanceDate),
                                                        style: GoogleFonts.lato(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        student.firstName,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            student.attendanceStatus = 1;
                                            widget.attendanceList.removeWhere(
                                                (element) =>
                                                    element.studentId ==
                                                    student.id.toString());
                                            widget.attendanceList.add(
                                                AttendanceSubmitList(
                                                    studentId:
                                                        student.id.toString(),
                                                    attendanceStatus: "1",
                                                    studentName:
                                                        student.firstName));
                                            absentList.removeWhere((element) =>
                                                element.studentId ==
                                                student.id.toString());
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: student.attendanceStatus ==
                                                          1 &&
                                                      student.attendanceStatus !=
                                                          0
                                                  ? Colors.green.shade400
                                                  : Colors.blueGrey.shade100),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            student.attendanceStatus = 2;
                                            widget.attendanceList.removeWhere(
                                                (element) =>
                                                    element.studentId ==
                                                    student.id.toString());
                                            widget.attendanceList.add(
                                                AttendanceSubmitList(
                                                    studentName:
                                                        student.firstName,
                                                    studentId:
                                                        student.id.toString(),
                                                    attendanceStatus: "2"));
                                            absentList.add(AttendanceSubmitList(
                                                studentName: student.firstName,
                                                studentId:
                                                    student.id.toString(),
                                                attendanceStatus: "2"));
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          margin: const EdgeInsets.all(5),
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: student.attendanceStatus ==
                                                          2 &&
                                                      student.attendanceStatus !=
                                                          0
                                                  ? Colors.red.shade400
                                                  : Colors.blueGrey.shade100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                            backgroundColor: MaterialStatePropertyAll(
                                Colors.blueGrey.shade400)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Scaffold(
                                backgroundColor: Colors.transparent,
                                body: CupertinoAlertDialog(
                                  title: Text(
                                    "Are you sure you want to Submit Attendance?",
                                    style: GoogleFonts.lato(fontSize: 17),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel")),
                                    TextButton(
                                        onPressed: () async {
                                          if (absentList.isEmpty) {
                                            await updateAttendanceList(
                                                    attendanceList:
                                                        widget.attendanceList,
                                                    classConfig:
                                                        widget.configId)
                                                .then((value) {
                                              if (value != null) {
                                                widget.callback();
                                                Navigator.pop(context);
                                                _snackBar(
                                                    "Attendance Updated Successfully");
                                              } else {
                                                Navigator.pop(context);
                                                _snackBar(
                                                    "Attendance not Updated");
                                              }
                                            });
                                          } else {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Cancel")),
                                                    TextButton(
                                                      child:
                                                          const Text("Submit"),
                                                      onPressed: () async {
                                                        await updateAttendanceList(
                                                                attendanceList:
                                                                    widget
                                                                        .attendanceList,
                                                                classConfig:
                                                                    widget
                                                                        .configId)
                                                            .then((value) {
                                                          if (value != null) {
                                                            widget.callback();
                                                            Navigator.pop(
                                                                context);
                                                            _snackBar(
                                                                "Attendance Updated Successfully");
                                                          } else {
                                                            Navigator.pop(
                                                                context);
                                                            _snackBar(
                                                                "Attendance not Updated");
                                                          }
                                                        });
                                                      },
                                                    )
                                                  ],
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "You've marked absent for these students",
                                                        style: SafeGoogleFont(
                                                            "Lato",
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: const Color(
                                                                0xff2A232D)),
                                                      ),
                                                      for (int i = 0;
                                                          i < absentList.length;
                                                          i++)
                                                        Text(
                                                          "${i + 1})  ${absentList[i].studentName}",
                                                          style: SafeGoogleFont(
                                                              "Lato",
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: const Color(
                                                                  0xff2A232D)),
                                                        ),
                                                      Text(
                                                        "Make sure the notification will send to the parents!",
                                                        style: SafeGoogleFont(
                                                            "Lato",
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: const Color(
                                                                0xff2A232D)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: const Text("Submit"))
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          "Submit Attendance",
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
      ),
    );
  }

  _snackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
      duration: const Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

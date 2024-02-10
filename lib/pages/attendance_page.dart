import 'package:flutter/material.dart';
import 'package:ui/api/attendance/attendance_api.dart';
import 'package:ui/api/attendance/student_list_api.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/attendance/attendance_model.dart';
import 'package:ui/model/attendance/school_attendance_list_model.dart';
import 'package:ui/model/attendance/students_attendance_model.dart';
import 'package:ui/widget/attendance/school_attendance_list.dart';
import 'package:ui/widget/attendance/student_attendance_list.dart';

import '../api/attendance/school_attendance_list_api.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  AttendanceModel? attendanceModel;
  List<StudentsAttendanceModel> studentList = [];
  List<AttendanceSubmitList> attendanceList = [];
  SchoolAttendanceListModel? schoolAttendanceListModel;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    initialize();
    getAttendance();
  }

  void initialize() async {
    await getAttendanceInfo().then((value) {
      if (value != null) {
        setState(() {
          attendanceModel = value;
        });
      }
    });
    await getStudentsAttendanceList(id).then((value) {
      if (value != null) {
        setState(() {
          attendanceList.clear();
          studentList = value;
          for (int i = 0; i < value.length; i++) {
            attendanceList.add(AttendanceSubmitList(
                studentName: value[i].firstName,
                studentId: value[i].id.toString(),
                attendanceStatus: value[i].attendanceStatus.toString() == "0"
                    ? "1"
                    : value[i].attendanceStatus.toString()));
          }
        });
      }
    });
    await getAttendance();
    setState(() {
      isLoading = false;
    });
  }

  String id = "";
  String name = '';

  void getSelectedClass(classId, className) {
    isLoading = true;
    setState(() {
      id = classId;
      name = className;
      initialize();
    });
  }

  Future<void> getAttendance() async {
    await getSchoolAttendanceList().then((value) {
      if (value != null) {
        setState(() {
          schoolAttendanceListModel = value;
        });
      }
    });
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
                  repeat: ImageRepeat.repeatX)),
          child: Row(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: SchoolAttendanceList(
                    attendanceModel: schoolAttendanceListModel,
                    callBack: getSelectedClass,
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: isLoading
                      ? LoadingAnimator()
                      : StudentAttendanceList(
                          callback: initialize,
                          configId: id,
                          studentList: studentList,
                          className: name,
                          attendanceList: attendanceList,
                        )),
            ],
          )),
    );
  }
}

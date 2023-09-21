import 'package:flutter/material.dart';

class AttendanceModel {
  int studentsCount;
  int presentTotal;
  int absentTotal;
  int leaveTotal;
  int presentPercentage;
  int absentPercentage;
  int leavePercentage;

  AttendanceModel(
      {required this.studentsCount,
      required this.presentTotal,
      required this.absentTotal,
      required this.leaveTotal,
      required this.presentPercentage,
      required this.absentPercentage,
      required this.leavePercentage});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        studentsCount: json["students_count"] ?? 0,
        presentTotal: json["present_total"] ?? 0,
        absentTotal: json["absent_total"] ?? 0,
        leaveTotal: json["leave_total"] ?? 0,
        presentPercentage: json["present_percentage"] ?? 0,
        absentPercentage: json["absent_percentage"] ?? 0,
        leavePercentage: json["leave_percentage"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "students_count": studentsCount,
        "present_total": presentTotal,
        "absent_total": absentTotal,
        "leave_total": leaveTotal,
        "present_percentage": presentPercentage,
        "absent_percentage": absentPercentage,
        "leave_percentage": leavePercentage,
      };
}

class AttendanceInfo {
  final String title;
  final List<Color> colors;
  final String attendance;
  final String percentage;

  AttendanceInfo(this.title, this.colors, this.attendance, this.percentage);
  static List<AttendanceInfo> allAttendanceInfos =
      List<AttendanceInfo>.empty(growable: true);
}

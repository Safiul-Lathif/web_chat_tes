import 'package:flutter/material.dart';

class ClassesModel {
  final String name;
  final String role;
  final String pending;
  final String reads;
  final Color nameColor;
  final Color contentColor;
  final Color color;
  final Color bgColor;
  ClassesModel(
      {required this.name,
      required this.role,
      required this.color,
      required this.pending,
      required this.bgColor,
      required this.reads,
      required this.nameColor,
      required this.contentColor});
  static ClassesModel fromJson(json) => ClassesModel(
      contentColor: json['contentColor'],
      name: json['name'],
      nameColor: json['nameColor'],
      reads: json['reads'],
      role: json['role'],
      color: json['color'],
      pending: json['pending'],
      bgColor: json['bgColor']);
}

List<ClassesModel> getAllTheList() {
  var listofData = [
    {
      "name": "LKG - A",
      "role": "Class Teacher: Aswin",
      "pending": "Approval Bending : 10",
      "reads": "Yeat to read: 5",
      "nameColor": Colors.pink.shade300,
      "bgColor": Colors.pink.shade200,
      "color": Colors.pink,
      "contentColor": Colors.pink.shade50
    },
    {
      "name": "LKG - B",
      "role": "Class Teacher: Sudarsan",
      "pending": "Approval Bending : 10",
      "reads": "Yeat to read: 5",
      "bgColor": Colors.green.shade200,
      "nameColor": Colors.green.shade300,
      "color": Colors.green,
      "contentColor": Colors.green.shade100
    },
    {
      "name": "UKG - Orange",
      "role": "Class Teacher: Vignesh",
      "pending": "Approval Bending : 10",
      "reads": "Yeat to read: 5",
      "nameColor": Colors.purple.shade300,
      "bgColor": Colors.purple.shade200,
      "color": Colors.purple,
      "contentColor": Colors.purple.shade50
    },
    {
      "name": "UKG - Lily",
      "role": "Class Teacher: Varathan",
      "pending": "Approval Bending : 10",
      "reads": "Yeat to read: 5",
      "nameColor": Colors.blue.shade300,
      "bgColor": Colors.blue.shade200,
      "color": Colors.blue,
      "contentColor": Colors.blue.shade50
    },
    {
      "name": "I - Blossem",
      "role": "Class Teacher: Prakash",
      "pending": "Approval Bending : 10",
      "reads": "Yeat to read: 5",
      "nameColor": Colors.red.shade300,
      "bgColor": Colors.red.shade200,
      "color": Colors.red,
      "contentColor": Colors.red.shade50
    },
    {
      "name": "I -Rose",
      "role": "Class Teacher: Praveen",
      "pending": "Approval Bending : 10",
      "reads": "Yeat to read: 5",
      "nameColor": Colors.indigo.shade300,
      "bgColor": Colors.indigo.shade200,
      "color": Colors.indigo,
      "contentColor": Colors.indigo.shade50
    },
  ];
  return listofData.map<ClassesModel>(ClassesModel.fromJson).toList();
}

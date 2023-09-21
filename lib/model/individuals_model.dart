import 'package:flutter/material.dart';

class IndividualsModel {
  final String name;
  final String role;
  final String subject;
  final String reads;
  final String icons;
  final Color nameColor;
  final Color contentColor;
  final Color color;
  final Color bgColor;
  IndividualsModel(
      {required this.name,
      required this.role,
      required this.color,
      required this.subject,
      required this.bgColor,
      required this.reads,
      required this.icons,
      required this.nameColor,
      required this.contentColor});
  static IndividualsModel fromJson(json) => IndividualsModel(
      contentColor: json['contentColor'],
      icons: json['icons'],
      name: json['name'],
      nameColor: json['nameColor'],
      reads: json['reads'],
      role: json['role'],
      color: json['color'],
      subject: json['subject'],
      bgColor: json['bgColor']);
}

List<IndividualsModel> getAllTheList() {
  var listofData = [
    {
      "name": "Aswin",
      "role": "Class Teacher: LKG - A",
      "subject": "Subject:Maths",
      "reads": "Yeat to read: 5",
      "nameColor": Colors.pink.shade300,
      "bgColor": Colors.pink.shade200,
      "color": Colors.pink,
      "icons": "https://cdn-icons-png.flaticon.com/512/1271/1271359.png",
      "contentColor": Colors.pink.shade50
    },
    {
      "name": "Janarthan",
      "role": "Non-teaching Staff",
      "subject": "Subject:Physical Trainer",
      "reads": "Yeat to read: 5",
      "bgColor": Colors.green.shade200,
      "nameColor": Colors.green.shade300,
      "color": Colors.green,
      "icons": "https://cdn-icons-png.flaticon.com/512/1271/1271359.png",
      "contentColor": Colors.green.shade100
    },
    {
      "name": "Prakash Jaganathan",
      "role": "Management",
      "subject": "Subject:N/A",
      "reads": "Yeat to read: 5",
      "nameColor": Colors.purple.shade300,
      "bgColor": Colors.purple.shade200,
      "color": Colors.purple,
      "icons": "https://cdn-icons-png.flaticon.com/512/1271/1271359.png",
      "contentColor": Colors.purple.shade50
    },
    {
      "name": "Roja",
      "role": "Class teacher: N/A",
      "subject": "Subject: Physics",
      "reads": "Yeat to read: 5",
      "nameColor": Colors.blue.shade300,
      "bgColor": Colors.blue.shade200,
      "color": Colors.blue,
      "icons": "https://cdn-icons-png.flaticon.com/512/286/286806.png",
      "contentColor": Colors.blue.shade50
    },
    {
      "name": "Sudarsan",
      "role": "Class teacher: Prakash",
      "subject": "Subject: Social Science",
      "reads": "Yeat to read: 5",
      "nameColor": Colors.red.shade300,
      "bgColor": Colors.red.shade200,
      "color": Colors.red,
      "icons": "https://cdn-icons-png.flaticon.com/512/1271/1271359.png",
      "contentColor": Colors.red.shade50
    },
    {
      "name": "Pavithra",
      "role": "Class teacher: N/A",
      "subject": "Subject: Physics",
      "reads": "Yeat to read: 5",
      "nameColor": Colors.indigo.shade300,
      "bgColor": Colors.indigo.shade200,
      "color": Colors.indigo,
      "icons": "https://cdn-icons-png.flaticon.com/512/286/286806.png",
      "contentColor": Colors.indigo.shade50
    },
  ];
  return listofData.map<IndividualsModel>(IndividualsModel.fromJson).toList();
}

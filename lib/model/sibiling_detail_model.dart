// class SiblingDetail {
//   SiblingDetail({
//     required this.id,
//     required this.firstName,
//     required this.gender,
//     required this.classConfig,
//   });

//   int id;
//   String firstName;
//   int gender;
//   int classConfig;

//   factory SiblingDetail.fromJson(Map<String, dynamic> json) => SiblingDetail(
//         id: json["id"],
//         firstName: json["first_name"],
//         gender: json["gender"],
//         classConfig: json["class_config"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "first_name": firstName,
//         "gender": gender,
//         "class_config": classConfig,
//       };
// }
import 'package:flutter/src/material/dropdown.dart';

class SiblingDetail {
  SiblingDetail({
    required this.siblingstudentDetails,
    required this.parentDetails,
  });

  List<SiblingstudentDetail> siblingstudentDetails;
  ParentDetails parentDetails;

  factory SiblingDetail.fromJson(Map<String, dynamic> json) => SiblingDetail(
        siblingstudentDetails: List<SiblingstudentDetail>.from(
            json["siblingstudent_details"]
                .map((x) => SiblingstudentDetail.fromJson(x))),
        parentDetails: ParentDetails.fromJson(json["parent_details"]),
      );

  Map<String, dynamic> toJson() => {
        "siblingstudent_details":
            List<dynamic>.from(siblingstudentDetails.map((x) => x.toJson())),
        "parent_details": parentDetails.toJson(),
      };

  map(DropdownMenuItem<Object> Function(dynamic item) param0) {}
}

class ParentDetails {
  ParentDetails({
    required this.name,
    required this.mobileNo,
  });

  String name;
  int mobileNo;

  factory ParentDetails.fromJson(Map<String, dynamic> json) => ParentDetails(
        name: json["name"],
        mobileNo: json["mobile_no"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_no": mobileNo,
      };
}

class SiblingstudentDetail {
  SiblingstudentDetail({
    required this.id,
    required this.firstName,
    required this.gender,
    required this.classConfig,
  });

  int id;
  String firstName;
  int gender;
  int classConfig;

  factory SiblingstudentDetail.fromJson(Map<String, dynamic> json) =>
      SiblingstudentDetail(
        id: json["id"],
        firstName: json["first_name"],
        gender: json["gender"],
        classConfig: json["class_config"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "gender": gender,
        "class_config": classConfig,
      };
}

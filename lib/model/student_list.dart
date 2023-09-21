// class Studenttlist {
//     Studenttlist({
//         required this.id,
//         required this.studentName,
//         required this.fatherMobileNumber,
//         required this.fatherEmailAddress,
//         required this.fatherName,
//         required this.motherMobileNumber,
//         this.motherEmailAddress,
//         required this.motherName,
//         required this.guardianMobileNumber,
//         required this.guardianEmailAddress,
//         required this.guardianName,
//         required this.admissionNumber,
//         required this.rollNo,
//         required this.gender,
//         required this.photo,
//         required this.temporaryStudent,
//         this.classSection,
//     });

//     int id;
//     String studentName;
//     int fatherMobileNumber;
//     String fatherEmailAddress;
//     String fatherName;
//     int motherMobileNumber;
//     String? motherEmailAddress;
//     String motherName;
//     String guardianMobileNumber;
//     String guardianEmailAddress;
//     String guardianName;
//     String admissionNumber;
//     int rollNo;
//     String gender;
//     String photo;
//     String temporaryStudent;
//     int? classSection;

//     factory Studenttlist.fromJson(Map<String, dynamic> json) => Studenttlist(
//         id: json["id"],
//         studentName: json["student_name"],
//         fatherMobileNumber: json["father_mobile_number"],
//         fatherEmailAddress: json["father_email_address"],
//         fatherName: json["father_name"],
//         motherMobileNumber: json["mother_mobile_number"],
//         motherEmailAddress: json["mother_email_address"],
//         motherName: json["mother_name"],
//         guardianMobileNumber: json["guardian_mobile_number"],
//         guardianEmailAddress: json["guardian_email_address"],
//         guardianName: json["guardian_name"],
//         admissionNumber: json["admission_number"],
//         rollNo: json["roll_no"],
//         gender: json["gender"],
//         photo: json["photo"],
//         temporaryStudent: json["temporary_student"],
//         classSection: json["class_section"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "student_name": studentName,
//         "father_mobile_number": fatherMobileNumber,
//         "father_email_address": fatherEmailAddress,
//         "father_name": fatherName,
//         "mother_mobile_number": motherMobileNumber,
//         "mother_email_address": motherEmailAddress,
//         "mother_name": motherName,
//         "guardian_mobile_number": guardianMobileNumber,
//         "guardian_email_address": guardianEmailAddress,
//         "guardian_name": guardianName,
//         "admission_number": admissionNumber,
//         "roll_no": rollNo,
//         "gender": gender,
//         "photo": photo,
//         "temporary_student": temporaryStudent,
//         "class_section": classSection,
//     };
// }
class Studenttlist {
    Studenttlist({
        required this.id,
        required this.firstName,
        required this.mobileNumber,
    });

    int id;
    String firstName;
    int mobileNumber;

    factory Studenttlist.fromJson(Map<String, dynamic> json) => Studenttlist(
        id: json["id"],
        firstName: json["first_name"],
        mobileNumber: json["mobile_number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "mobile_number": mobileNumber,
    };
}

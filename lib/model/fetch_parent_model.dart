class FetchparentList {
    FetchparentList({
        required this.studentId,
        required this.studentName,
        required this.fatherMobileNumber,
        required this.fatherEmailAddress,
        required this.fatherName,
        required this.fatherId,
        required this.motherMobileNumber,
        required this.motherEmailAddress,
        required this.motherName,
        required this.motherId,
        required this.guardianMobileNumber,
        required this.guardianEmailAddress,
        required this.guardianName,
        required this.guardianId,
        required this.admissionNumber,
        required this.rollNo,
        required this.gender,
        required this.photo,
        required this.temporaryStudent,
        required this.classSection,
    });

    int studentId;
    String studentName;
    String fatherMobileNumber;
    String fatherEmailAddress;
    String fatherName;
    int fatherId;
    int motherMobileNumber;
    String motherEmailAddress;
    String motherName;
    int motherId;
    String guardianMobileNumber;
    String guardianEmailAddress;
    String guardianName;
    int guardianId;
    String admissionNumber;
    int rollNo;
    String gender;
    String photo;
    String temporaryStudent;
    int classSection;

    factory FetchparentList.fromJson(Map<String, dynamic> json) => FetchparentList(
        studentId: json["student_id"],
        studentName: json["student_name"],
        fatherMobileNumber: json["father_mobile_number"],
        fatherEmailAddress: json["father_email_address"],
        fatherName: json["father_name"],
        fatherId: json["father_id"],
        motherMobileNumber: json["mother_mobile_number"],
        motherEmailAddress: json["mother_email_address"],
        motherName: json["mother_name"],
        motherId: json["mother_id"],
        guardianMobileNumber: json["guardian_mobile_number"],
        guardianEmailAddress: json["guardian_email_address"],
        guardianName: json["guardian_name"],
        guardianId: json["guardian_id"],
        admissionNumber: json["admission_number"],
        rollNo: json["roll_no"],
        gender: json["gender"],
        photo: json["photo"],
        temporaryStudent: json["temporary_student"],
        classSection: json["class_section"],
    );

    Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "student_name": studentName,
        "father_mobile_number": fatherMobileNumber,
        "father_email_address": fatherEmailAddress,
        "father_name": fatherName,
        "father_id": fatherId,
        "mother_mobile_number": motherMobileNumber,
        "mother_email_address": motherEmailAddress,
        "mother_name": motherName,
        "mother_id": motherId,
        "guardian_mobile_number": guardianMobileNumber,
        "guardian_email_address": guardianEmailAddress,
        "guardian_name": guardianName,
        "guardian_id": guardianId,
        "admission_number": admissionNumber,
        "roll_no": rollNo,
        "gender": gender,
        "photo": photo,
        "temporary_student": temporaryStudent,
        "class_section": classSection,
    };
}
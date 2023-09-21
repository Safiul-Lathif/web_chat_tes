class BirthdayList {
  String text;
  List<StudentList> studentList;

  BirthdayList({
    required this.text,
    required this.studentList,
  });

  factory BirthdayList.fromJson(Map<String, dynamic> json) => BirthdayList(
        text: json["text"],
        studentList: List<StudentList>.from(
            json["student_list"].map((x) => StudentList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "student_list": List<dynamic>.from(studentList.map((x) => x.toJson())),
      };
}

class StudentList {
  int id;
  String firstName;
  String classSection;
  String image;
  int sentStatus;

  StudentList({
    required this.id,
    required this.firstName,
    required this.classSection,
    required this.image,
    required this.sentStatus,
  });

  factory StudentList.fromJson(Map<String, dynamic> json) => StudentList(
        id: json["id"] ?? 0,
        firstName: json["first_name"] ?? '',
        classSection: json["class_section"] ?? '',
        image: json["image"] ?? '',
        sentStatus: json["sent_status"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "class_section": classSection,
        "image": image,
        "sent_status": sentStatus,
      };
}

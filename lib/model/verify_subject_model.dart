class VerifySubject {
    VerifySubject({
        required this.id,
        required this.subjectName,
        required this.isChecked,
    });

    int id;
    String subjectName;
    bool isChecked;

    factory VerifySubject.fromJson(Map<String, dynamic> json) => VerifySubject(
        id: json["id"],
        subjectName: json["subject_name"],
        isChecked: json["is_checked"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "subject_name": subjectName,
        "is_checked": isChecked,
    };
}
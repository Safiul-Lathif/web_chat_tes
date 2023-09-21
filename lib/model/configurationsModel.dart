class Configurations {
    Configurations({
        required this.configuration,
    });

    Configuration configuration;

    factory Configurations.fromJson(Map<String, dynamic> json) => Configurations(
        configuration: Configuration.fromJson(json["configuration"]),
    );

    Map<String, dynamic> toJson() => {
        "configuration": configuration.toJson(),
    };
}

class Configuration {
    Configuration({
        required this.classesSections,
        required this.subjects,
        required this.mapSubjects,
        required this.staffs,
        required this.mapStaffs,
        required this.management,
        required this.students,
        required this.mapStudents,
    });

    bool classesSections;
    bool subjects;
    bool mapSubjects;
    bool staffs;
    bool mapStaffs;
    bool management;
    bool students;
    bool mapStudents;

    factory Configuration.fromJson(Map<String, dynamic> json) => Configuration(
        classesSections: json["classes_sections"],
        subjects: json["subjects"],
        mapSubjects: json["map_subjects"],
        staffs: json["staffs"],
        mapStaffs: json["map_staffs"],
        management: json["management"],
        students: json["students"],
        mapStudents: json["map_students"],
    );

    Map<String, dynamic> toJson() => {
        "classes_sections": classesSections,
        "subjects": subjects,
        "map_subjects": mapSubjects,
        "staffs": staffs,
        "map_staffs": mapStaffs,
        "management": management,
        "students": students,
        "map_students": mapStudents,
    };
}

class ConfigList {
  Configuration configuration;
  Profile profile;

  ConfigList({
    required this.configuration,
    required this.profile,
  });

  factory ConfigList.fromJson(Map<String, dynamic> json) => ConfigList(
        configuration: Configuration.fromJson(json["configuration"]),
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "configuration": configuration.toJson(),
        "profile": profile.toJson(),
      };
}

class Configuration {
  bool classes;
  bool sections;
  bool mapClassesSections;
  bool subjects;
  bool mapSubjects;
  bool staffs;
  bool management;
  bool students;

  Configuration({
    required this.classes,
    required this.sections,
    required this.mapClassesSections,
    required this.subjects,
    required this.mapSubjects,
    required this.staffs,
    required this.management,
    required this.students,
  });

  factory Configuration.fromJson(Map<String, dynamic> json) => Configuration(
        classes: json["classes"],
        sections: json["sections"],
        mapClassesSections: json["map_classes_sections"],
        subjects: json["subjects"],
        mapSubjects: json["map_subjects"],
        staffs: json["staffs"],
        management: json["management"],
        students: json["students"],
      );

  Map<String, dynamic> toJson() => {
        "classes": classes,
        "sections": sections,
        "map_classes_sections": mapClassesSections,
        "subjects": subjects,
        "map_subjects": mapSubjects,
        "staffs": staffs,
        "management": management,
        "students": students,
      };
}

class Profile {
  int id;
  int schoolId;
  String schoolDbName;
  String schoolDbUser;
  String schoolDbPass;
  String schoolDbHost;
  int academicYear;
  DateTime createdOn;

  Profile({
    required this.id,
    required this.schoolId,
    required this.schoolDbName,
    required this.schoolDbUser,
    required this.schoolDbPass,
    required this.schoolDbHost,
    required this.academicYear,
    required this.createdOn,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        schoolId: json["school_id"],
        schoolDbName: json["school_db_name"],
        schoolDbUser: json["school_db_user"],
        schoolDbPass: json["school_db_pass"],
        schoolDbHost: json["school_db_host"],
        academicYear: json["academic_year"],
        createdOn: DateTime.parse(json["created_on"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "school_id": schoolId,
        "school_db_name": schoolDbName,
        "school_db_user": schoolDbUser,
        "school_db_pass": schoolDbPass,
        "school_db_host": schoolDbHost,
        "academic_year": academicYear,
        "created_on": createdOn.toIso8601String(),
      };
}

class ReviewClasssec {
    ReviewClasssec({
        required this.id,
        required this.classId,
        required this.className,
        required this.divisionId,
        required this.divisionName,
        required this.sections,
    });

    int id;
    int classId;
    String className;
    int divisionId;
    String divisionName;
    List<Section> sections;

    factory ReviewClasssec.fromJson(Map<String, dynamic> json) => ReviewClasssec(
        id: json["id"]??0,
        classId: json["class_id"]??0,
        className: json["class_name"]??"",
        divisionId: json["division_id"]??0,
        divisionName: json["division_name"]??"",
        sections: List<Section>.from(json["sections"].map((x) => Section.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "class_id": classId,
        "class_name": className,
        "division_id": divisionId,
        "division_name": divisionName,
        "sections": List<Section>.from(sections.map((x) => x.toJson())),
    };
}

class Section {
    Section({
        required this.sectionId,
        required this.sectionName,
    });

    int sectionId;
    String sectionName;

    factory Section.fromJson(Map<String, dynamic> json) => Section(
        sectionId: json["section_id"]??0,
        sectionName: json["section_name"]??"",
    );

    Map<String, dynamic> toJson() => {
        "section_id": sectionId,
        "section_name": sectionName,
    };
}

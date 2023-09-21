class SectionDetail {
    SectionDetail({
        required this.classSection,
        required this.id,
    });

    String classSection;
    int id;

    factory SectionDetail.fromJson(Map<String, dynamic> json) => SectionDetail(
        classSection: json["class_section"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "class_section": classSection,
        "id": id,
    };
}
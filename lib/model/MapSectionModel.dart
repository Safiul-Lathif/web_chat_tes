class SectionList {
  SectionList({
    this.sections,
  });

  List<Section>? sections;

  factory SectionList.fromJson(Map<String, dynamic> json) => SectionList(
        sections: json["sections"] == null
            ? []
            : List<Section>.from(
                json["sections"]!.map((x) => Section.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sections": sections == null
            ? []
            : List<dynamic>.from(sections!.map((x) => x.toJson())),
      };
}

class Section {
  Section({
    required this.id,
    required this.sectionName,
    required this.isclicked,
  });

  int id;
  String sectionName;
  bool isclicked;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        id: json["id"],
        sectionName: json["section_name"],
        isclicked: json["isclicked"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "section_name": sectionName,
        "isclicked": isclicked,
      };
}

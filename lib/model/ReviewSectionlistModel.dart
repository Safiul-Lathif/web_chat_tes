class ReviewSectionlist {
    ReviewSectionlist({
        required this.id,
        required this.sectionName,
        required this.isChecked,
    });

    int id;
    String sectionName;
    bool isChecked;

    factory ReviewSectionlist.fromJson(Map<String, dynamic> json) => ReviewSectionlist(
        id: json["id"],
        sectionName: json["section_name"],
        isChecked: json["is_checked"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "section_name": sectionName,
        "is_checked": isChecked,
    };
}

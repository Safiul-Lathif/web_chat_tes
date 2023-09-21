class CategoryList {
    CategoryList({
        required this.categories,
        required this.subjects,
        required this.classes,
        required this.sections,
    });

    List<Category> categories;
    List<Subject> subjects;
    List<Class_> classes;
    List<Section> sections;

    factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        subjects: List<Subject>.from(json["subjects"].map((x) => Subject.fromJson(x))),
        classes: List<Class_>.from(json["classes"].map((x) => Class_.fromJson(x))),
        sections: List<Section>.from(json["sections"].map((x) => Section.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "subjects": List<dynamic>.from(subjects.map((x) => x.toJson())),
        "classes": List<dynamic>.from(classes.map((x) => x.toJson())),
        "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
    };
}

class Category {
    Category({
        required this.id,
        required this.categoryName,
    });

    int id;
    String categoryName;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["category_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
    };
}

class Class_ {
    Class_({
        required this.id,
        required this.className,
    });

    int id;
    String className;

    factory Class_.fromJson(Map<String, dynamic> json) => Class_(
        id: json["id"],
        className: json["class_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "class_name": className,
    };
}

class Section {
    Section({
        required this.id,
        required this.sectionName,
    });

    int id;
    String sectionName;

    factory Section.fromJson(Map<String, dynamic> json) => Section(
        id: json["id"],
        sectionName: json["section_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "section_name": sectionName,
    };
}

class Subject {
    Subject({
        required this.id,
        required this.subjectName,
    });

    int id;
    String subjectName;

    factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json["id"],
        subjectName: json["subject_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "subject_name": subjectName,
    };
}

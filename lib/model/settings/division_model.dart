class DivisionList {
  DivisionList({
    required this.divisions,
  });

  List<Division> divisions;

  factory DivisionList.fromJson(Map<String, dynamic> json) => DivisionList(
        divisions: List<Division>.from(
            json["divisions"].map((x) => Division.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "divisions": List<dynamic>.from(divisions.map((x) => x.toJson())),
      };
}

class Division {
  Division({
    required this.id,
    required this.divisionName,
  });

  int id;
  String divisionName;

  factory Division.fromJson(Map<String, dynamic> json) => Division(
        id: json["id"],
        divisionName: json["division_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "division_name": divisionName,
      };
}

class MainGroupList {
  MainGroupList({
    required this.schoolName,
    required this.userRole,
    required this.groupList,
  });

  String schoolName;
  String userRole;
  List<GroupList> groupList;

  factory MainGroupList.fromJson(Map<String, dynamic> json) => MainGroupList(
        schoolName: json["school_name"],
        userRole: json["user_role"],
        groupList: List<GroupList>.from(
            json["group_list"].map((x) => GroupList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "school_name": schoolName,
        "user_role": userRole,
        "group_list": List<dynamic>.from(groupList.map((x) => x.toJson())),
      };
}

class GroupList {
  GroupList({
    required this.id,
    required this.groupName,
    this.groupDescription,
  });

  int id;
  String groupName;
  dynamic groupDescription;

  factory GroupList.fromJson(Map<String, dynamic> json) => GroupList(
        id: json["id"],
        groupName: json["group_name"],
        groupDescription: json["group_description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_name": groupName,
        "group_description": groupDescription,
      };
}

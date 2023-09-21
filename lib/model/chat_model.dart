class ChatPageModel {
  final String parentName;
  final String parentText;
  final String teacherName;
  final String teacherText;
  final String studentName;
  final String teacherClass;
  ChatPageModel({
    required this.parentName,
    required this.parentText,
    required this.teacherName,
    required this.teacherText,
    required this.studentName,
    required this.teacherClass,
  });

  static ChatPageModel fromJson(json) => ChatPageModel(
        parentName: json['parentName'],
        parentText: json['parentText'],
        teacherName: json['teacherName'],
        teacherText: json['teacherText'],
        teacherClass: json['teacherClass'],
        studentName: json['studentName'],
      );
}

List<ChatPageModel> getChatList() {
  const listofChat = [
    {
      'parentName': "Prakash",
      'parentText':
          "Respected madem , we wanted to report to you that our child requires special attention in food as he has been advised by doctor to have adequate time to eat .",
      'teacherName': "Aswin",
      'teacherClass': " Class teacher IV-A",
      'studentName': "F/O Lithikesh",
      'teacherText':
          "Respected sir we do note your request and we will process the request"
    },
    {
      'parentName': "Sudersan",
      'parentText':
          "We wanted to share with everyone that our child has got first place in Chess compedation",
      'teacherName': "Aswin",
      'teacherClass': " Class teacher IV-A",
      'studentName': "F/O Jebi",
      'teacherText': "Congrulations sir !!!"
    },
    {
      'parentName': "Praveena",
      'parentText': "Math problems are not clear for our daugther",
      'teacherName': "Ashok",
      'teacherClass': " Maths teacher IV-A",
      'studentName': "M/O Aishwarya",
      'teacherText':
          "Madem we will talk about this in the upcomming teachers meeting"
    },
    {
      'parentName': "Prakash",
      'parentText':
          "Respected madem , we wanted to report to you that our child requires special attention in food as he has been advised by doctor to have adequate time to eat .",
      'teacherName': "Aswin",
      'teacherClass': " Class teacher IV-A",
      'studentName': "F/O Linkadesh",
      'teacherText':
          "Respected sir we do note your request and we will process the request"
    },
    {
      'parentName': "Prakash",
      'parentText':
          "Respected madem , we wanted to report to you that our child requires special attention in food as he has been advised by doctor to have adequate time to eat .",
      'teacherName': "Aswin",
      'teacherClass': " Class teacher IV-A",
      'studentName': "F/O Lithikesh",
      'teacherText':
          "Respected sir we do note your request and we will process the request"
    },
  ];
  return listofChat.map<ChatPageModel>(ChatPageModel.fromJson).toList();
}

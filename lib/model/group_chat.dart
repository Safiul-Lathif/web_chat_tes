// ignore_for_file: file_names

class GroupChat {
  final String title;
  final String visibility;
  final String teacher;
  final String className;
  String subtitle;
  String imagelink;
  String type;
  GroupChat(
      {required this.title,
      required this.visibility,
      required this.teacher,
      required this.type,
      required this.className,
      required this.subtitle,
      required this.imagelink});

  static GroupChat fromJson(json) => GroupChat(
      type: json['type'],
      title: json['title'],
      visibility: json['visibility'],
      teacher: json['teacher'],
      subtitle: json['subtitle'],
      imagelink: json['imagelink'],
      className: json['className']);
}

List<GroupChat> getNews() {
  const newsFeed = [
    {
      "className": "F/O Lithikesh",
      "title":
          "Respected madem , we wanted to report to you that our child requires special attention in food as he has been advised by doctor to have adequate time to eat . ",
      "type": "messageCard",
      "visibility": "Visible only to praveena",
      "teacher": "Prakash",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school and every",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
    {
      "className": " Class teacher iV-A",
      "title":
          " Madem I will make note of this message and will get in touch with you ",
      "type": "text",
      "visibility": "Visible only to Prakash",
      "teacher": "Ashwin",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
    {
      "className": "M/O Roja",
      "title":
          "We wanted to share with everyone that our child has got first place in Chess compedation ",
      "type": "approvedCard",
      "visibility": "Visible only to You",
      "teacher": "Lavanya",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school and every",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
    {
      "className": "Class teacher iV-A",
      "title": " congratulations Mam!! ",
      "type": "2ndText",
      "visibility": "Visible to All",
      "teacher": "Ashwin ",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school and every",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
    {
      "className": "M/O Aishwrya",
      "title":
          " Madem I will make note of this message and will get in touch with you during parent teachhers meeting ",
      "type": "no-image",
      "visibility": "Deleted by Aswin Class teacher",
      "teacher": "Praveena",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
    {
      "className": "Class teacher iV-A",
      "title":
          " Madem this image is mot applicable for our school and acadeamics of the children , thus iam deleting your post  ",
      "type": "2ndText",
      "visibility": "Visible only to praveena",
      "teacher": "Ashwin ",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school and every",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
    {
      "className": "M/O Aishwrya",
      "title":
          " Madem I will make note of this message and will get in touch with you during parent teachhers meeting ",
      "type": "image",
      "visibility":
          "   Accepted by Aswin , Class Teacher Visible to whole class",
      "teacher": "Praveena  ",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
    {
      "className": "Class teacher iV-A",
      "title": "Thank you for sharing this wonderful pic , ma'am ",
      "type": "2ndText",
      "visibility": "Visible only to praveena",
      "teacher": "Ashwin ",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school and every",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
    {
      "className": "Class teacher iV-A",
      "title": "Thank you for sharing this wonderful pic , ma'am ",
      "type": "textfield",
      "visibility": "Visible only to praveena",
      "teacher": "Ashwin ",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school and every",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
    {
      "className": "Class teacher iV-A",
      "title": "Thank you for sharing this wonderful pic , ma'am ",
      "type": "audioVideo",
      "visibility": "Visible only to praveena",
      "teacher": "Ashwin ",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school and every",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
    {
      "className": "Class teacher iV-A",
      "title": "Thank you for sharing this wonderful pic , ma'am ",
      "type": "homeWork",
      "visibility": "Visible only to praveena",
      "teacher": "Ashwin ",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school and every",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
    {
      "className": "Class teacher iV-A",
      "title": "Thank you for sharing this wonderful pic , ma'am ",
      "type": "calender",
      "visibility": "Visible only to praveena",
      "teacher": "Ashwin ",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school and every",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
    {
      "className": "Class teacher iV-A",
      "title": "Thank you for sharing this wonderful pic , ma'am ",
      "type": "final",
      "visibility": "Visible only to praveena",
      "teacher": "Ashwin ",
      "subtitle":
          "A click of the school from entrance which shows the new board of the school and every",
      "imagelink":
          "https://media.istockphoto.com/id/182472346/photo/modern-high-school-entrance.jpg?s=612x612&w=0&k=20&c=P0dKl3uhbaWuHzuL5yI9pKb2Kgug9OBX8HYUfAVSjR0="
    },
  ];

  return newsFeed.map<GroupChat>(GroupChat.fromJson).toList();
}

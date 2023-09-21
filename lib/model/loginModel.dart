// class Login {
//     Login({
//         required this.token,
//         required this.loginstudentId,
//     });

//     String token;
//     int loginstudentId;

//     factory Login.fromJson(Map<String, dynamic> json) => Login(
//         token: json["token"],
//         loginstudentId: json["loginstudent_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "token": token,
//         "loginstudent_id": loginstudentId,
//     };
// }

class Login {
  Login({
    required this.token,
    required this.loginstudentId,
    required this.userid,
  });

  String token;
  int loginstudentId;
  String userid;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        token: json["token"],
        loginstudentId: json["loginstudent_id"],
        userid: json["userid"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "loginstudent_id": loginstudentId,
        "userid": userid,
      };
}

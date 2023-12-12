class Login {
  Login(
      {required this.token,
      required this.loginStudentId,
      required this.userId,
      this.status,
      this.error});

  String token;
  int loginStudentId;
  String userId;
  bool? status;
  String? error;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        token: json["token"],
        loginStudentId: json["loginstudent_id"],
        userId: json["userid"],
        status: json["status"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "loginstudent_id": loginStudentId,
        "userid": userId,
      };
}

class Users {
  final String userName;
  final String userPassword;

  Users({
    required this.userName,
    required this.userPassword,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        userName: json["userName"],
        userPassword: json["userPassword"],
      );

  Map<String, dynamic> toMap() => {
        "userName": userName,
        "userPassword": userPassword,
      };
}

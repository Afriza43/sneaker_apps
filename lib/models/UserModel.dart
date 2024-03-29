class Users {
  final String userName;
  final String fullName;
  final String phone;
  final String userPassword;
  final String gambar;

  Users(
      {required this.userName,
      required this.fullName,
      required this.phone,
      required this.userPassword,
      required this.gambar});

  factory Users.fromMap(Map<String, dynamic> json) => Users(
      userName: json["userName"],
      fullName: json["fullName"],
      phone: json["phone"],
      userPassword: json["userPassword"],
      gambar: json["gambar"]);

  Map<String, dynamic> toMap() => {
        "userName": userName,
        "fullName": fullName,
        "phone": phone,
        "userPassword": userPassword,
        "gambar": gambar,
      };
}

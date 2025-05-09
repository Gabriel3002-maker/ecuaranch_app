class Partner {
  final String name;
  final String email;
  final String phone;
  final String mobile;
  final String imageBase64;
  final String db;
  final int userId;
  final String password;

  Partner({
    required this.name,
    required this.email,
    required this.phone,
    required this.mobile,
    required this.imageBase64,
    required this.db,
    required this.userId,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "mobile": mobile,
      "image_1920": imageBase64,
      "db": db,
      "user_id": userId,
      "password": password,
    };
  }
}

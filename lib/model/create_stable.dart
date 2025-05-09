class StableData {
  final String db;
  final int userId;
  final String password;
  final String xName;
  final String xStudioDate;
  final int xStudioPartnerId;
  final String xStudioImage;

  StableData({
    required this.db,
    required this.userId,
    required this.password,
    required this.xName,
    required this.xStudioDate,
    required this.xStudioPartnerId,
    required this.xStudioImage,
  });

  Map<String, dynamic> toJson() {
    return {
      "db": db,
      "user_id": userId,
      "password": password,
      "x_name": xName,
      "x_studio_date": xStudioDate,
      "x_studio_partner_id": xStudioPartnerId,
      "x_studio_image": xStudioImage,
    };
  }
}

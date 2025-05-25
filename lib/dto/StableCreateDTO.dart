class Stable {
  final int id;
  final String displayName;
  final String name;
  final User? user;
  final String? image;

  Stable({
    required this.id,
    required this.displayName,
    required this.name,
    this.user,
    this.image,
  });

  factory Stable.fromJson(Map<String, dynamic> json) {
    User? user;
    if (json['x_studio_user_id'] != null && json['x_studio_user_id'] is List && json['x_studio_user_id'].length >= 2) {
      user = User(
        id: json['x_studio_user_id'][0],
        name: json['x_studio_user_id'][1],
      );
    }

    return Stable(
      id: json['id'],
      displayName: json['display_name'] ?? '',
      name: json['x_name'] ?? 'Sin nombre',
      user: user,
      image: json['x_studio_image'],
    );
  }

  @override
  String toString() => name;
}

class User {
  final int id;
  final String name;

  User({
    required this.id,
    required this.name,
  });
}

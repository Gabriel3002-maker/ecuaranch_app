class Person {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final dynamic image1024;

  Person({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.image1024,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      email: json['email'] is String ? json['email'] : null,
      phone: json['phone'] is String ? json['phone'] : null,
      image1024: json['image_1024'],
    );
  }
}

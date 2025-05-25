class Person {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final dynamic image1024;
  final List<dynamic>? partnerId; // sigue siendo dinámica

  Person({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.image1024,
    this.partnerId,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      email: json['email'] is String ? json['email'] : null,
      phone: json['phone'] is String ? json['phone'] : null,
      image1024: json['image_1024'],
      partnerId: json['partner_id'] is List ? json['partner_id'] : null,
    );
  }

  /// Método auxiliar para obtener solo el ID del partner
  int? get partnerIdValue {
    if (partnerId != null && partnerId!.isNotEmpty && partnerId![0] is int) {
      return partnerId![0];
    }
    return null;
  }
}

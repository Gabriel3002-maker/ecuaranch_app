class AnimalDTO {
  final int id;
  final String name;
  final String specie;
  final String? healthStatus;
  final DateTime? birthDate;
  final double? weight;

  AnimalDTO({
    required this.id,
    required this.name,
    required this.specie,
    this.healthStatus,
    this.birthDate,
    this.weight,
  });

  // Constructor para crear un AnimalDTO a partir de un JSON
  factory AnimalDTO.fromJson(Map<String, dynamic> json) {
    return AnimalDTO(
      id: json['id'],
      name: json['name'],
      specie: json['specie'],
      healthStatus: json['health_status'],
      birthDate: json['birth_date'] != null ? DateTime.parse(json['birth_date']) : null,
      weight: json['weight'] != null ? json['weight'].toDouble() : null,
    );
  }
}

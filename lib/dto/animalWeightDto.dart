class AnimalWeightDTO {
  final int? id;
  final int? animalId;
  final String? date;
  final double? weight;

  AnimalWeightDTO({
    this.id,
    this.animalId,
    this.date,
    this.weight,
  });

  factory AnimalWeightDTO.fromJson(Map<String, dynamic> json) {
    return AnimalWeightDTO(
      id: json['id'],
      animalId: json['animal_id'],
      date: json['date'],
      weight: json['weight'] != null ? json['weight'].toDouble() : null, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animal_id': animalId,
      'date': date,
      'weight': weight,
    };
  }
}

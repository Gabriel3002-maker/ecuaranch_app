import 'dart:convert';

class CreateGrowthWeightAnimalDTO {
  String db;
  int userId;
  String password;
  int xRegistrarAnimalId;
  String xStudioFecha;
  String xStudioAltura;
  String xName;

  // Constructor
  CreateGrowthWeightAnimalDTO({
    required this.db,
    required this.userId,
    required this.password,
    required this.xRegistrarAnimalId,
    required this.xStudioFecha,
    required this.xStudioAltura,
    required this.xName,
  });

  // Método para convertir a un mapa (Map) para su uso con APIs o almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'db': db,
      'user_id': userId,
      'password': password,
      'x_registrar_animal_id': xRegistrarAnimalId,
      'x_studio_fecha': xStudioFecha,
      'x_studio_altura': xStudioAltura,
      'x_name': xName,
    };
  }

  // Método para crear un DTO desde un mapa (útil para parsing de JSON)
  factory CreateGrowthWeightAnimalDTO.fromMap(Map<String, dynamic> map) {
    return CreateGrowthWeightAnimalDTO(
      db: map['db'],
      userId: map['user_id'],
      password: map['password'],
      xRegistrarAnimalId: map['x_registrar_animal_id'],
      xStudioFecha: map['x_studio_fecha'],
      xStudioAltura: map['x_studio_altura'],
      xName: map['x_name'],
    );
  }

  // Método para convertir el DTO a JSON (si necesitas trabajar con APIs)
  String toJson() {
    return json.encode(toMap());
  }

  // Método para crear un DTO desde JSON
  factory CreateGrowthWeightAnimalDTO.fromJson(String source) {
    return CreateGrowthWeightAnimalDTO.fromMap(json.decode(source));
  }
}

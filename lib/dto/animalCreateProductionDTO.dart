import 'dart:convert';

class ProductionDTO {
  String db;
  int userId;
  String password;
  int xRegistrarAnimalId;
  String xStudioFecha;
  int xStudioLitrosProducidos;
  String xName;

  // Constructor
  ProductionDTO({
    required this.db,
    required this.userId,
    required this.password,
    required this.xRegistrarAnimalId,
    required this.xStudioFecha,
    required this.xStudioLitrosProducidos,
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
      'x_studio_litros_producidos': xStudioLitrosProducidos,
      'x_name': xName,
    };
  }

  // Método para crear un DTO desde un mapa (útil para parsing de JSON)
  factory ProductionDTO.fromMap(Map<String, dynamic> map) {
    return ProductionDTO(
      db: map['db'],
      userId: map['user_id'],
      password: map['password'],
      xRegistrarAnimalId: map['x_registrar_animal_id'],
      xStudioFecha: map['x_studio_fecha'],
      xStudioLitrosProducidos: map['x_studio_litros_producidos'],
      xName: map['x_name'],
    );
  }

  // Método para convertir el DTO a JSON (si necesitas trabajar con APIs)
  String toJson() {
    return json.encode(toMap());
  }

  // Método para crear un DTO desde JSON
  factory ProductionDTO.fromJson(String source) {
    return ProductionDTO.fromMap(json.decode(source));
  }
}

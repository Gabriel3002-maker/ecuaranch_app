import 'dart:convert';

class AnimalObservationDTO {
  String db;
  int userId;
  String password;
  int xRegistrarAnimalId;
  String xStudioFecha1;
  String xName;

  // Constructor
  AnimalObservationDTO({
    required this.db,
    required this.userId,
    required this.password,
    required this.xRegistrarAnimalId,
    required this.xStudioFecha1,
    required this.xName,
  });

  // Método para convertir a un mapa (Map) para su uso con APIs o almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'db': db,
      'user_id': userId,
      'password': password,
      'x_registrar_animal_id': xRegistrarAnimalId,
      'x_studio_fecha_1': xStudioFecha1,
      'x_name': xName,
    };
  }

  // Método para crear un DTO desde un mapa (útil para parsing de JSON)
  factory AnimalObservationDTO.fromMap(Map<String, dynamic> map) {
    return AnimalObservationDTO(
      db: map['db'],
      userId: map['user_id'],
      password: map['password'],
      xRegistrarAnimalId: map['x_registrar_animal_id'],
      xStudioFecha1: map['x_studio_fecha_1'],
      xName: map['x_name'],
    );
  }

  // Método para convertir el DTO a JSON (si necesitas trabajar con APIs)
  String toJson() {
    return json.encode(toMap());
  }

  // Método para crear un DTO desde JSON
  factory AnimalObservationDTO.fromJson(String source) {
    return AnimalObservationDTO.fromMap(json.decode(source));
  }
}

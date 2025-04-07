import 'dart:convert';

class HealthMonitoringAnimalDTO {
  String db;
  int userId;
  String password;
  int xRegistrarAnimalId;
  String xStudioFecha;
  String xName;
  String xStudioEstadoDeSalud;

  // Constructor
  HealthMonitoringAnimalDTO({
    required this.db,
    required this.userId,
    required this.password,
    required this.xRegistrarAnimalId,
    required this.xStudioFecha,
    required this.xName,
    required this.xStudioEstadoDeSalud,
  });

  // Método para convertir a un mapa (Map) para su uso con APIs o almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'db': db,
      'user_id': userId,
      'password': password,
      'x_registrar_animal_id': xRegistrarAnimalId,
      'x_studio_fecha': xStudioFecha,
      'x_name': xName,
      'x_studio_estado_de_salud': xStudioEstadoDeSalud,
    };
  }

  // Método para crear un DTO desde un mapa (útil para parsing de JSON)
  factory HealthMonitoringAnimalDTO.fromMap(Map<String, dynamic> map) {
    return HealthMonitoringAnimalDTO(
      db: map['db'],
      userId: map['user_id'],
      password: map['password'],
      xRegistrarAnimalId: map['x_registrar_animal_id'],
      xStudioFecha: map['x_studio_fecha'],
      xName: map['x_name'],
      xStudioEstadoDeSalud: map['x_studio_estado_de_salud'],
    );
  }

  // Método para convertir el DTO a JSON (si necesitas trabajar con APIs)
  String toJson() {
    return json.encode(toMap());
  }

  // Método para crear un DTO desde JSON
  factory HealthMonitoringAnimalDTO.fromJson(String source) {
    return HealthMonitoringAnimalDTO.fromMap(json.decode(source));
  }
}

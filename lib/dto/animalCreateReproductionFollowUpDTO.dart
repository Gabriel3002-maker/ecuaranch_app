import 'dart:convert';

class CreateReproductionFollowUpDTO {
  String db;
  int userId;
  String password;
  int xRegistrarAnimalId;
  String xStudioFechaDeInicioDelCelo;
  String xStudioFechaDeInseminacion;
  String xStudioMetodoDeReproduccion;
  String xName;
  String xStudioConfirmacionDeEmbarazo1;
  String xStudioEmbarazoConfirmado;
  int xStudioNumeroDeCrasEsperadas;

  // Constructor
  CreateReproductionFollowUpDTO({
    required this.db,
    required this.userId,
    required this.password,
    required this.xRegistrarAnimalId,
    required this.xStudioFechaDeInicioDelCelo,
    required this.xStudioFechaDeInseminacion,
    required this.xStudioMetodoDeReproduccion,
    required this.xName,
    required this.xStudioConfirmacionDeEmbarazo1,
    required this.xStudioEmbarazoConfirmado,
    required this.xStudioNumeroDeCrasEsperadas,
  });

  // Método para convertir a un mapa (Map) para su uso con APIs o almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'db': db,
      'user_id': userId,
      'password': password,
      'x_registrar_animal_id': xRegistrarAnimalId,
      'x_studio_fecha_de_inicio_del_celo': xStudioFechaDeInicioDelCelo,
      'x_studio_fecha_de_inseminacin': xStudioFechaDeInseminacion,
      'x_studio_metodo_de_reproduccion': xStudioMetodoDeReproduccion,
      'x_name': xName,
      'x_studio_confirmacin_de_embarazo_1': xStudioConfirmacionDeEmbarazo1,
      'x_studio_embarazo_confirmado': xStudioEmbarazoConfirmado,
      'x_studio_nmero_de_cras_esperadas': xStudioNumeroDeCrasEsperadas,
    };
  }

  // Método para crear un DTO desde un mapa (útil para parsing de JSON)
  factory CreateReproductionFollowUpDTO.fromMap(Map<String, dynamic> map) {
    return CreateReproductionFollowUpDTO(
      db: map['db'],
      userId: map['user_id'],
      password: map['password'],
      xRegistrarAnimalId: map['x_registrar_animal_id'],
      xStudioFechaDeInicioDelCelo: map['x_studio_fecha_de_inicio_del_celo'],
      xStudioFechaDeInseminacion: map['x_studio_fecha_de_inseminacin'],
      xStudioMetodoDeReproduccion: map['x_studio_metodo_de_reproduccion'],
      xName: map['x_name'],
      xStudioConfirmacionDeEmbarazo1: map['x_studio_confirmacin_de_embarazo_1'],
      xStudioEmbarazoConfirmado: map['x_studio_embarazo_confirmado'],
      xStudioNumeroDeCrasEsperadas: map['x_studio_nmero_de_cras_esperadas'],
    );
  }

  // Método para convertir el DTO a JSON (si necesitas trabajar con APIs)
  String toJson() {
    return json.encode(toMap());
  }

  // Método para crear un DTO desde JSON
  factory CreateReproductionFollowUpDTO.fromJson(String source) {
    return CreateReproductionFollowUpDTO.fromMap(json.decode(source));
  }
}

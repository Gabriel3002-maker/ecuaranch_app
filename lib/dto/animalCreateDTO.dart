class AnimalDto {
  final String db;
  final int userId;
  final String password;
  final String xName;
  final String xStudioPartnerId;
  final String xStudioAlimentacionInicial1;
  final double xStudioPesoInicial;
  final String xStudioDateStart;
  final String xStudioGenero1;
  final String xStudioCharField18c1io38ib86;
  final String xStudioDestinadoA;
  final String xStudioEstadoDeSalud1;
  final String xStudioUserId;
  final double xStudioValue;
  final String xStudioImage;

  AnimalDto({
    required this.db,
    required this.userId,
    required this.password,
    required this.xName,
    required this.xStudioPartnerId,
    required this.xStudioAlimentacionInicial1,
    required this.xStudioPesoInicial,
    required this.xStudioDateStart,
    required this.xStudioGenero1,
    required this.xStudioCharField18c1io38ib86,
    required this.xStudioDestinadoA,
    required this.xStudioEstadoDeSalud1,
    required this.xStudioUserId,
    required this.xStudioValue,
    required this.xStudioImage
  });

  // Convertir un objeto AnimalDto a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      "db": db,
      "user_id": userId,
      "password": password,
      "x_name": xName,
      "x_studio_partner_id": xStudioPartnerId,
      "x_studio_alimentacion_inicial_1": xStudioAlimentacionInicial1,
      "x_studio_peso_inicial": xStudioPesoInicial,
      "x_studio_date_start": xStudioDateStart,
      "x_studio_genero_1": xStudioGenero1,
      "x_studio_char_field_18c_1io38ib86": xStudioCharField18c1io38ib86,
      "x_studio_destinado_a": xStudioDestinadoA,
      "x_studio_estado_de_salud_1": xStudioEstadoDeSalud1,
      "x_studio_user_id": xStudioUserId,
      "x_studio_value": xStudioValue,
      "x_studio_image": xStudioImage
    };
  }

  // Convertir un mapa JSON a un objeto AnimalDto
  factory AnimalDto.fromJson(Map<String, dynamic> json) {
    return AnimalDto(
      db: json['db'],
      userId: json['user_id'],
      password: json['password'],
      xName: json['x_name'],
      xStudioPartnerId: json['x_studio_partner_id'],
      xStudioAlimentacionInicial1: json['x_studio_alimentacion_inicial_1'],
      xStudioPesoInicial: json['x_studio_peso_inicial'],
      xStudioDateStart: json['x_studio_date_start'],
      xStudioGenero1: json['x_studio_genero_1'],
      xStudioCharField18c1io38ib86: json['x_studio_char_field_18c_1io38ib86'],
      xStudioDestinadoA: json['x_studio_destinado_a'],
      xStudioEstadoDeSalud1: json['x_studio_estado_de_salud_1'],
      xStudioUserId: json['x_studio_user_id'],
      xStudioValue: json['x_studio_value'],
      xStudioImage: json['x_studio_image']
    );
  }
}

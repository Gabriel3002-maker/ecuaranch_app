class AnimalPregnancyDTO {
  final int? id;
  final int? animalId;
  final String? pregnancyStatus;
  final String? inseminationDate;
  final String? expectedBirthDate;
  final String? postBirthHealthStatus;
  final String? causeOfDeath;
  final String? healthStatus;
  final String? fatherHealthStatus;
  final String? lactationStatus;
  final String? vetName;
  final String? vetVisitDate;
  final String? vetVisitNotes;
  final String? extraNotes;
  final int? numberOfOffspring;
  final int? numberOfDeadOffspring;
  final String? necropsyReport;
  final String? lastStatusChangeDate;
  final String? deathDate;
  final String? postBirthNotes;
  final int? fatherId;
  final List<String>? treatments;

  AnimalPregnancyDTO({
    this.id,
    this.animalId,
    this.pregnancyStatus,
    this.inseminationDate,
    this.expectedBirthDate,
    this.postBirthHealthStatus,
    this.causeOfDeath,
    this.healthStatus,
    this.fatherHealthStatus,
    this.lactationStatus,
    this.vetName,
    this.vetVisitDate,
    this.vetVisitNotes,
    this.extraNotes,
    this.numberOfOffspring,
    this.numberOfDeadOffspring,
    this.necropsyReport,
    this.lastStatusChangeDate,
    this.deathDate,
    this.postBirthNotes,
    this.fatherId,
    this.treatments,
  });

  // Factory constructor for creating an instance from a map (e.g., JSON)
  factory AnimalPregnancyDTO.fromJson(Map<String, dynamic> json) {
    return AnimalPregnancyDTO(
      id: json['id'],
      animalId: json['animal_id'],
      pregnancyStatus: json['pregnancy_status'],
      inseminationDate: json['insemination_date'],
      expectedBirthDate: json['expected_birth_date'],
      postBirthHealthStatus: json['post_birth_health_status'],
      causeOfDeath: json['cause_of_death'],
      healthStatus: json['healthStatus'],
      fatherHealthStatus: json['father_health_status'],
      lactationStatus: json['lactation_status'],
      vetName: json['vet_name'],
      vetVisitDate: json['vet_visit_date'],
      vetVisitNotes: json['vet_visit_notes'],
      extraNotes: json['extra_notes'],
      numberOfOffspring: json['number_of_offspring'],
      numberOfDeadOffspring: json['number_of_dead_offspring'],
      necropsyReport: json['necropsy_report'],
      lastStatusChangeDate: json['last_status_change_date'],
      deathDate: json['death_date'],
      postBirthNotes: json['post_birth_notes'],
      fatherId: json['father_id'],
      treatments: json['treatments'] != null
          ? List<String>.from(json['treatments'])
          : [],
    );
  }

  // Convert the object back to a map (for sending data)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animal_id': animalId,
      'pregnancy_status': pregnancyStatus,
      'insemination_date': inseminationDate,
      'expected_birth_date': expectedBirthDate,
      'post_birth_health_status': postBirthHealthStatus,
      'cause_of_death': causeOfDeath,
      'healthStatus':healthStatus,
      'father_health_status': fatherHealthStatus,
      'lactation_status': lactationStatus,
      'vet_name': vetName,
      'vet_visit_date': vetVisitDate,
      'vet_visit_notes': vetVisitNotes,
      'extra_notes': extraNotes,
      'number_of_offspring': numberOfOffspring,
      'number_of_dead_offspring': numberOfDeadOffspring,
      'necropsy_report': necropsyReport,
      'last_status_change_date': lastStatusChangeDate,
      'death_date': deathDate,
      'post_birth_notes': postBirthNotes,
      'father_id': fatherId,
      'treatments': treatments,
    };
  }
}

class Nota {
  final int? id;
  final int estudianteId;
  final String asignatura;
  final double nota;
  final String fecha;

  Nota({
    this.id,
    required this.estudianteId,
    required this.asignatura,
    required this.nota,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'estudiante_id': estudianteId,
      'asignatura': asignatura,
      'nota': nota,
      'fecha': fecha,
    };
  }
}

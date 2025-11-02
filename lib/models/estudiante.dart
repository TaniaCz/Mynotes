class Estudiante {
  final int? id;
  final String nombre;
  final String correo;
  final String grado;

  Estudiante({this.id, required this.nombre, required this.correo, required this.grado});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'grado': grado,
    };
  }
}

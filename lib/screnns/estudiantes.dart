import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class EstudiantesScreen extends StatefulWidget {
  final String rolUsuario; // 'admin' o 'profesor'

  const EstudiantesScreen({super.key, required this.rolUsuario});

  @override
  State<EstudiantesScreen> createState() => _EstudiantesScreenState();
}

class _EstudiantesScreenState extends State<EstudiantesScreen> {
  final db = DBHelper();
  final nombreCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final gradoCtrl = TextEditingController();

  List<Map<String, dynamic>> estudiantes = [];
  int? estudianteEditando; // null si se está creando

  @override
  void initState() {
    super.initState();
    cargarEstudiantes();
  }

  // 🔹 Cargar estudiantes
  Future<void> cargarEstudiantes() async {
    final data = await db.getEstudiantes();
    setState(() => estudiantes = data);
  }

  // 🔹 Registrar o actualizar estudiante
  Future<void> guardarEstudiante() async {
    if (nombreCtrl.text.isEmpty || correoCtrl.text.isEmpty || gradoCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (estudianteEditando == null) {
      // Agregar nuevo
      await db.insertEstudiante({
        'nombre': nombreCtrl.text,
        'correo': correoCtrl.text,
        'grado': gradoCtrl.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estudiante registrado correctamente')),
      );
    } else {
      // Actualizar existente
      await db.updateEstudiante(estudianteEditando!, {
        'nombre': nombreCtrl.text,
        'correo': correoCtrl.text,
        'grado': gradoCtrl.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estudiante actualizado correctamente')),
      );
      estudianteEditando = null;
    }

    nombreCtrl.clear();
    correoCtrl.clear();
    gradoCtrl.clear();
    cargarEstudiantes();
  }

  // 🔹 Eliminar estudiante (solo admin)
  Future<void> eliminarEstudiante(int id) async {
    await db.deleteEstudiante(id);
    cargarEstudiantes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Estudiante eliminado')),
    );
  }

  // 🔹 Editar estudiante (solo admin)
  void editarEstudiante(Map<String, dynamic> estudiante) {
    setState(() {
      estudianteEditando = estudiante['id'];
      nombreCtrl.text = estudiante['nombre'];
      correoCtrl.text = estudiante['correo'];
      gradoCtrl.text = estudiante['grado'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final esAdmin = widget.rolUsuario == 'admin';

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Estudiantes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Formulario (visible para admin y profesor)
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Estudiante',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: correoCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Correo del Estudiante',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: gradoCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Grado',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: Text(estudianteEditando == null
                          ? 'Registrar Estudiante'
                          : 'Actualizar Estudiante'),
                      onPressed: guardarEstudiante,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Listado de Estudiantes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            // 🔹 Lista de estudiantes
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: estudiantes.length,
              itemBuilder: (context, index) {
                final est = estudiantes[index];
                return Card(
                  child: ListTile(
                    title: Text('${est['nombre']} — ${est['grado']}'),
                    subtitle: Text('Correo: ${est['correo']}'),
                    trailing: esAdmin
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                onPressed: () => editarEstudiante(est),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => eliminarEstudiante(est['id']),
                              ),
                            ],
                          )
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

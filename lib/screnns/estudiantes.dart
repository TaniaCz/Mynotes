import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class EstudiantesScreen extends StatefulWidget {
  const EstudiantesScreen({super.key});

  @override
  State<EstudiantesScreen> createState() => _EstudiantesScreenState();
}

class _EstudiantesScreenState extends State<EstudiantesScreen> {
  final db = DBHelper();
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  List<Map<String, dynamic>> estudiantes = [];

  @override
  void initState() {
    super.initState();
    cargarEstudiantes();
  }

  Future<void> cargarEstudiantes() async {
    final data = await db.getEstudiantes();
    setState(() => estudiantes = data);
  }

  Future<void> agregarEstudiante() async {
    if (nombreCtrl.text.isEmpty || emailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    await db.insertEstudiante({
      'nombre': nombreCtrl.text,
      'email': emailCtrl.text,
    });

    nombreCtrl.clear();
    emailCtrl.clear();
    cargarEstudiantes();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Estudiante agregado correctamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> eliminarEstudiante(int id) async {
    await db.deleteEstudiante(id);
    cargarEstudiantes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Estudiante eliminado'), backgroundColor: Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Estudiantes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
                    TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Correo')),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text('Agregar Estudiante'),
                      onPressed: agregarEstudiante,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Listado de Estudiantes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: estudiantes.length,
              itemBuilder: (context, index) {
                final e = estudiantes[index];
                return Card(
                  child: ListTile(
                    title: Text(e['nombre']),
                    subtitle: Text(e['email']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => eliminarEstudiante(e['id']),
                    ),
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

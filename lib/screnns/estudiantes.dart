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
  final correoCtrl = TextEditingController();
  final gradoCtrl = TextEditingController();
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
    await db.insertEstudiante({
      'nombre': nombreCtrl.text,
      'correo': correoCtrl.text,
      'grado': gradoCtrl.text,
    });
    nombreCtrl.clear();
    correoCtrl.clear();
    gradoCtrl.clear();
    cargarEstudiantes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Estudiantes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
                TextField(controller: correoCtrl, decoration: const InputDecoration(labelText: 'Correo')),
                TextField(controller: gradoCtrl, decoration: const InputDecoration(labelText: 'Grado')),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: agregarEstudiante, child: const Text('Agregar')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: estudiantes.length,
              itemBuilder: (context, index) {
                final e = estudiantes[index];
                return ListTile(
                  title: Text(e['nombre']),
                  subtitle: Text('${e['correo']} - ${e['grado']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

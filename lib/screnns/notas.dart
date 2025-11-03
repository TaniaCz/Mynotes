import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class NotasScreen extends StatefulWidget {
  const NotasScreen({super.key});

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  final db = DBHelper();
  final asignaturaCtrl = TextEditingController();
  final notaCtrl = TextEditingController();
  final estudianteIdCtrl = TextEditingController();
  List<Map<String, dynamic>> notas = [];

  @override
  void initState() {
    super.initState();
    cargarNotas();
  }

  Future<void> cargarNotas() async {
    final data = await db.getNotasConEstudiante();
    setState(() => notas = data);
  }

  Future<void> agregarNota() async {
    final estudianteId = int.tryParse(estudianteIdCtrl.text);
    final nota = double.tryParse(notaCtrl.text);

    if (estudianteId == null || asignaturaCtrl.text.isEmpty || nota == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos correctamente'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    await db.insertNota({
      'estudiante_id': estudianteId,
      'asignatura': asignaturaCtrl.text,
      'nota': nota,
      'fecha': DateTime.now().toString(),
    });

    asignaturaCtrl.clear();
    notaCtrl.clear();
    estudianteIdCtrl.clear();
    cargarNotas();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nota registrada correctamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> eliminarNota(int id) async {
    await db.deleteNota(id);
    cargarNotas();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nota eliminada'), backgroundColor: Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Notas')),
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
                    TextField(controller: estudianteIdCtrl, decoration: const InputDecoration(labelText: 'ID Estudiante')),
                    TextField(controller: asignaturaCtrl, decoration: const InputDecoration(labelText: 'Asignatura')),
                    TextField(controller: notaCtrl, decoration: const InputDecoration(labelText: 'Nota')),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar Nota'),
                      onPressed: agregarNota,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Listado de Notas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notas.length,
              itemBuilder: (context, index) {
                final n = notas[index];
                return Card(
                  child: ListTile(
                    title: Text('${n['asignatura']} — ${n['estudiante_nombre'] ?? 'Sin estudiante'}'),
                    subtitle: Text('Nota: ${n['nota']} — Fecha: ${n['fecha']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => eliminarNota(n['id']),
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

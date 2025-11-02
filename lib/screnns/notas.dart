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
    final data = await db.getNotas();
    setState(() => notas = data);
  }

  Future<void> agregarNota() async {
    await db.insertNota({
      'estudiante_id': int.tryParse(estudianteIdCtrl.text),
      'asignatura': asignaturaCtrl.text,
      'nota': double.tryParse(notaCtrl.text),
      'fecha': DateTime.now().toString(),
    });
    asignaturaCtrl.clear();
    notaCtrl.clear();
    estudianteIdCtrl.clear();
    cargarNotas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Notas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(controller: estudianteIdCtrl, decoration: const InputDecoration(labelText: 'ID Estudiante')),
                TextField(controller: asignaturaCtrl, decoration: const InputDecoration(labelText: 'Asignatura')),
                TextField(controller: notaCtrl, decoration: const InputDecoration(labelText: 'Nota')),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: agregarNota, child: const Text('Guardar Nota')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notas.length,
              itemBuilder: (context, index) {
                final n = notas[index];
                return ListTile(
                  title: Text(n['asignatura']),
                  subtitle: Text('Nota: ${n['nota']} — Fecha: ${n['fecha']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

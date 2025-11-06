import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class NotasScreen extends StatefulWidget {
  final String rolUsuario; 

  const NotasScreen({super.key, required this.rolUsuario});

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  final db = DBHelper();
  final asignaturaCtrl = TextEditingController();
  final notaCtrl = TextEditingController();

  List<Map<String, dynamic>> notas = [];
  List<Map<String, dynamic>> estudiantes = [];
  int? estudianteSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarNotas();
    cargarEstudiantes();
  }

  
  Future<void> cargarNotas() async {
    final data = await db.getNotasConEstudiante();
    setState(() => notas = data);
  }

  Future<void> cargarEstudiantes() async {
    final data = await db.getEstudiantes();
    setState(() => estudiantes = data);
  }

  // Agregar una nueva nota
  Future<void> agregarNota() async {
    if (estudianteSeleccionado == null ||
        asignaturaCtrl.text.isEmpty ||
        notaCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    await db.insertNota({
      'estudiante_id': estudianteSeleccionado,
      'asignatura': asignaturaCtrl.text,
      'nota': double.tryParse(notaCtrl.text),
      'fecha': DateTime.now().toString(),
    });

    asignaturaCtrl.clear();
    notaCtrl.clear();
    estudianteSeleccionado = null;
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
      const SnackBar(
        content: Text('Nota eliminada'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esAdmin = widget.rolUsuario == 'admin';

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Notas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Card(
              elevation: 3,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      value: estudianteSeleccionado,
                      items: estudiantes.map((est) {
                        return DropdownMenuItem<int>(
                          value: est['id'],
                          child: Text('${est['nombre']} — ${est['grado']}'),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Selecciona un Estudiante',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (valor) {
                        setState(() => estudianteSeleccionado = valor);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: asignaturaCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Asignatura',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notaCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nota',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
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

            const Text(
              'Listado de Notas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notas.length,
              itemBuilder: (context, index) {
                final n = notas[index];
                return Card(
                  child: ListTile(
                    title: Text('${n['asignatura']} — Nota: ${n['nota']}'),
                    subtitle: Text(
                      'Estudiante: ${n['estudiante']} — Grado: ${n['grado']}\nFecha: ${n['fecha']}',
                    ),
                    trailing: esAdmin
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => eliminarNota(n['id']),
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

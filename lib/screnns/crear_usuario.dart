  import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class CrearUsuarioScreen extends StatefulWidget {
  const CrearUsuarioScreen({super.key});

  @override
  State<CrearUsuarioScreen> createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends State<CrearUsuarioScreen> {
  final db = DBHelper();
  final nombreCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final contrasenaCtrl = TextEditingController();

  Future<void> crearUsuario() async {
    await db.insertarUsuario({
      'nombre': nombreCtrl.text,
      'correo': correoCtrl.text,
      'contrasena': contrasenaCtrl.text,
      'rol': 'profesor',
    });

    nombreCtrl.clear();
    correoCtrl.clear();
    contrasenaCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profesor creado con éxito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Profesor')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: correoCtrl, decoration: const InputDecoration(labelText: 'Correo')),
            TextField(controller: contrasenaCtrl, decoration: const InputDecoration(labelText: 'Contraseña')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: crearUsuario, child: const Text('Crear Usuario')),
          ],
        ),
      ),
    );
  }
}

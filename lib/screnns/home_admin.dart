import 'package:flutter/material.dart';
import 'estudiantes.dart';
import 'notas.dart';
import 'crear_usuario.dart';
import 'login.dart';

class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
     const rolUsuario = 'admin';
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Administrador')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Gestionar Estudiantes'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute( builder: (_) => EstudiantesScreen(rolUsuario: rolUsuario),));
              },
            ),
            ElevatedButton(
              child: const Text('Registrar Notas'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute( builder: (_) => NotasScreen(rolUsuario: rolUsuario),));
              },
            ),
            ElevatedButton(
              child: const Text('Crear Usuario (Profesor)'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CrearUsuarioScreen()));
              },
            ),
            ElevatedButton(
              child: const Text('Cerrar Sesión'),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'notas.dart';
import 'login.dart';

class HomeProfesorScreen extends StatelessWidget {
  const HomeProfesorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Profesor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Registrar Notas'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotasScreen()));
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

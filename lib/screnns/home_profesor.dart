import 'package:flutter/material.dart';
import 'notas.dart';
import 'login.dart';

class HomeProfesorScreen extends StatelessWidget {
  const HomeProfesorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rolUsuario = 'profesor';
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B0082),
        title: const Text('Panel Profesor'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.school_rounded,
                    color: Color(0xFF4B0082),
                    size: 60,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Panel del Profesor',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B0082),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón para registrar notas
                  _buildProfesorButton(
                    icon: Icons.assignment_rounded,
                    text: 'Registrar Notas',
                    color: Colors.blueAccent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotasScreen(rolUsuario: rolUsuario),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // Botón para cerrar sesión
                  _buildProfesorButton(
                    icon: Icons.logout_rounded,
                    text: 'Cerrar Sesión',
                    color: Colors.redAccent,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfesorButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 26),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

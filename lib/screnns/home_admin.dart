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
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B0082),
        title: const Text('Panel Administrador'),
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
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Gestión del Sistema',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B0082),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón 1
                  _buildAdminButton(
                    icon: Icons.people_alt_rounded,
                    text: 'Gestionar Estudiantes',
                    color: Colors.blueAccent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EstudiantesScreen(rolUsuario: rolUsuario),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // Botón 2
                  _buildAdminButton(
                    icon: Icons.assignment_rounded,
                    text: 'Registrar Notas',
                    color: Colors.green,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              NotasScreen(rolUsuario: rolUsuario),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // Botón 3
                  _buildAdminButton(
                    icon: Icons.person_add_alt_1_rounded,
                    text: 'Crear Usuario (Profesor)',
                    color: Colors.orangeAccent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CrearUsuarioScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // Botón 4
                  _buildAdminButton(
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

  Widget _buildAdminButton({
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

import 'package:flutter/material.dart';

class EditarUsuario extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const EditarUsuario({super.key, required this.usuario});

  @override
  State<EditarUsuario> createState() => _EditarUsuarioState();
}

class _EditarUsuarioState extends State<EditarUsuario> {
  
  final TextEditingController contrasenaController = TextEditingController();
  String? rolSeleccionado;

  void EditarUsuario() async {
    final contrasena = contrasenaController.text.trim();
    final rol = rolSeleccionado;

    if (contrasena.isEmpty && rol == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    } else if (contrasena.isNotEmpty && contrasena.length > 6) {
      usuario.
      return;
    } else if (rol == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, seleccione un rol')),
      );
      return;
    }

  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double titleSize = screenWidth * 0.04;
    final double backIconSize = screenWidth * 0.025;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.01,
          ),
          child: Column(
            children: [
              // CABECERA
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        iconSize: backIconSize, // Tamaño del ícono de la flecha
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'EDITAR USUARIO', // Título con tamaño dinámico
                            style: TextStyle(
                              fontSize: titleSize, // Tamaño del título
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: backIconSize), // Espacio a la derecha del ícono
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04), // más espacio

                  const Text('Contraseña'),
                  TextField(
                    controller: contrasenaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Contraseña del Usuario',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[300], // Color gris claro de fondo
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

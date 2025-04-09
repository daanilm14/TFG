import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Usuario.dart'; // Asegúrate de importar tu clase Usuario

class CrearUsuario extends StatefulWidget {
  const CrearUsuario({super.key});

  @override
  State<CrearUsuario> createState() => _CrearUsuarioState();
}

class _CrearUsuarioState extends State<CrearUsuario> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  String? rolSeleccionado;

  final List<String> roles = ['administrador', 'usuario'];

  void crearUsuario() async {
    final nombre = nombreController.text.trim();
    final email = correoController.text.trim();
    final passwd = contrasenaController.text.trim();
    final rol = rolSeleccionado;

    if (nombre.isEmpty || email.isEmpty || passwd.isEmpty || rol == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    Usuario usuario = Usuario(nombre: nombre, email: email, passwd: passwd);
    await usuario.addUsuario(nombre, email, passwd, rol);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario creado con éxito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Definir los tamaños dinámicos para el ícono y el texto
    final double iconSize = screenWidth * 0.03;
    final double fontSize = screenWidth * 0.025;
    final double titleSize = screenWidth * 0.04;
    final double backIconSize = screenWidth * 0.025;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), // Para más espacio en los laterales
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CABECERA
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
                          'ALTA DE USUARIO', // Título con tamaño dinámico
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
                SizedBox(height: screenHeight * 0.04), // Espacio debajo del título

                const Text('Nombre'),
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    hintText: 'Nombre del Usuario',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[300], // Color gris claro de fondo
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Correo'),
                TextField(
                  controller: correoController,
                  decoration: InputDecoration(
                    hintText: 'Correo del Usuario',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[300], // Color gris claro de fondo
                  ),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                const Text('ROL'),
                DropdownButtonFormField<String>(
                  value: rolSeleccionado,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[300], // Color gris claro de fondo
                  ),
                  hint: const Text('Rol del Usuario'),
                  onChanged: (value) {
                    setState(() {
                      rolSeleccionado = value;
                    });
                  },
                  items: roles.map((rol) {
                    return DropdownMenuItem(
                      value: rol,
                      child: Text(rol),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: crearUsuario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Ajustado al tamaño del texto
                    ),
                    child: const Text(
                      'Crear',
                      style: TextStyle(
                        fontSize: 18, // Reducido el tamaño del texto del botón
                        color: Colors.white, // Texto blanco
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Para espaciar más abajo
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'EditarUsuario.dart';
import 'Usuario.dart'; // Aquí debe estar getUsuarios()

class ListaUsuarios extends StatelessWidget {

  final Usuario usuario;
  const ListaUsuarios({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double iconRadius = screenWidth * 0.03;
    final double iconSize = screenWidth * 0.03;
    final double fontSize = screenWidth * 0.025;
    final double titleSize = screenWidth * 0.04;
    final double backIconSize = screenWidth * 0.025;

    Widget buildButton(String label, IconData icon, Widget screen) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            },
            child: CircleAvatar(
              radius: iconRadius,
              backgroundColor: Colors.grey.shade300,
              child: Icon(icon, size: iconSize, color: Colors.black),
            ),
          ),
          SizedBox(height: screenHeight * 0.005), // menos espacio entre ícono y texto
          Text(label, style: TextStyle(fontSize: fontSize), textAlign: TextAlign.center),
        ],
      );
    }

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
                          'LISTA DE USUARIOS', // Título con tamaño dinámico
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
                ],
              ),
              // CONTENIDO
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>( // Aquí se cargan los usuarios
                  future: usuario.getUsuarios(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No hay usuarios disponibles."));
                    }

                    final usuarios = snapshot.data!;

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: usuarios.length,
                      itemBuilder: (context, index) {
                        final usuario = usuarios[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(usuario['nombre']),
                            subtitle: Text(usuario['rol']),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditarUsuario(usuario: usuario),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

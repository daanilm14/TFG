import 'package:flutter/material.dart';
import 'EditarUsuario.dart';
import 'Usuario.dart';


// Clase que representa la pantalla de lista de usuarios.
// Muestra una lista de usuarios registrados en el sistema.
// Permite editar los detalles de cada usuario.
class ListaUsuarios extends StatefulWidget {
  final Usuario usuario;      // Usuario actual que ha iniciado sesión
  const ListaUsuarios({super.key, required this.usuario});  // Constructor que recibe el usuario actual

  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  late Future<List<Map<String, dynamic>>> futureUsuarios; // Variable para almacenar la lista de usuarios

  @override
  void initState() {
    super.initState();
    futureUsuarios = cargarUsuarios();    // Cargar la lista de usuarios al iniciar el estado
  }

  Future<List<Map<String, dynamic>>> cargarUsuarios() async { // Método para cargar la lista de usuarios desde la base de datos
    final usuarios = await widget.usuario.getUsuarios();    // Obtener la lista de usuarios del objeto Usuario
    return usuarios.map((u) => {
      'uid': u.uid,
      'nombre': u.nombre,
      'email': u.email,
      'rol': u.rol,
    }).toList();  
  }

  // Método para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;    // Obtener el ancho de la pantalla
    final screenHeight = MediaQuery.of(context).size.height;  // Obtener la altura de la pantalla

    final double titleSize = screenWidth * 0.04;        // Tamaño del título
    final double backIconSize = screenWidth * 0.025;    // Tamaño del icono de retroceso

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
                        iconSize: backIconSize,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'LISTA DE USUARIOS',
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: backIconSize),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                ],
              ),

              // Lista de Usuarios
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: futureUsuarios,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No hay usuarios disponibles."));
                    }

                    final usuarios = snapshot.data!;

                    return ListView.builder(              // Construir la lista de usuarios
                      padding: const EdgeInsets.all(16),
                      itemCount: usuarios.length,
                      itemBuilder: (context, index) {
                        final usuarioMap = usuarios[index];

                        Usuario usuario = Usuario(        // Crear un objeto Usuario a partir del Map
                          uid: usuarioMap['uid'],
                          nombre: usuarioMap['nombre'],
                          email: usuarioMap['email'],
                          rol: usuarioMap['rol'],
                        );
                        
                        // Construir cada tarjeta de usuario
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(usuario.nombre),
                            subtitle: Text(usuario.rol),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(   // Navegar a la pantalla de edición de usuario
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditarUsuario(usuario: usuario),
                                  ),
                                );
                                setState(() {     // Actualizar la lista de usuarios después de editar
                                  futureUsuarios = cargarUsuarios();
                                });
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

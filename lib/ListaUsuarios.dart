import 'package:flutter/material.dart';
import 'EditarUsuario.dart';
import 'Usuario.dart';

class ListaUsuarios extends StatefulWidget {
  final Usuario usuario;
  const ListaUsuarios({super.key, required this.usuario});

  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  late Future<List<Map<String, dynamic>>> futureUsuarios;

  @override
  void initState() {
    super.initState();
    futureUsuarios = cargarUsuarios();
  }

  Future<List<Map<String, dynamic>>> cargarUsuarios() async {
    final usuarios = await widget.usuario.getUsuarios();
    return usuarios.map((u) => {
      'uid': u.uid,
      'nombre': u.nombre,
      'email': u.email,
      'rol': u.rol,
    }).toList();
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

              // CONTENIDO
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

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: usuarios.length,
                      itemBuilder: (context, index) {
                        final usuarioMap = usuarios[index];

                        Usuario usuario = Usuario(
                          uid: usuarioMap['uid'],
                          nombre: usuarioMap['nombre'],
                          email: usuarioMap['email'],
                          rol: usuarioMap['rol'],
                        );

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
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditarUsuario(usuario: usuario),
                                  ),
                                );
                                setState(() {
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

import 'package:flutter/material.dart';
import 'package:tfg/Usuario.dart';

class EditarUsuario extends StatefulWidget {
  final Usuario usuario;
  const EditarUsuario({super.key, required this.usuario});

  @override
  State<EditarUsuario> createState() => _EditarUsuarioState();
}

class _EditarUsuarioState extends State<EditarUsuario> {
  final List<String> roles = ['administrador', 'usuario'];
  final TextEditingController contrasenaController = TextEditingController();
  late String rolSeleccionado;

  @override
  void initState() {
    super.initState();
    rolSeleccionado = widget.usuario.rol; // Inicializar con el rol actual
  }

  // Método para editar el usuario
  // Se actualiza la contraseña y el rol del usuario en la base de datos.
  // Se muestra un mensaje de éxito o error según corresponda.
  void editarUsuario() async {
    final contrasena = contrasenaController.text.trim();
    final rol = rolSeleccionado;

    if (contrasena.isEmpty && rol == widget.usuario.rol) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay cambios para guardar')),
      );
      return;
    }

    if (contrasena.isNotEmpty && contrasena.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres')),
      );
      return;
    }

    try {
      if (contrasena.isNotEmpty && contrasena.length >= 6) {
        await widget.usuario.updatePassword(contrasena);
      }

      if (rol != widget.usuario.rol) {
        await widget.usuario.updateRol(widget.usuario.uid, rol);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cambios guardados correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  // Método para eliminar el usuario
  // Se elimina el usuario de la base de datos y se vuelve a la pantalla anterior.
  // Se muestra un mensaje de éxito o error según corresponda.
  void borrarUsuario() async {
    try {
      await widget.usuario.deleteUsuario(widget.usuario.uid); // Eliminar el usuario de la base de datos
      ScaffoldMessenger.of(context).showSnackBar(                         // Mostrar mensaje de éxito
        const SnackBar(content: Text('Usuario eliminado correctamente')),
      );
      Navigator.pop(context); // Volver atrás después de eliminar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  // Interfaz de usuario
  // Se utiliza un diseño responsivo para adaptarse a diferentes tamaños de pantalla.
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;        // Ancho de la pantalla
    final screenHeight = MediaQuery.of(context).size.height;      // Alto de la pantalla  

    final double titleSize = screenWidth * 0.04;                  // Tamaño del título  
    final double backIconSize = screenWidth * 0.025;              // Tamaño del ícono de la flecha de retroceso 

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
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'EDITAR USUARIO',
                                style: TextStyle(
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.usuario.nombre,
                                style: TextStyle(
                                  fontSize: titleSize * 0.8,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: backIconSize),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // CAMPO CONTRASEÑA
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Contraseña',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    controller: contrasenaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Nueva Contraseña del Usuario',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[300],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CAMPO ROL
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'ROL',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: rolSeleccionado,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[300],
                    ),
                    onChanged: (value) {
                      setState(() {
                        rolSeleccionado = value!;
                      });
                    },
                    items: roles.map((rol) {
                      return DropdownMenuItem(
                        value: rol,
                        child: Text(rol),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 50), // Espacio extra antes de los botones

                  // BOTONES GUARDAR Y BORRAR
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: editarUsuario,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                          child: const Text(
                            'Guardar',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: borrarUsuario,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                          child: const Text(
                            'Borrar Usuario',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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

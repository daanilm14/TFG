import 'package:flutter/material.dart';
import 'Usuario.dart'; 

// Clase para crear un nuevo usuario
// Esta pantalla permite ingresar los datos del usuario y enviarlos a la base de datos
// Se utiliza un formulario con campos de texto y un botón para enviar los datos
class CrearUsuario extends StatefulWidget {
  const CrearUsuario({super.key});

  @override
  State<CrearUsuario> createState() => _CrearUsuarioState();
}

class _CrearUsuarioState extends State<CrearUsuario> {
  final TextEditingController nombreController = TextEditingController();       // Controlador para el campo de nombre
  final TextEditingController correoController = TextEditingController();       // Controlador para el campo de correo 
  final TextEditingController contrasenaController = TextEditingController();   // Controlador para el campo de contraseña
  String? rolSeleccionado;  // Variable para almacenar el rol seleccionado

  final List<String> roles = ['administrador', 'usuario'];  // Lista de roles disponibles

  // Método para crear un nuevo usuario
  // Valida que los campos no estén vacíos y luego crea un objeto Usuario
  // Finalmente, envía los datos a la base de datos y muestra un mensaje de éxito
  void crearUsuario() async {
    final nombre = nombreController.text.trim();      // Obtiene el nombre del usuario 
    final email = correoController.text.trim();       // Obtiene el correo del usuario
    final passwd = contrasenaController.text.trim();  // Obtiene la contraseña del usuario
    final rol = rolSeleccionado;                      // Obtiene el rol seleccionado

    if (nombre.isEmpty || email.isEmpty || passwd.isEmpty || rol == null) {     // Verifica que todos los campos estén completos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),  // Muestra un mensaje de error si algún campo está vacío
      );
      return;
    }

    Usuario usuario = Usuario(uid: '',nombre: nombre, email: email, rol: rol);  // Crea un nuevo objeto Usuario con los datos ingresados
    await usuario.addUsuario(nombre, email, passwd, rol);                       // Envía los datos del usuario a la base de datos   
  

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario creado con éxito')),          // Muestra un mensaje de éxito al crear el usuario
    );

    Navigator.pop(context); // Cierra la pantalla actual y regresa a la anterior
  } 

  // Método para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;      // Obtiene el ancho de la pantalla
    final screenHeight = MediaQuery.of(context).size.height;    // Obtiene la altura de la pantalla

    final double titleSize = screenWidth * 0.04;                // Tamaño del título dinámico basado en el ancho de la pantalla
    final double backIconSize = screenWidth * 0.025;            // Tamaño del ícono de la flecha dinámico basado en el ancho de la pantalla

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), 
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CABECERA
                Row(
                  children: [
                    IconButton(
                      iconSize: backIconSize, 
                      icon: const Icon(Icons.arrow_back), // Ícono de flecha hacia atrás
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'ALTA DE USUARIO', // Título 
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
                // FORMULARIO
                const Text('Nombre'),
                TextField(    // Campo de texto para ingresar el nombre del usuario
                  controller: nombreController, 
                  decoration: InputDecoration(  
                    hintText: 'Nombre del Usuario',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[300], 
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Correo'),
                TextField(    // Campo de texto para ingresar el correo del usuario
                  controller: correoController,
                  decoration: InputDecoration(
                    hintText: 'Correo del Usuario',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[300], 
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Contraseña'),
                TextField(    // Campo de texto para ingresar la contraseña del usuario
                  controller: contrasenaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Contraseña del Usuario',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('ROL'),
                DropdownButtonFormField<String>(  // Campo desplegable para seleccionar el rol del usuario
                  value: rolSeleccionado,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[300], 
                  ),
                  hint: const Text('Rol del Usuario'),
                  onChanged: (value) {
                    setState(() {
                      rolSeleccionado = value;
                    });
                  },
                  items: roles.map((rol) {
                    return DropdownMenuItem(    // Crea un elemento del menú desplegable para cada rol
                      value: rol,
                      child: Text(rol),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(    // Botón para crear el usuario
                    onPressed: crearUsuario,    // Llama al método crearUsuario al presionar el botón
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), 
                    ),
                    child: const Text(  
                      'Crear',  // Texto del botón
                      style: TextStyle(
                        fontSize: 18, 
                        color: Colors.white, 
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Usuario.dart';  // Importamos la clase Usuario
import 'firebase_options.dart';
import 'HomeAdmin.dart'; // Importamos la pantalla de inicio de administrador
import 'HomeUser.dart'; // Importamos la pantalla de inicio de usuario

// Clase principal de la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized();    // Asegura que los bindings de Flutter estén inicializados
    await Firebase.initializeApp(               // Inicializa Firebase con las opciones predeterminadas
    options: DefaultFirebaseOptions.currentPlatform,  
  );
  runApp(MyApp());    // Ejecuta la aplicación
}

// Clase MyApp que define la estructura principal de la aplicación
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  // Método build que construye la interfaz de usuario
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Espacios',   // Título de la aplicación
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),      // Pantalla de inicio de sesión
    );
  }
}

// Clase LoginScreen que representa la pantalla de inicio de sesión
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();      // Controlador para el campo de correo electrónico
  final TextEditingController passwordController = TextEditingController();   // Controlador para el campo de contraseña
  String mensajeError = ''; // Variable para almacenar mensajes de error

  // Método para iniciar sesión
  Future<void> iniciarSesion() async {
    String email = emailController.text.trim();           // Obtener el correo electrónico del controlador
    String password = passwordController.text.trim();     // Obtener la contraseña del controlador

    Usuario usuario = Usuario(uid: '',nombre: '',email: email, rol:'');       // Crear una instancia de Usuario con el correo electrónico
    Map<String, dynamic>? datosUsuario = await usuario.loginUsuario(password);    // Iniciar sesión y obtener los datos del usuario

    if (datosUsuario != null) { // Si se obtienen datos del usuario
      String rol = datosUsuario['rol']; // Obtener el rol

      // Redirigir según el rol del usuario
      if (rol == "administrador") { // Si es administrador
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeAdmin(usuario: usuario)), // Redirigir a la pantalla de inicio de administrador
        );
      } else {  // Si es usuario normal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeUser(usuario: usuario)),  // Redirigir a la pantalla de inicio de usuario
        );
      }
    } else {
      setState(() { // Si no se obtienen datos, mostrar mensaje de error
        mensajeError = "Credenciales incorrectas o usuario no encontrado.";
      });
    }
  }

  // Método para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    // Obtener dimensiones de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;    // Ancho de la pantalla
    final screenHeight = MediaQuery.of(context).size.height;  // Alto de la pantalla

    // Ancho de los campos de texto.
    final campoAncho = screenWidth * 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView( // para evitar desbordes en pantallas pequeñas
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono superior
              CircleAvatar(
                radius: screenHeight * 0.08, // 8% de alto pantalla
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.close, size: screenHeight * 0.06, color: Colors.black),
              ),
              SizedBox(height: screenHeight * 0.05),

                // Texto y campo de correo
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  "Correo electrónico",
                  style: TextStyle(fontSize: screenHeight * 0.02, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  _buildTextField(emailController, "Introduce Correo Electrónico", campoAncho),
                ],
                ),

                SizedBox(height: screenHeight * 0.02),

                // Texto y campo de contraseña
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  "Contraseña",
                  style: TextStyle(fontSize: screenHeight * 0.02, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  _buildTextField(passwordController, "Introduce Contraseña", campoAncho, isPassword: true),
                ],
                ),

                SizedBox(height: screenHeight * 0.04),

              // Botón
              SizedBox(
                width: campoAncho * 0.1,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: iniciarSesion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.022),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
              if (mensajeError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    mensajeError,
                    style: TextStyle(color: Colors.red, fontSize: screenHeight * 0.018),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir un campo de texto. 
  Widget _buildTextField(TextEditingController controller, String hintText, double width,
      {bool isPassword = false}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        ),
      ),
    );
  }
}


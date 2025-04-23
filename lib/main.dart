import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Usuario.dart';  // Importamos la clase Usuario
import 'firebase_options.dart';
import 'HomeAdmin.dart'; // Importamos la pantalla de inicio de administrador
import 'HomeUser.dart'; // Importamos la pantalla de inicio de usuario



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Espacios',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String mensajeError = '';

  Future<void> iniciarSesion() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    Usuario usuario = Usuario(uid: '',nombre: '',email: email, rol:'');
    Map<String, dynamic>? datosUsuario = await usuario.loginUsuario(password);
    print(datosUsuario); // Imprimir los datos del usuario para depuración

    if (datosUsuario != null) {
      String rol = datosUsuario['rol']; // Obtener el rol

      // Redirigir según el rol del usuario
      if (rol == "administrador") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeAdmin(usuario: usuario)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeUser(usuario: usuario)),
        );
      }
    } else {
      setState(() {
        mensajeError = "Credenciales incorrectas o usuario no encontrado.";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // Obtener dimensiones de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Ancho de los campos de texto (70% del ancho de pantalla)
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


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pantalla Principal")),
      body: Center(child: Text("Bienvenido a la aplicación")),
    );
  }
}


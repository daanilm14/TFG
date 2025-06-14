import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

// Clase para definir las opciones de Firebase
// en la plataforma actual. Estas opciones son necesarias para inicializar Firebase.
class DefaultFirebaseOptions {
  static  FirebaseOptions get currentPlatform {   // Obtiene las opciones de Firebase para la plataforma actual
    return const FirebaseOptions(
      apiKey: "AIzaSyD0Yx2Ho0LJE8PDihLmwfM1QFROJjKRjNU",    // Clave API de Firebase
      authDomain: "gestor-espacios.firebaseapp.com",        // Dominio de autenticación de Firebase
      projectId: "gestor-espacios",                         // ID del proyecto de Firebase
      storageBucket: "gestor-espacios.firebasestorage.app", // Bucket de almacenamiento de Firebase
      messagingSenderId: "151103119264",                    // ID del remitente de mensajes de Firebase
      appId: "1:151103119264:web:92a4be3000ab6ef65b8ec5",   // ID de la aplicación de Firebase
    );
  }
}
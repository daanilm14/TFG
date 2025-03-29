import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static  FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyD0Yx2Ho0LJE8PDihLmwfM1QFROJjKRjNU",
      authDomain: "gestor-espacios.firebaseapp.com",
      projectId: "gestor-espacios",
      storageBucket: "gestor-espacios.firebasestorage.app",
      messagingSenderId: "151103119264",
      appId: "1:151103119264:web:92a4be3000ab6ef65b8ec5",
    );
  }
}
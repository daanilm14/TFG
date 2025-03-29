import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Usuario{
  // Atributos
  String nombre;
  String email;
  String passwd;
  String rol;

  // Constructor
  Usuario({required this.nombre, required this.email, required this.passwd, required this.rol,});

  // Método para registrar un nuevo usuario en la base de datos.
  Future<void> addUsuario(String nombre, String email, String passwd, String rol) async {
    try {
      // 1 Registrar usuario en Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: passwd,
      );

      String uid = userCredential.user!.uid; // Obtener UID de Firebase Auth

      // 2️ Guardar datos del usuario en Firestore (sin la contraseña)
      await FirebaseFirestore.instance.collection('Usuarios').doc(uid).set({
        'uid': uid,  
        'nombre': nombre,
        'email': email,
        'rol': rol,
      });

      print('Usuario registrado correctamente');
    } catch (e) {
      print('Error añadiendo usuario: $e');
    }
  }

  // Método para eliminar un usuario de la base de datos.
  Future<void> deleteUsuario(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(querySnapshot.docs.first.id)
            .delete();
      } else {
        print('Usuario no encontrado con el email proporcionado.');
      }
    } catch (e) {
      print('Error eliminando usuario: $e');
    }
  }

  // Método para modificar el Nombre de un usuario en la base de datos.
  Future<void> updateNombre(String email, String nuevoNombre) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(querySnapshot.docs.first.id)
            .update({'nombre': nuevoNombre});
      } else {
        print('Usuario no encontrado con el email proporcionado.');
      }
    } catch (e) {
      print('Error actualizando nombre de usuario: $e');
    }
  }

  // Método para modificar el rol de un usuario en la base de datos.
  Future<void> updateRol(String email, String nuevoRol) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(querySnapshot.docs.first.id)
            .update({'rol': nuevoRol});
      } else {
        print('Usuario no encontrado con el email proporcionado.');
      }
    } catch (e) {
      print('Error actualizando rol de usuario: $e');
    }
  }



}
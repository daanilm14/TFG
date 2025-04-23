import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Usuario{
  // Atributos
  String uid;
  String nombre;
  String email;
  String rol;

  // Método para crear un Usuario desde un Map
  factory Usuario.fromMap(Map<String, dynamic> map, String uid) {
    return Usuario(
      uid: map['uid'] ?? '',
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      rol: map['rol'] ?? ''
    );
  }

  // Constructor
  Usuario({required this.uid, required this.nombre, required this.email, required this.rol});

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
        'nombre': nombre,
        'email': email,
        'rol': rol,
      });

      print('Usuario registrado correctamente');
    } catch (e) {
      print('Error añadiendo usuario: $e');
    }
  }

  // Método para obtener todos los usuarios de la base de datos.
  Future<List<Usuario>> getUsuarios() async {
    List<Usuario> listaUsuarios = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Usuarios').get();

      // Si no hay documentos en la colección
      if (querySnapshot.docs.isEmpty) {
        print('No se encontraron usuarios.');
        return listaUsuarios;
      }

      // Procesar documentos de la colección
      for (var doc in querySnapshot.docs) {
        Usuario usuario = Usuario.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        listaUsuarios.add(usuario);
      }

    } catch (e) {
      print('Error obteniendo usuarios: $e');
      // Si ocurre un error, retorna una lista vacía
      return [];
    }

    return listaUsuarios;
  }

  // Método para iniciar sesión de un usuario en la base de datos.
  Future<Map<String, dynamic>?> loginUsuario(String passwd) async {
    try {
      // 1️⃣ Iniciar sesión en Firebase Auth
      UserCredential credencial = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwd,
      );

      uid = credencial.user!.uid;

      // 2️⃣ Buscar en Firestore el usuario con ese UID
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Usuarios').doc(uid).get();

      if (doc.exists) {
        Map<String, dynamic> datosUsuario = doc.data() as Map<String, dynamic>;
        nombre = datosUsuario['nombre'];  // Obtener el nombre
        rol = datosUsuario['rol'];  // Obtener el rol
        print("Usuario encontrado en Firestore: ${datosUsuario}");

        return {
          "nombre": nombre,
          "uid": uid,
          "email": email,
          "rol": rol,
        };
      } else {
        print("Usuario no encontrado en Firestore.");
        return null;
      }
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return null;
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
  Future<void> updateRol(String uid, String nuevoRol) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .where('uid', isEqualTo: uid)
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

  // Método para actualizar la contraseña del usuario actualmente autenticado
  Future<void> updatePassword(String nuevaPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(nuevaPassword);
        print('Contraseña actualizada correctamente.');
      } else {
        print('No hay usuario autenticado actualmente.');
      }
    } catch (e) {
      print(' Error actualizando la contraseña: $e');
    }
  }



}
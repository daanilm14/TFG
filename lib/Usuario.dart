import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Clase que representa un usuario del sistema.
// Contiene los datos básicos de identificación y el rol asignado.
// Proporciona métodos para la gestión de usuarios en Firebase Authentication y la base de datos.
class Usuario{

  // Atributos
  String uid;       // Identificador único del usuario en Firebase Authentication
  String nombre;    // Nombre del usuario
  String email;     // Correo electrónico del usuario
  String rol;       // Rol del usuario (por ejemplo, 'admin', 'usuario', etc.)



  // Constructor
  Usuario({required this.uid, required this.nombre, required this.email, required this.rol});

  // Registra un nuevo usuario en Firebase Authentication y la base de datos.
  //
  // Entradas:
  // - [nombre]: Nombre del usuario.
  // - [email]: Correo electrónico.
  // - [passwd]: Contraseña.
  // - [rol]: Rol del usuario (admin o usuario normal).
  //
  Future<void> addUsuario(String nombre, String email, String passwd, String rol) async {
    try {
      // 1 Registrar usuario en Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: passwd,
      );

      String uid = userCredential.user!.uid; // Obtener UID de Firebase Auth

      // 2️ Guardar datos del usuario en la base de datos.
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

  // Elimina un usuario de la colección 'Usuarios' en la base de datos.
  //
  // Entradas:
  // - [uid]: Identificador del usuario.
  //
  // Nota: No elimina el usuario de Firebase Authentication por limitaciones del plan gratuito.
  //
  Future<void> deleteUsuario(String uid) async {
    try {
      // Eliminar el usuario de Firestore
      await FirebaseFirestore.instance.collection('Usuarios').doc(uid).delete();
      print('Usuario eliminado de Firestore');
    } catch (e) {
      print('Error eliminando usuario: $e');
    }
  }



  // Obtiene la lista de todos los usuarios almacenados en la base de datos.
  //
  // Entradas: Ninguna.
  //
  // Salida: Lista de objetos `Usuario`.
  //
  Future<List<Usuario>> getUsuarios() async {
    List<Usuario> listaUsuarios = [];   // Lista para almacenar los usuarios obtenidos

    try {
      // Obtener todos los documentos de la colección 'Usuarios'
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Usuarios').get();

      // Si no hay documentos en la colección
      if (querySnapshot.docs.isEmpty) {
        print('No se encontraron usuarios.');
        return listaUsuarios;
      }

      // Procesar documentos de la colección
      for (var doc in querySnapshot.docs) {
        Usuario usuario = Usuario.fromMap(doc.data() as Map<String, dynamic>, doc.id);  // Crear un objeto Usuario a partir del Map
        usuario.uid = doc.id;  // Asignar el UID del documento al objeto Usuario
        listaUsuarios.add(usuario); // Añadir el usuario a la lista
      }

    } catch (e) {
      print('Error obteniendo usuarios: $e');
      // Si ocurre un error, retorna una lista vacía
      return [];
    }

    return listaUsuarios;
  }

  // Inicia sesión en Firebase Authentication y recupera el usuario desde la base de datos.
  //
  // Entradas:
  // - [passwd]: Contraseña del usuario.
  //
  // Salida: Mapa con los datos del usuario o null si no se encuentra.
  //
  Future<Map<String, dynamic>?> loginUsuario(String passwd) async {
    try {
      // Iniciar sesión en Firebase Auth
      UserCredential credencial = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwd,
      );
      
      uid = credencial.user!.uid; // Obtener el UID del usuario autenticado

      // Buscar en Firestore el usuario con ese UID
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Usuarios').doc(uid).get();


      if (doc.exists) { // Verificar si el documento existe
        Map<String, dynamic> datosUsuario = doc.data() as Map<String, dynamic>; // Obtener los datos del usuario
        nombre = datosUsuario['nombre'];  // Obtener el nombre
        rol = datosUsuario['rol'];  // Obtener el rol
        return {                    // Retornar un mapa con los datos del usuario
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


  // Actualiza el rol de la instancia de un usuario en la base de datos.
  //
  // Entradas:
  // - [uid]: Identificador único del usuario.
  // - [nuevoRol]: Nuevo rol a asignar ('admin' o 'usuario').
  //
  Future<void> updateRol(String uid, String nuevoRol) async {
    try {
      // Verificar si el usuario existe en Firestore
      final querySnapshot = await FirebaseFirestore.instance  
          .collection('Usuarios')
          .where('uid', isEqualTo: uid)
          .get();
      // Si se encuentra al menos un documento, actualizar el rol
      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance        // Acceder a la colección 'Usuarios'
            .collection('Usuarios')
            .doc(querySnapshot.docs.first.id) 
            .update({'rol': nuevoRol});         // Actualizar el rol del usuario
      } else {
        print('Usuario no encontrado con el email proporcionado.');
      }
    } catch (e) {
      print('Error actualizando rol de usuario: $e');
    }
  }

  // Actualiza la contraseña del usuario actualmente autenticado.
  //
  // Entradas:
  // - [nuevaPassword]: Nueva contraseña a asignar.
  //
  Future<void> updatePassword(String nuevaPassword) async {
    try {
      // Obtener el usuario actualmente autenticado
      User? user = FirebaseAuth.instance.currentUser;

      // Si hay un usuario autenticado, actualizar la contraseña
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

  // Método estático que devuelve el nombre de un usuario dado su UID.
  //
  // Entradas:
  // - [uid]: Identificador del usuario.
  //
  static Future<String> getNombre(String uid) async {
    try {
      // Buscar el documento del usuario en la colección 'Usuarios'
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Usuarios').doc(uid).get();

      // Si el documento existe, extraer el nombre
      if (doc.exists) {
        Map<String, dynamic> datosUsuario = doc.data() as Map<String, dynamic>;
        return datosUsuario['nombre'];
      } else {
        print("Usuario no encontrado en Firestore.");
        return '';
      }
    } catch (e) {
      print("Error al obtener el nombre del usuario: $e");
      return '';
    }
  }

  // Método que crea una instancia de Usuario a partir de un Map (Firestore).
  // 
  // Entradas:
  // - [map]: Mapa de datos del usuario.
  // - [uid]: Identificador único del usuario.
  // 
  factory Usuario.fromMap(Map<String, dynamic> map, String uid) {
    return Usuario(
      uid: map['uid'] ?? '',
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      rol: map['rol'] ?? ''
    );
  }
}
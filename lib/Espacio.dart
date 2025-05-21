import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Espacio{
  // Atributos.
  String? id_espacio;
  String nombre; 
  int capacidad;
  TimeOfDay horarioIni;
  TimeOfDay horarioFin;
  String descripcion;

  // Constructor.
  Espacio({this.id_espacio, required this.nombre, required this.capacidad, required this.horarioIni, required this.horarioFin, required this.descripcion});

  // Método para agregar un espacio a la base de datos.
  Future<void> addEspacio(String nombre, int capacidad, TimeOfDay horarioIni, TimeOfDay horarioFin, String descripcion) async {
    try {
      await FirebaseFirestore.instance.collection('Espacios').add({
        'nombre': nombre,
        'capacidad': capacidad,
        'horarioIni': '${horarioIni.hour.toString().padLeft(2, '0')}:${horarioIni.minute.toString().padLeft(2, '0')}',
        'horarioFin': '${horarioFin.hour.toString().padLeft(2, '0')}:${horarioFin.minute.toString().padLeft(2, '0')}',
        'descripcion': descripcion,
      });
      print('Espacio añadido correctamente');
    } catch (e) {
      print('Error añadiendo espacio: $e');
    }
  }

  // Método para eliminar un espacio de la base de datos.
  Future<void> deleteEspacio(String nombre) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Espacios')
            .doc(querySnapshot.docs.first.id)
            .delete();
      } else {
        print('Espacio no encontrado con el nombre proporcionado.');
      }
    } catch (e) {
      print('Error eliminando espacio: $e');
    }
  }

  //Método para modificar el nombre de un espacio en la base de datos.
 Future<bool> updateNombre(String nombre, String nuevoNombre) async {
  try {
    // Verificar si ya existe un espacio con el nuevo nombre
    final existingQuerySnapshot = await FirebaseFirestore.instance
        .collection('Espacios')
        .where('nombre', isEqualTo: nuevoNombre)
        .get();

    if (existingQuerySnapshot.docs.isNotEmpty) {
      print('Ya existe un espacio con el nuevo nombre proporcionado.');
      return false; // No realizar cambios si el nombre está repetido
    }

    // Buscar el espacio con el nombre actual
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Espacios')
        .where('nombre', isEqualTo: nombre)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Espacios')
          .doc(querySnapshot.docs.first.id)
          .update({'nombre': nuevoNombre});
      return true; // Actualización exitosa
    } else {
      print('Espacio no encontrado con el nombre proporcionado.');
      return false;
    }
  } catch (e) {
    print('Error actualizando nombre de espacio: $e');
    return false;
  }
}


  // Método para modificar la capacidad de un espacio en la base de datos.
  Future<void> updateCapacidad(String nombre, int nuevaCapacidad) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Espacios')
            .doc(querySnapshot.docs.first.id)
            .update({'capacidad': nuevaCapacidad});
      } else {
        print('Espacio no encontrado con el nombre proporcionado.');
      }
    } catch (e) {
      print('Error actualizando capacidad de espacio: $e');
    }
  }

  // Método para modificar el horario inicial de un espacio en la base de datos.
  Future<void> updateHorarioIni(String nombre, TimeOfDay nuevoHorarioIni) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Espacios')
            .doc(querySnapshot.docs.first.id)
            .update({
          'horarioIni': '${nuevoHorarioIni.hour.toString().padLeft(2, '0')}:${nuevoHorarioIni.minute.toString().padLeft(2, '0')}',
        });
      } else {
        print('Espacio no encontrado con el nombre proporcionado.');
      }
    } catch (e) {
      print('Error actualizando horario inicial de espacio: $e');
    }
  }

  // Método para modificar el horario final de un espacio en la base de datos.
  Future<void> updateHorarioFin(String nombre, TimeOfDay nuevoHorarioFin) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Espacios')
            .doc(querySnapshot.docs.first.id)
            .update({
          'horarioFin': '${nuevoHorarioFin.hour.toString().padLeft(2, '0')}:${nuevoHorarioFin.minute.toString().padLeft(2, '0')}',
        });
      } else {
        print('Espacio no encontrado con el nombre proporcionado.');
      }
    } catch (e) {
      print('Error actualizando horario final de espacio: $e');
    }
  }

  // Método para modificar la descripción de un espacio en la base de datos.
  Future<void> updateDescripcion(String nombre, String nuevaDescripcion) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Espacios')
            .doc(querySnapshot.docs.first.id)
            .update({'descripcion': nuevaDescripcion});
      } else {
        print('Espacio no encontrado con el nombre proporcionado.');
      }
    } catch (e) {
      print('Error actualizando descripción de espacio: $e');
    }
  }


  static Future<List<Espacio>> getEspacios() async {
    List<Espacio> espacios = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Espacios').get();

      if (querySnapshot.docs.isEmpty) {
        print('No hay espacios disponibles.');
        return espacios;
      }

      for (var doc in querySnapshot.docs) {
        espacios.add(Espacio(
          id_espacio: doc.id,
          nombre: doc['nombre'],
          capacidad: doc['capacidad'],
          horarioIni: _parseHora(doc['horarioIni']),
          horarioFin: _parseHora(doc['horarioFin']),
          descripcion: doc['descripcion'],
        ));
      }
    } catch (e) {
      print('Error obteniendo espacios: $e');
    }
    return espacios;
  }

  // Función auxiliar para convertir String "HH:mm" a TimeOfDay
  static TimeOfDay _parseHora(String horaStr) {
    final parts = horaStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }


  // Obtener un espacio por nombre
 static Future<Espacio?> getEspacioPorNombre(String nombre) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        return Espacio(
          nombre: doc['nombre'],
          capacidad: doc['capacidad'],
          horarioIni: _parseHora(doc['horarioIni']),
          horarioFin: _parseHora(doc['horarioFin']),
          descripcion: doc['descripcion'],
        );
      } else {
        print('Espacio no encontrado con el nombre proporcionado.');
        return null;
      }
    } catch (e) {
      print('Error obteniendo espacio por nombre: $e');
      return null;
    }
  }

  // Obtener espacio por ID (documentId)
  static Future<Espacio?> getEspacioPorId(String docId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('Espacios').doc(docId).get();

      if (doc.exists) {
        var data = doc.data()!;
        return Espacio(
          nombre: data['nombre'],
          capacidad: data['capacidad'],
          horarioIni: _parseHora(data['horarioIni']),
          horarioFin: _parseHora(data['horarioFin']),
          descripcion: data['descripcion'],
        );
      } else {
        print('Espacio no encontrado con el id proporcionado.');
        return null;
      }
    } catch (e) {
      print('Error obteniendo espacio por ID: $e');
      return null;
    }
  }

  // Verificar si un espacio existe por nombre
  static Future<bool> existeEspacioConNombre(String nombre) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error verificando existencia de espacio: $e');
      return false;
    }
  }

  static Future<String> getNombre(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Espacios').doc(uid).get();

      if (doc.exists) {
        Map<String, dynamic> datosEspacio = doc.data() as Map<String, dynamic>;
        return datosEspacio['nombre'];
      } else {
        print("Espacios no encontrado en Firestore.");
        return '';
      }
    } catch (e) {
      print("Error al obtener el nombre del espacio: $e");
      return '';
    }
  }


}


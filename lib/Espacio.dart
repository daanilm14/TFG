import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Espacio{
  // Atributos.
  String nombre; 
  int capacidad;
  TimeOfDay horarioIni;
  TimeOfDay horarioFin;
  String descripcion;

  // Constructor.
  Espacio({required this.nombre, required this.capacidad, required this.horarioIni, required this.horarioFin, required this.descripcion});

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


  Future<List<Espacio>> getEspacios() async {
    List<Espacio> espacios = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Espacios').get();

      if (querySnapshot.docs.isEmpty) {
        print('No hay espacios disponibles.');
        return espacios;
      }

      for (var doc in querySnapshot.docs) {
        espacios.add(Espacio(
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

}


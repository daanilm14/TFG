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

  // Método para modificar el horario de un espacio en la base de datos.
  Future<void> updateHorario(String nombre, String nuevoHorarioIni, String nuevoHorarioFin) async {
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
          'horarioIni': nuevoHorarioIni,
          'horarioFin': nuevoHorarioFin,
        });
      } else {
        print('Espacio no encontrado con el nombre proporcionado.');
      }
    } catch (e) {
      print('Error actualizando horario de espacio: $e');
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


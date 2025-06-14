import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Clase que representa un espacio físico del sistema (aula, laboratorio...).
// Contiene atributos como nombre, capacidad, horarios de uso y descripción.
// Incluye métodos para gestionar los espacios en la base de datos.
class Espacio{
  // Atributos.
  String? id_espacio;     // Identificador único del espacio en Firestore (opcional, puede ser null al crear un nuevo espacio).
  String nombre;          // Nombre del espacio (aula, laboratorio...).
  int capacidad;          // Capacidad máxima del espacio (número de personas que puede albergar).
  TimeOfDay horarioIni;   // Hora de inicio de disponibilidad del espacio (formato TimeOfDay).
  TimeOfDay horarioFin;   // Hora de fin de disponibilidad del espacio (formato TimeOfDay).
  String descripcion;     // Descripción del espacio (detalles adicionales, características...).

  // Constructor.
  Espacio({this.id_espacio, required this.nombre, required this.capacidad, required this.horarioIni, required this.horarioFin, required this.descripcion});

  // Agrega un nuevo espacio a la colección 'Espacios' en la base de datos.
  //
  // Entradas:
  // - [nombre]: Nombre del espacio.
  // - [capacidad]: Capacidad numérica.
  // - [horarioIni]: Hora de inicio de disponibilidad.
  // - [horarioFin]: Hora de fin de disponibilidad.
  // - [descripcion]: Texto descriptivo del espacio.
  //
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

  // Elimina un espacio de la base de datos a partir de su nombre.
  //
  // Entradas:
  // - [nombre]: Nombre del espacio a eliminar.
  //
  Future<void> deleteEspacio(String nombre) async {
    try {
      // Buscar el espacio por nombre
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();
      // Si se encuentra al menos un espacio con ese nombre, eliminar el primero
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

  // Actualiza el nombre de un espacio en la base de datos.
  //
  // Entradas:
  // - [nombre]: Nombre actual del espacio.
  // - [nuevoNombre]: Nuevo nombre propuesto.
  //
  Future<bool> updateNombre(String nombre, String nuevoNombre) async {
  try {

    // Verificar que el nuevo nombre no esté asignado a otro espacio
    final existe = await existeEspacio(nuevoNombre);
    if (existe) {
      print('El nombre "$nuevoNombre" ya está en uso por otro espacio.');
      return false; // No se puede actualizar, el nuevo nombre ya existe
    }
    // Buscar el espacio con el nombre actual
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Espacios')
        .where('nombre', isEqualTo: nombre)
        .get();

    // Si se encuentra al menos un espacio con ese nombre, actualizar el primero
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

  // Verifica si un espacio con el nombre dado ya existe en la base de datos.
  //
  // Entradas:
  // - [nombre]: Nombre del espacio a verificar.
  //
  // Salida: Retorna true si existe al menos un espacio con ese nombre, false en caso contrario.
  //
  static Future<bool> existeEspacio(String nombre) async {
    try {
      // Buscar el espacio por nombre
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();
      // Si se encuentra al menos un espacio con ese nombre, retornar true
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error verificando existencia de espacio: $e');
      return false;
    }
  }


  // Actualiza la capacidad del espacio especificado por su nombre.
  //
  // Entradas:
  // - [nombre]: Nombre del espacio.
  // - [nuevaCapacidad]: Nueva capacidad a asignar.
  //
  Future<void> updateCapacidad(String nombre, int nuevaCapacidad) async {
    try {
      // Buscar el espacio por nombre
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();
      // Si se encuentra al menos un espacio con ese nombre, actualizar el primero
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

  // Actualiza la hora de inicio del espacio.
  //
  // Entradas:
  // - [nombre]: Nombre del espacio.
  // - [nuevoHorarioIni]: Nueva hora de inicio.
  //
  Future<void> updateHorarioIni(String nombre, TimeOfDay nuevoHorarioIni) async {
    try {
      // Buscar el espacio por nombre
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();

      // Si se encuentra al menos un espacio con ese nombre, actualizar el primero
      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Espacios')
            .doc(querySnapshot.docs.first.id)
            .update({ // Actualizar el campo horarioIni
          'horarioIni': '${nuevoHorarioIni.hour.toString().padLeft(2, '0')}:${nuevoHorarioIni.minute.toString().padLeft(2, '0')}', // Formatear la hora como "HH:mm"
        });
      } else {
        print('Espacio no encontrado con el nombre proporcionado.');
      }
    } catch (e) {
      print('Error actualizando horario inicial de espacio: $e');
    }
  }

  // Actualiza la hora de fin del espacio.
  //
  // Entradas:
  // - [nombre]: Nombre del espacio.
  // - [nuevoHorarioFin]: Nueva hora de fin.
  //
  Future<void> updateHorarioFin(String nombre, TimeOfDay nuevoHorarioFin) async {
    try {
      // Buscar el espacio por nombre
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();
      // Si se encuentra al menos un espacio con ese nombre, actualizar el primero
      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Espacios')
            .doc(querySnapshot.docs.first.id)
            .update({ // Actualizar el campo horarioFin
          'horarioFin': '${nuevoHorarioFin.hour.toString().padLeft(2, '0')}:${nuevoHorarioFin.minute.toString().padLeft(2, '0')}',  // Formatear la hora como "HH:mm"
        });
      } else {
        print('Espacio no encontrado con el nombre proporcionado.');
      }
    } catch (e) {
      print('Error actualizando horario final de espacio: $e');
    }
  }

  // Actualiza la descripción de un espacio dado su nombre.
  //
  // Entradas:
  // - [nombre]: Nombre del espacio.
  // - [nuevaDescripcion]: Nueva descripción.
  //
  Future<void> updateDescripcion(String nombre, String nuevaDescripcion) async {
    try {
      // Buscar el espacio por nombre
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Espacios')
          .where('nombre', isEqualTo: nombre)
          .get();

      // Si se encuentra al menos un espacio con ese nombre, actualizar el primero
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

  // Recupera todos los espacios disponibles desde Firestore.
  //
  // Entradas: Ninguna.
  // Salida: Lista de objetos `Espacio`.
  //
  static Future<List<Espacio>> getEspacios() async {
    List<Espacio> espacios = [];  // Lista para almacenar los espacios recuperados
    try {
      // Obtener todos los documentos de la colección 'Espacios'
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Espacios').get();

      // Si no hay documentos, retornar lista vacía
      if (querySnapshot.docs.isEmpty) {
        print('No hay espacios disponibles.');
        return espacios;
      }

      // Iterar sobre los documentos recuperados
      for (var doc in querySnapshot.docs) {
        espacios.add(Espacio(         // Crear un objeto Espacio por cada documento
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

  // Convierte una cadena "HH:mm" a un objeto `TimeOfDay`.
  //
  // Entradas:
  // - [horaStr]: Hora en formato string.
  // Salida: Objeto `TimeOfDay`.
  //
  static TimeOfDay _parseHora(String horaStr) {
    final parts = horaStr.split(':');     // Dividir la cadena en horas y minutos
    final hour = int.parse(parts[0]);     // Convertir la parte de horas a entero
    final minute = int.parse(parts[1]);     // Convertir la parte de minutos a entero
    return TimeOfDay(hour: hour, minute: minute);   // Retornar un objeto TimeOfDay con las horas y minutos
  }

  // Obtiene el nombre de un espacio a partir de su ID.
  //
  // Entradas:
  // - [uid]: Identificador del documento del espacio.
  // Salida: Nombre del espacio o cadena vacía.
  //
  static Future<String> getNombre(String uid) async {
    try {
      // Obtener el documento del espacio por su ID
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Espacios').doc(uid).get();

      // Verificar si el documento existe
      if (doc.exists) {
        Map<String, dynamic> datosEspacio = doc.data() as Map<String, dynamic>; // Obtener los datos del espacio
        return datosEspacio['nombre'];  // Retornar el nombre del espacio
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


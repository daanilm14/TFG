import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Clase Reserva que representa una reserva de un espacio.
// Esta clase contiene métodos para agregar, eliminar, modificar y obtener reservas de la base de datos.
class Reserva{
  // Atributos.
  String id_usuario;      // ID del usuario que realiza la reserva.
  String id_espacio;      // ID del espacio que se reserva.
  String fecha;           // Fecha de la reserva en formato "DD/MM/YYYY". 
  TimeOfDay hora;         // Hora de la reserva, representada como un objeto TimeOfDay.
  String evento;          // Nombre del evento asociado a la reserva. 
  String descripcion;     // Descripción de la reserva.
  String estado;          // Estado de la reserva (por ejemplo, "pendiente", "aceptada", "rechazada").

  // Constructor.
  Reserva({required this.id_usuario, required this.id_espacio, required this.fecha, required this.hora , required this.evento,required this.descripcion, required this.estado});

  // Agrega una nueva reserva a la base de datos.
  //
  // Entradas:
  // - [id_usuario]: ID del usuario que reserva.
  // - [id_espacio]: ID del espacio reservado.
  // - [fecha]: Fecha en formato String.
  // - [hora]: Objeto TimeOfDay con la hora reservada.
  // - [evento]: Nombre del evento.
  // - [descripcion]: Descripción del evento.
  // - [estado]: Estado inicial de la reserva.
  // 
  static Future<void> addReserva(String id_usuario, String id_espacio, String fecha, TimeOfDay hora, String evento, String descripcion, String estado) async {
    try {
      await FirebaseFirestore.instance.collection('Reservas').add({
      'id_usuario': id_usuario,
      'id_espacio': id_espacio,
      'fecha': fecha,
      'hora': '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}',
      'descripcion': descripcion,
      'evento': evento,
      'estado': estado,
      });
    } catch (e) {
      print('Error añadiendo reserva: $e');
    }
  }

  // Convierte un mapa (documento de Firestore) en un objeto Reserva.
  //
  // Entradas:
  // - [data]: Mapa con los datos de la reserva.
  //
  // Salida: Objeto Reserva.
  //
  static Reserva fromMap(Map<String, dynamic> data) {
    return Reserva(
      id_usuario: data['id_usuario'],
      id_espacio: data['id_espacio'],
      fecha: data['fecha'], 
      hora: _parseHora(data['hora']), 
      evento: data['evento'],
      descripcion: data['descripcion'],
      estado: data['estado'],
    );
  }


  
  // Convierte un string en formato HH:mm a TimeOfDay.
  //
  // Entradas:
  // - [horaStr]: Cadena con la hora.
  //
  // Salida: Objeto TimeOfDay.
  //
  static TimeOfDay _parseHora(String horaStr) {
    final parts = horaStr.split(':');           // Divide la cadena en horas y minutos.   
    final hour = int.parse(parts[0]);           // Convierte la parte de horas a entero.  
    final minute = int.parse(parts[1]);         // Convierte la parte de minutos a entero.
    return TimeOfDay(hour: hour, minute: minute);     // Crea un objeto TimeOfDay con las horas y minutos.
  }
  

  // Elimina una reserva existente de Firestore.
  //
  // Entradas:
  // - [id_usuario]: ID del usuario.
  // - [id_espacio]: ID del espacio.
  // - [fecha]: Fecha de la reserva.
  // - [hora]: Hora de la reserva.
  // - [estado]: Estado actual.
  //
  Future<void> deleteReserva(String id_usuario, String id_espacio, String fecha, TimeOfDay hora, String estado) async {
    try {
      // Buscar la reserva en Firestore con los parámetros proporcionados.
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('id_usuario', isEqualTo: id_usuario)
          .where('id_espacio', isEqualTo: id_espacio)
          .where('fecha', isEqualTo: fecha)
          .where('hora', isEqualTo: '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}')
          .where('estado', isEqualTo: estado)
          .get();

      // Si se encuentra la reserva, eliminarla.
      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Reservas')
            .doc(querySnapshot.docs.first.id)
            .delete();
      } else {
        print('Reserva no encontrada con los datos proporcionados.');
      }
    } catch (e) {
      print('Error eliminando reserva: $e');
    }
  }

  // Actualiza el estado de una reserva (pendiente/aceptada).
  //
  // Entradas:
  // - [id_usuario]: ID del usuario.
  // - [id_espacio]: ID del espacio.
  // - [fecha]: Fecha de la reserva.
  // - [hora]: Hora de la reserva.
  // - [nuevoEstado]: Nuevo estado a asignar.
  //
  // Salida: `true` si se actualizó correctamente, `false` si ya hay conflicto o error.
  //
  Future<bool> updateEstado(String id_usuario, String id_espacio, String fecha, TimeOfDay hora, String nuevoEstado) async {
    try {
      // Formatear la hora a HH:mm
      final horaString = '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';

      if (nuevoEstado == 'aceptada') {
        // Revisar si ya existe otra reserva aceptada en ese espacio, fecha y hora
        final ocupacionQuery = await FirebaseFirestore.instance
            .collection('Reservas')
            .where('id_espacio', isEqualTo: id_espacio)
            .where('fecha', isEqualTo: fecha)
            .where('hora', isEqualTo: horaString)
            .where('estado', isEqualTo: 'aceptada')
            .get();

        // Si ya existe, no permitimos aceptar
        if (ocupacionQuery.docs.isNotEmpty) {
          return false;
        }
      }

      // Actualizar la reserva (buscarla primero)
      final reservaQuery = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('id_usuario', isEqualTo: id_usuario)
          .where('id_espacio', isEqualTo: id_espacio)
          .where('fecha', isEqualTo: fecha)
          .where('hora', isEqualTo: horaString)
          .get();

      // Si se encuentra la reserva, actualizar su estado
      if (reservaQuery.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Reservas')
            .doc(reservaQuery.docs.first.id)
            .update({'estado': nuevoEstado});
        return true;
      } else {
        print('Reserva no encontrada con los datos proporcionados.');
        return false;
      }
    } catch (e) {
      print('Error actualizando estado de reserva: $e');
      return false;
    }
  }


  // Obtiene todas las reservas con un estado específico.
  //
  // Entradas:
  // - [estado]: "pendiente" o "aceptada".
  //
  // Salida: Lista de reservas con ese estado.
  //
  static Future<List<Reserva>> getReservasPorEstado(String estado) async {
    List<Reserva> reservas = [];    // Lista para almacenar las reservas obtenidas.
    try {
      // Realiza una consulta a la base de datos para obtener las reservas con el estado especificado.
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('estado', isEqualTo: estado)
          .get();

      // Itera sobre los documentos obtenidos y los convierte en objetos Reserva.
      for (var doc in querySnapshot.docs) {
        reservas.add(Reserva.fromMap(doc.data()));
      }
    } catch (e) {
      print('Error obteniendo reservas por estado: $e');
    }
    return reservas;
  }


  // Obtiene todas las reservas realizadas por un usuario.
  //
  // Entradas:
  // - [id_usuario]: ID del usuario.
  //
  // Salida: Lista de reservas.
  //
  static Future<List<Reserva>> getReservasPorIdUsuario(String id_usuario) async {
    List<Reserva> reservas = [];      // Lista para almacenar las reservas obtenidas.
    try {
      // Realiza una consulta a la base de datos para obtener las reservas del usuario especificado.
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('id_usuario', isEqualTo: id_usuario)
          .get();

      // Itera sobre los documentos obtenidos.
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;   // Convierte el documento a un mapa.

        // Obtener el nombre del espacio usando el id_espacio.
        final espacioDoc = await FirebaseFirestore.instance
            .collection('Espacios')
            .doc(data['id_espacio'])
            .get();

        // Si el documento del espacio existe, asigna su nombre al campo id_espacio.
        if (espacioDoc.exists) {
          data['id_espacio'] = espacioDoc.data()?['nombre'] ?? 'Nombre no disponible';
        } else {
          data['id_espacio'] = 'Espacio no encontrado';
        }

        reservas.add(Reserva.fromMap(data));
      }
    } catch (e) {
      print('Error obteniendo reservas por id_usuario: $e');
    }
    return reservas;
  }


  // Obtiene todas las reservas que ocurren en una fecha concreta.
  //
  // Entradas:
  // - [fecha]: Fecha en formato dd/MM/yyyy.
  //
  // Salida: Lista de reservas para esa fecha.
  //
  static Future<List<Reserva>> getReservasPorFecha(String fecha) async {
    List<Reserva> reservas = [];      // Lista para almacenar las reservas obtenidas.
    try {
      // Realiza una consulta a la base de datos para obtener las reservas de la fecha especificada.
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('fecha', isEqualTo: fecha)
          .get();

      // Itera sobre los documentos obtenidos y los convierte en objetos Reserva.
      for (var doc in querySnapshot.docs) {
        reservas.add(Reserva.fromMap(doc.data()));
      }
    } catch (e) {
      print('Error obteniendo reservas por fecha: $e');
      if (e is FirebaseException) {
        print('Código de error: ${e.code}');
        print('Mensaje de error: ${e.message}');
        print('Stacktrace: ${e.stackTrace}');
      }

    }
    
    return reservas;
  }


}
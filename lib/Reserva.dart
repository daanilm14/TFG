import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reserva{
  // Atributos.
  String id_usuario;
  String id_espacio;
  String fecha;
  TimeOfDay hora;
  String evento;
  String descripcion;
  String estado;

  // Constructor.
  Reserva({required this.id_usuario, required this.id_espacio, required this.fecha, required this.hora , required this.evento,required this.descripcion, required this.estado});

  // Método para agregar una reserva a la base de datos.
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

  // Método para convertir un mapa a un objeto Reserva.
  static Reserva fromMap(Map<String, dynamic> data) {
    print(data);
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


  
  // Función auxiliar para convertir String "HH:mm" a TimeOfDay
  static TimeOfDay _parseHora(String horaStr) {
    final parts = horaStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
  

  // Método para eliminar una reserva de la base de datos.
  Future<void> deleteReserva(String id_usuario, String id_espacio, String fecha, TimeOfDay hora, String estado) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('id_usuario', isEqualTo: id_usuario)
          .where('id_espacio', isEqualTo: id_espacio)
          .where('fecha', isEqualTo: fecha)
          .where('hora', isEqualTo: '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}')
          .where('estado', isEqualTo: estado)
          .get();

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

  // Método para modificar el estado de una reserva en la base de datos.
  Future<bool> updateEstado(String id_usuario, String id_espacio, String fecha, TimeOfDay hora, String nuevoEstado) async {
    try {
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


  // Método para obtener todas las reservas según el estado.
  static Future<List<Reserva>> getReservasPorEstado(String estado) async {
    List<Reserva> reservas = [];
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('estado', isEqualTo: estado)
          .get();

      for (var doc in querySnapshot.docs) {
        reservas.add(Reserva.fromMap(doc.data()));
      }
    } catch (e) {
      print('Error obteniendo reservas por estado: $e');
    }
    return reservas;
  }

  // Método para obtener todas las reservas de un usuario.
  Future<List<Map<String, dynamic>>> getReservasPorUsuario(String id_usuario) async {
    List<Map<String, dynamic>> reservas = [];
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('id_usuario', isEqualTo: id_usuario)
          .get();

      for (var doc in querySnapshot.docs) {
        reservas.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error obteniendo reservas por usuario: $e');
    }
    return reservas;
  }

  //Método para obtener las reservas de un usuario con un id_usuario.
  static Future<List<Reserva>> getReservasPorIdUsuario(String id_usuario) async {
    List<Reserva> reservas = [];
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('id_usuario', isEqualTo: id_usuario)
          .get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Obtener el nombre del espacio usando el id_espacio.
        final espacioDoc = await FirebaseFirestore.instance
            .collection('Espacios')
            .doc(data['id_espacio'])
            .get();

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



  // Obtener todas las reservas (sin filtro)
  static Future<List<Reserva>> getTodasReservas() async {
    List<Reserva> reservas = [];
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Reservas').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();

        // Obtener el nombre del espacio
        final espacioDoc = await FirebaseFirestore.instance
            .collection('Espacios')
            .doc(data['id_espacio'])
            .get();

        if (espacioDoc.exists) {
          data['id_espacio'] = espacioDoc.data()?['nombre'] ?? 'Nombre no disponible';
        } else {
          data['id_espacio'] = 'Espacio no encontrado';
        }

        reservas.add(Reserva.fromMap(data));
      }
    } catch (e) {
      print('Error obteniendo todas las reservas: $e');
    }
    return reservas;
  }

  // Obtener reservas por espacio (id_espacio)
  static Future<List<Reserva>> getReservasPorIdEspacio(String id_espacio) async {
    List<Reserva> reservas = [];
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('id_espacio', isEqualTo: id_espacio)
          .get();

      for (var doc in querySnapshot.docs) {
        reservas.add(Reserva.fromMap(doc.data()));
      }
    } catch (e) {
      print('Error obteniendo reservas por id_espacio: $e');
    }
    return reservas;
  }

  // Actualizar descripción o evento de una reserva
  Future<void> updateDescripcionYEvento(String id_usuario, String id_espacio, String fecha, TimeOfDay hora, String nuevaDescripcion, String nuevoEvento) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('id_usuario', isEqualTo: id_usuario)
          .where('id_espacio', isEqualTo: id_espacio)
          .where('fecha', isEqualTo: fecha)
          .where('hora', isEqualTo: '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Reservas')
            .doc(querySnapshot.docs.first.id)
            .update({
          'descripcion': nuevaDescripcion,
          'evento': nuevoEvento,
        });
      } else {
        print('Reserva no encontrada con los datos proporcionados.');
      }
    } catch (e) {
      print('Error actualizando descripción y evento de reserva: $e');
    }
  }

  // Método para obtener reservas por fecha.
  static Future<List<Reserva>> getReservasPorFecha(String fecha) async {
    List<Reserva> reservas = [];
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('fecha', isEqualTo: fecha)
          .get();

      for (var doc in querySnapshot.docs) {
        reservas.add(Reserva.fromMap(doc.data()));
        print('Reserva obtenida: ${doc.data()}');
      }
      print('Reservas obtenidas: $reservas');
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
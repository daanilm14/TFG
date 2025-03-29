import 'package:cloud_firestore/cloud_firestore.dart';

class Reserva{
  // Atributos.
  String id_usuario;
  String id_espacio;
  String fecha;
  String evento;
  String estado;

  // Constructor.
  Reserva({required this.id_usuario, required this.id_espacio, required this.fecha, required this.evento, required this.estado});

  // Método para agregar una reserva a la base de datos.
  Future<void> addReserva(String id_usuario, String id_espacio, String fecha, String evento, String estado) async {
    try {
      await FirebaseFirestore.instance.collection('Reservas').add({
      'id_usuario': id_usuario,
      'id_espacio': id_espacio,
      'fecha': fecha,
      'evento': evento,
      'estado': estado,
      });
    } catch (e) {
      print('Error añadiendo reserva: $e');
    }
  }

  // Método para eliminar una reserva de la base de datos.
  Future<void> deleteReserva(String id_usuario, String id_espacio, String fecha) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('id_usuario', isEqualTo: id_usuario)
          .where('id_espacio', isEqualTo: id_espacio)
          .where('fecha', isEqualTo: fecha)
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
  Future<void> updateEstado(String id_usuario, String id_espacio, String fecha, String nuevoEstado) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('id_usuario', isEqualTo: id_usuario)
          .where('id_espacio', isEqualTo: id_espacio)
          .where('fecha', isEqualTo: fecha)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Reservas')
            .doc(querySnapshot.docs.first.id)
            .update({'estado': nuevoEstado});
      } else {
        print('Reserva no encontrada con los datos proporcionados.');
      }
    } catch (e) {
      print('Error actualizando estado de reserva: $e');
    }
  }

  // Método para obtener todas las reservas según el estado.
  Future<List<Map<String, dynamic>>> getReservasPorEstado(String estado) async {
    List<Map<String, dynamic>> reservas = [];
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Reservas')
          .where('estado', isEqualTo: estado)
          .get();

      for (var doc in querySnapshot.docs) {
        reservas.add(doc.data() as Map<String, dynamic>);
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



}
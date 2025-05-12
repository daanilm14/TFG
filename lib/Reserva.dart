import 'package:cloud_firestore/cloud_firestore.dart';
import 'Espacio.dart';

class Reserva{
  // Atributos.
  String id_usuario;
  String id_espacio;
  String fecha;
  String evento;
  String descripcion;
  String estado;

  // Constructor.
  Reserva({required this.id_usuario, required this.id_espacio, required this.fecha, required this.evento,required this.descripcion, required this.estado});

  // Método para agregar una reserva a la base de datos.
  Future<void> addReserva(String id_usuario, String id_espacio, String fecha, String evento, String descripcion, String estado) async {
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

  // Método para convertir un mapa a un objeto Reserva.
  static Reserva fromMap(Map<String, dynamic> data) {
    final DateTime dateTime = (data['fecha'] as Timestamp).toDate();

    final String formattedDate = 
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} '
        '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';

    return Reserva(
      id_usuario: data['id_usuario'],
      id_espacio: data['id_espacio'],
      fecha: formattedDate, 
      evento: data['evento'],
      descripcion: data['descripcion'],
      estado: data['estado'],
    );
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
        Map<String, dynamic> data = doc.data();

        reservas.add(Reserva.fromMap(data));
      }
    } catch (e) {
      print('Error obteniendo reservas por id_espacio: $e');
    }
    return reservas;
  }

  // Actualizar descripción o evento de una reserva
  Future<void> updateDescripcionYEvento(String id_usuario, String id_espacio, String fecha, String nuevaDescripcion, String nuevoEvento) async {
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
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        reservas.add(Reserva.fromMap(data));
      }
    } catch (e) {
      print('Error obteniendo reservas por fecha: $e');
    }
    return reservas;
  }


}
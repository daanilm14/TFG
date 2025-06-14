import 'package:flutter/material.dart';
import 'package:tfg/Usuario.dart';
import 'package:tfg/Reserva.dart';

// Clase MisEspacios
// Esta clase muestra los espacios reservados por el usuario actual
// y permite ver detalles de cada reserva.
//
class MisEspacios extends StatefulWidget {
  final Usuario usuario;            // El usuario actual que ha iniciado sesión
  const MisEspacios({super.key, required this.usuario});

  @override
  _MisEspaciosState createState() => _MisEspaciosState();
}

class _MisEspaciosState extends State<MisEspacios> {
  late Future<List<Reserva>> futureReservas;      // Variable para almacenar las reservas del usuario

  @override
  void initState() {      // Inicializa el estado del widget
    super.initState();    
    futureReservas = Reserva.getReservasPorIdUsuario(widget.usuario.uid);   // Obtiene las reservas del usuario actual
    futureReservas = futureReservas.then(                                   // Filtra las reservas para mostrar solo las aceptadas
      (reservas) => reservas.where((r) => r.estado == 'aceptada').toList(),
    );
  }

  // Método para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;        // Obtiene el ancho de la pantalla
    final screenHeight = MediaQuery.of(context).size.height;      // Obtiene la altura de la pantalla

    final double titleSize = screenWidth * 0.04;        // Tamaño del título
    final double backIconSize = screenWidth * 0.025;    // Tamaño del icono de retroceso

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.01,
        ),
        child: Column(
          // CABECERA
          children: [
            Row(
              children: [
                IconButton(
                  iconSize: backIconSize,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'MIS ESPACIOS',
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: backIconSize),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),

            // Lista de Reservas
            Expanded(
              child: FutureBuilder<List<Reserva>>(
                future: futureReservas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {    
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {      // Si no hay reservas, muestra un mensaje
                    return const Center(child: Text("No tienes reservas activas."));
                  }

                  final reservas = snapshot.data!;  // Lista de reservas obtenidas

                  return ListView.builder(          // Construye la lista de reservas
                    padding: const EdgeInsets.all(16),
                    itemCount: reservas.length,
                    itemBuilder: (context, index) {
                      final reserva = reservas[index];

                      // Cada reserva se muestra como una tarjeta
                      return Card(
                        shape: RoundedRectangleBorder(    
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(  // Muestra los detalles de la reserva
                          title: Text(reserva.id_espacio),
                          subtitle: Text('Fecha: ${reserva.fecha}\nEvento: ${reserva.evento}        Descripción: ${reserva.descripcion}'),
                
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

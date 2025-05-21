import 'package:flutter/material.dart';
import 'Reserva.dart';
import 'Espacio.dart';
import 'Usuario.dart';

class ListaPeticiones extends StatefulWidget {
  const ListaPeticiones({super.key});

  @override
  State<ListaPeticiones> createState() => _ListaPeticionesState();
}

class _ListaPeticionesState extends State<ListaPeticiones> {
  late Future<List<Reserva>> futureReservas;  // Future que carga las reservas pendientes

  @override
  void initState() {
    super.initState();
    // Al iniciar, cargamos las reservas con estado "pendiente"
    futureReservas = Reserva.getReservasPorEstado("pendiente");
  }

  // Función para recargar las reservas (usada después de aceptar o eliminar)
  Future<void> recargarReservas() async {
    setState(() {
      futureReservas = Reserva.getReservasPorEstado("pendiente");
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtener tamaño de pantalla para diseño responsivo
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double titleSize = screenWidth * 0.04;      // Tamaño del texto del título
    final double backIconSize = screenWidth * 0.025;  // Tamaño del icono de retroceso

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.01,
          ),
          child: Column(
            children: [
              // CABECERA CON TÍTULO Y BOTÓN DE VOLVER
              Column(
                children: [
                  Row(
                    children: [
                      // Botón para volver a la pantalla anterior
                      IconButton(
                        iconSize: backIconSize,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'LISTA DE PETICIONES',
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Espacio para equilibrar la fila (misma anchura que el icono)
                      SizedBox(width: backIconSize),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),  // Espacio debajo de la cabecera
                ],
              ),

              // LISTADO DE RESERVAS PENDIENTES
              Expanded(
                child: FutureBuilder<List<Reserva>>(
                  future: futureReservas,  // Esperamos a que se carguen las reservas
                  builder: (context, snapshot) {
                    // Mientras carga, mostrar indicador circular
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Si no hay datos o lista vacía, mostrar mensaje
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No hay peticiones pendientes."));
                    }

                    final reservas = snapshot.data!;

                    // Mostrar lista de reservas con ListView.builder para eficiencia
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: reservas.length,
                      itemBuilder: (context, index) {
                        final reserva = reservas[index];

                        // Formatear hora a string "HH:mm"
                        final horaString =
                            '${reserva.hora.hour.toString().padLeft(2, '0')}:${reserva.hora.minute.toString().padLeft(2, '0')}';

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Mostrar nombre del usuario con FutureBuilder (carga asíncrona)
                                FutureBuilder<String>(
                                  future: Usuario.getNombre(reserva.id_usuario),
                                  builder: (context, userSnapshot) {
                                    String nombreUsuario = userSnapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? 'Cargando...'
                                        : userSnapshot.data ?? reserva.id_usuario;
                                    return Row(
                                      children: [
                                        const Icon(Icons.person,
                                            size: 20, color: Colors.blueGrey),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Usuario: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey[700]),
                                        ),
                                        Expanded(
                                          child: Text(
                                            nombreUsuario,
                                            style: const TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                const SizedBox(height: 8),

                                // Mostrar nombre del espacio con FutureBuilder (carga asíncrona)
                                FutureBuilder<String>(
                                  future: Espacio.getNombre(reserva.id_espacio),
                                  builder: (context, espacioSnapshot) {
                                    String nombreEspacio = espacioSnapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? 'Cargando...'
                                        : espacioSnapshot.data ?? reserva.id_espacio;
                                    return Row(
                                      children: [
                                        const Icon(Icons.meeting_room,
                                            size: 20, color: Colors.teal),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Espacio: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal[700]),
                                        ),
                                        Expanded(
                                          child: Text(
                                            nombreEspacio,
                                            style: const TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                const SizedBox(height: 8),

                                // Mostrar fecha de la reserva
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 20, color: Colors.deepPurple),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Fecha: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple[700]),
                                    ),
                                    Text(
                                      '${reserva.fecha}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Mostrar hora de la reserva
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        size: 20, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Hora: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange[700]),
                                    ),
                                    Text(
                                      horaString,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Mostrar evento asociado a la reserva
                                Row(
                                  children: [
                                    const Icon(Icons.event,
                                        size: 20, color: Colors.indigo),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Evento: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo[700]),
                                    ),
                                    Expanded(
                                      child: Text(
                                        reserva.evento,
                                        style: const TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Botones para aceptar o eliminar la reserva
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        // Llamar a la función para actualizar el estado de la reserva
                                        // Devuelve true si se pudo aceptar, false si el espacio está ocupado
                                        bool exito = await reserva.updateEstado(
                                          reserva.id_usuario,
                                          reserva.id_espacio,
                                          reserva.fecha,
                                          reserva.hora,
                                          'aceptada',
                                        );

                                        if (exito) {
                                          // Recargar lista y mostrar confirmación
                                          await recargarReservas();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Reserva aceptada correctamente.'),
                                            ),
                                          );
                                        } else {
                                          // Mostrar mensaje de error si espacio ocupado
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('El espacio ya está ocupado en esa fecha y hora.'),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade600,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      icon: const Icon(Icons.check),
                                      label: const Text('Aceptar'),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        // Eliminar la reserva y recargar lista
                                        await reserva.deleteReserva(
                                          reserva.id_usuario,
                                          reserva.id_espacio,
                                          reserva.fecha,
                                          reserva.hora,
                                          reserva.estado,
                                        );
                                        await recargarReservas();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade600,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Eliminar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tfg/Usuario.dart';
import 'package:tfg/Reserva.dart';

class MisEspacios extends StatefulWidget {
  final Usuario usuario;
  const MisEspacios({super.key, required this.usuario});

  @override
  _MisEspaciosState createState() => _MisEspaciosState();
}

class _MisEspaciosState extends State<MisEspacios> {
  late Future<List<Reserva>> futureReservas;

  @override
  void initState() {
    super.initState();
    futureReservas = Reserva.getReservasPorIdUsuario(widget.usuario.uid);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double titleSize = screenWidth * 0.04;
    final double backIconSize = screenWidth * 0.025;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.01,
        ),
        child: Column(
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

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No tienes reservas activas."));
                  }

                  final reservas = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: reservas.length,
                    itemBuilder: (context, index) {
                      final reserva = reservas[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
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

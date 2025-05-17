import 'package:flutter/material.dart';
import 'Reserva.dart';
import 'Espacio.dart';
import 'Usuario.dart';
import 'HomeAdmin.dart';
import 'HomeUser.dart';
import 'package:intl/intl.dart';

class RealizarReserva extends StatefulWidget {
  final Usuario usuario;
  final Espacio espacio;
  final String fecha;
  final TimeOfDay hora;

  const RealizarReserva({
    super.key,
    required this.usuario,
    required this.espacio,
    required this.fecha,
    required this.hora,
  });

  @override
  _RealizarReservaState createState() => _RealizarReservaState();
}

class _RealizarReservaState extends State<RealizarReserva> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double titleSize = screenWidth * 0.04;
    final double backIconSize = screenWidth * 0.025;

    // Formatear hora y fecha
    final String horaFormatted =
        '${widget.hora.hour.toString().padLeft(2, '0')}:${widget.hora.minute.toString().padLeft(2, '0')}';
    final String fechaFormatted = widget.fecha;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CABECERA
                Row(
                  children: [
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
                          'RESERVAR ESPACIO',
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

                // SECCIÓN ESPACIO + FECHA + HORA
                Center(
                  child: Column(
                    children: [
                      Text(
                        widget.espacio.nombre,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035, // Tamaño reducido
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        fechaFormatted,
                        style: TextStyle(
                          fontSize: screenWidth * 0.025,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        horaFormatted,
                        style: TextStyle(
                          fontSize: screenWidth * 0.015,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // FORMULARIO
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Evento", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _eventoController,
                        decoration: InputDecoration(
                          hintText: "Nombre del Evento",
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el nombre del evento';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      const Text("Descripción", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descripcionController,
                        decoration: InputDecoration(
                          hintText: "Descripción del Evento",
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: screenHeight * 0.05),

                    // BOTÓN SOLICITAR RESERVA
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {

                          await Reserva.addReserva(
                            widget.usuario.uid,
                            widget.espacio.id_espacio!,
                            widget.fecha,
                            widget.hora,
                            _eventoController.text,
                            _descripcionController.text,
                            'pendiente',
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reserva solicitada con éxito')),
                          );

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Solicitar Reserva', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'Reserva.dart';
import 'Espacio.dart';
import 'Usuario.dart';
import 'HomeAdmin.dart';
import 'HomeUser.dart';
import 'package:intl/intl.dart';

// Clase para realizar una reserva de un espacio
// Esta interfaz permite al usuario solicitar una reserva para un espacio específico
class RealizarReserva extends StatefulWidget {
  final Usuario usuario;    // Usuario que está realizando la reserva
  final Espacio espacio;    // Espacio que se va a reservar
  final String fecha;       // Fecha de la reserva en formato 'dd/MM/yyyy'
  final TimeOfDay hora;     // Hora de la reserva

  const RealizarReserva({   // Constructor de la clase
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
  final _formKey = GlobalKey<FormState>();                                      // Clave para el formulario de reserva
  final TextEditingController _eventoController = TextEditingController();      // Controlador para el campo de nombre del evento
  final TextEditingController _descripcionController = TextEditingController(); // Controlador para el campo de descripción del evento

  // Método para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;      // Ancho de la pantalla
    final screenHeight = MediaQuery.of(context).size.height;    // Altura de la pantalla

    final double titleSize = screenWidth * 0.04;                // Tamaño del título  
    final double backIconSize = screenWidth * 0.025;            // Tamaño del ícono de retroceso

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
                          fontSize: screenWidth * 0.035, 
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
                      const Text("Evento", style: TextStyle(fontWeight: FontWeight.bold)),  // Título del campo de nombre del evento
                      const SizedBox(height: 8),
                      TextFormField(  // Campo de texto para ingresar el nombre del evento
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

                      const Text("Descripción", style: TextStyle(fontWeight: FontWeight.bold)), // Título del campo de descripción del evento
                      const SizedBox(height: 8),
                      TextFormField(  // Campo de texto para ingresar la descripción del evento
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
                      child: ElevatedButton(  // Botón para solicitar la reserva
                        onPressed: () async {

                          await Reserva.addReserva( // Llama al método para agregar la reserva
                            widget.usuario.uid,
                            widget.espacio.id_espacio!,
                            widget.fecha,
                            widget.hora,
                            _eventoController.text,
                            _descripcionController.text,
                            'pendiente',  // Estado de la reserva
                          );

                          ScaffoldMessenger.of(context).showSnackBar( // Muestra un mensaje de éxito
                            const SnackBar(content: Text('Reserva solicitada con éxito')),
                          );

                          Navigator.pop(context); // Regresa a la pantalla anterior
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

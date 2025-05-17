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
  const RealizarReserva({super.key, required this.usuario, required this.espacio, required this.fecha, required this.hora});

  @override
  _RealizarReservaState createState() => _RealizarReservaState();
}

class _RealizarReservaState extends State<RealizarReserva> {
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double titleSize = screenWidth * 0.04;
    final double backIconSize = screenWidth * 0.025;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), // Para más espacio en los laterales
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CABECERA
                Row(
                  children: [
                    IconButton(
                      iconSize: backIconSize, // Tamaño del ícono de la flecha
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'RESERVAR ESPACIO', // Título con tamaño dinámico
                          style: TextStyle(
                            fontSize: titleSize, // Tamaño del título
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: backIconSize), // Espacio a la derecha del ícono
                  ],
                ),
                SizedBox(height: screenHeight * 0.04), // Espacio debajo del título
              ],
            ),
          ),
        ),
      ),
    );
  }
}
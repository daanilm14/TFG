import 'package:flutter/material.dart';
import 'package:tfg/Reserva.dart';
import 'package:tfg/Espacio.dart';
import 'package:tfg/Usuario.dart';
import 'HomeAdmin.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Reserva'),
      ),
      body: Center(
        child: Text('Contenido de la reserva'),
      ),
    );
  }
}
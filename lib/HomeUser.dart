import 'package:flutter/material.dart';
import 'package:tfg/HomeAdmin.dart';
import 'package:tfg/Usuario.dart';

class HomeUser extends StatelessWidget {


  final Usuario usuario;
  const HomeUser({super.key, required this.usuario});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel del Usuario'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          'Bienvenido, Usuario',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

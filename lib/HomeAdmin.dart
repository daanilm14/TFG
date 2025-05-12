import 'package:flutter/material.dart';
import 'package:tfg/Usuario.dart';
import 'GestionAdmin.dart'; 

class HomeAdmin extends StatelessWidget {

  final Usuario usuario;
  const HomeAdmin({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel del Administrador'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido, Administrador',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GestionAdmin(usuario: usuario)),
                );
              },
              child: Text('Ir a Gestión'),
            ),
          ],
        ),
      ),
    );
  }
}

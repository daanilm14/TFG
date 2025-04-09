import 'package:flutter/material.dart';
import 'GestionAdmin.dart'; // Importa la clase GestionAdmin

class HomeAdmin extends StatelessWidget {
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
                  MaterialPageRoute(builder: (context) => GestionAdmin()),
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

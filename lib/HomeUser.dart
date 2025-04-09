import 'package:flutter/material.dart';

class HomeUser extends StatelessWidget {
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

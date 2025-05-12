import 'package:flutter/material.dart';
import 'package:tfg/Usuario.dart';
import 'MisEspacios.dart';

class HomeUser extends StatelessWidget {
  final Usuario usuario;
  const HomeUser({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double titleSize = screenWidth * 0.04; 
    final double fontSize = screenWidth * 0.015; 
    final double iconContainerSize = titleSize * 1.2; 
    final double iconSize = titleSize * 0.6;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.005, 
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: iconContainerSize),

                Expanded(
                  child: Center(
                    child: Text(
                      'PRINCIPAL',
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MisEspacios(usuario: usuario),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(30), 
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: titleSize * 0.2), 
                        width: iconContainerSize,
                        height: iconContainerSize,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person, color: Colors.black, size: iconSize),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        usuario.nombre,
                        style: TextStyle(fontSize: fontSize, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }
}

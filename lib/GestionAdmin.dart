import 'package:flutter/material.dart';
import 'HomeAdmin.dart';
import 'CrearUsuario.dart';
import 'ImportarHorarios.dart';
import 'ListaUsuarios.dart';
import 'CrearEspacio.dart';
import 'ListaPeticiones.dart';
import 'ListaEspacios.dart';

class GestionAdmin extends StatelessWidget {
  const GestionAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double iconRadius = screenWidth * 0.03;
    final double iconSize = screenWidth * 0.03;
    final double fontSize = screenWidth * 0.025;
    final double titleSize = screenWidth * 0.04;
    final double backIconSize = screenWidth * 0.025;

    Widget buildButton(String label, IconData icon, Widget screen) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            },
            child: CircleAvatar(
              radius: iconRadius,
              backgroundColor: Colors.grey.shade300,
              child: Icon(icon, size: iconSize, color: Colors.black),
            ),
          ),
          SizedBox(height: screenHeight * 0.005), // menos espacio entre ícono y texto
          Text(label, style: TextStyle(fontSize: fontSize), textAlign: TextAlign.center),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.01,
          ),
          child: Column(
            children: [
              // CABECERA
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        iconSize: backIconSize,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeAdmin()),
                          );
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'GESTIÓN',
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
                SizedBox(height: screenHeight * 0.04), // más espacio
                ],
              ),
              // GRID
              Expanded(
              child: GridView.builder(
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: screenWidth * 0.01,
                  mainAxisSpacing: 0, // espacio entre filas casi eliminado
                  childAspectRatio: 2, // más ancho que alto = filas más compactas
                ),
                itemBuilder: (context, index) {
                  final items = [
                    ['Crear Usuario', Icons.person_add, CrearUsuario()],
                    ['Importar Horarios', Icons.note_add, ImportarHorarios()],
                    ['Lista de Usuarios', Icons.list, ListaUsuarios()],
                    ['Crear Espacio', Icons.add_box, CrearEspacio()],
                    ['Lista de Peticiones', Icons.format_list_bulleted, ListaPeticiones()],
                    ['Lista de Espacios', Icons.format_list_bulleted, ListaEspacios()],
                  ];
                  return buildButton(
                    items[index][0] as String,
                    items[index][1] as IconData,
                    items[index][2] as Widget,
                  );
                },
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GestionAdmin(),
  ));
}

import 'package:flutter/material.dart';
import 'package:tfg/Usuario.dart';
import 'HomeAdmin.dart';
import 'CrearUsuario.dart';
import 'ImportarHorarios.dart';
import 'ListaUsuarios.dart';
import 'CrearEspacio.dart';
import 'ListaPeticiones.dart';
import 'ListaEspacios.dart';

// Clase para la gestión de la aplicación por parte del administrador
// Esta clase muestra una pantalla con varias opciones de gestión
class GestionAdmin extends StatelessWidget {

    final Usuario usuario;  // Usuario actual que está gestionando la aplicación
    const GestionAdmin({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;    // Ancho de la pantalla
    final screenHeight = MediaQuery.of(context).size.height;  // Altura de la pantalla

    final double iconRadius = screenWidth * 0.03;       // Radio del círculo del ícono
    final double iconSize = screenWidth * 0.03;         // Tamaño del ícono  
    final double fontSize = screenWidth * 0.025;        // Tamaño de la fuente del texto
    final double titleSize = screenWidth * 0.04;        // Tamaño del título
    final double backIconSize = screenWidth * 0.025;    // Tamaño del ícono de retroceso

    // Función para construir un botón con ícono y texto
    // Esta función recibe el texto del botón, el ícono y la pantalla a la que navegará al hacer clic
    Widget buildButton(String label, IconData icon, Widget screen) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(  // Usamos InkWell para detectar toques
            onTap: () {
              Navigator.push( 
                context,  // Navega a la pantalla correspondiente al hacer clic
                MaterialPageRoute(builder: (context) => screen),
              );
            },
            child: CircleAvatar(  // Crea un círculo con el ícono dentro
              radius: iconRadius,
              backgroundColor: Colors.grey.shade300,
              child: Icon(icon, size: iconSize, color: Colors.black),
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Text(label, style: TextStyle(fontSize: fontSize), textAlign: TextAlign.center), // Texto debajo del ícono
        ],
      );
    }
    
    // Construye la interfaz de usuario
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
                            MaterialPageRoute(builder: (context) => HomeAdmin(usuario: usuario)),
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
              child: GridView.builder(  // Crea una cuadrícula de botones
                itemCount: 6, // Número de botones
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(  // Define el diseño de la cuadrícula
                  crossAxisCount: 3,
                  crossAxisSpacing: screenWidth * 0.01,
                  mainAxisSpacing: 0, 
                  childAspectRatio: 2, 
                ),
                itemBuilder: (context, index) {
                  final items = [
                    ['Crear Usuario', Icons.person_add, CrearUsuario()],                     // Botón para crear un nuevo usuario
                    ['Importar Horarios', Icons.note_add, ImportarHorarios()],               // Botón para importar horarios
                    ['Lista de Usuarios', Icons.list, ListaUsuarios(usuario: usuario)],      // Botón para ver la lista de usuarios
                    ['Crear Espacio', Icons.add_box, CrearEspacio()],                        // Botón para crear un nuevo espacio
                    ['Lista de Peticiones', Icons.format_list_bulleted, ListaPeticiones()],  // Botón para ver la lista de peticiones
                    ['Lista de Espacios', Icons.format_list_bulleted, ListaEspacios()],      // Botón para ver la lista de espacios
                  ];
                  return buildButton(
                    items[index][0] as String,    // Texto del botón
                    items[index][1] as IconData,  // Ícono del botón
                    items[index][2] as Widget,    // Pantalla a la que navegará al hacer clic
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



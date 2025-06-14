import 'package:flutter/material.dart';
import 'Espacio.dart';
import 'EditarEspacio.dart';

// Clase para mostrar una lista de espacios
// Esta interfaz permite al administrador ver la lista de espacios disponibles
// y editar sus detalles.
class ListaEspacios extends StatefulWidget {
  const ListaEspacios({super.key});

  @override
  State<ListaEspacios> createState() => _ListaEspaciosState();
}

class _ListaEspaciosState extends State<ListaEspacios> {
  late Future<List<Espacio>> futureEspacios;          // Variable para almacenar la lista de espacios

  // Inicializa la lista de espacios al cargar la pantalla
  @override
  void initState() {
    super.initState();  
    futureEspacios = Espacio.getEspacios(); // Llama a la función para cargar los espacios
  }

  // Función para cargar los espacios a través del objeto auxiliar
  Future<List<Espacio>> cargarEspacios() async {
    final espacios = await Espacio.getEspacios(); // Llama al método estático para obtener la lista de espacios
    return espacios;
  }

  // Construye la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;      // Ancho de la pantalla
    final screenHeight = MediaQuery.of(context).size.height;    // Altura de la pantalla

    final double titleSize = screenWidth * 0.04;                // Tamaño del título
    final double backIconSize = screenWidth * 0.025;            // Tamaño del ícono de retroceso  

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
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'LISTA DE ESPACIOS',
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
                ],
              ),

              // CONTENIDO
              Expanded(
                child: FutureBuilder<List<Espacio>>(    
                  future: futureEspacios, // Usa la variable futureEspacios para obtener los datos
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No hay espacios disponibles."));
                    }

                    final espacios = snapshot.data!;  // Obtiene la lista de espacios del snapshot

                    return ListView.builder(          // Crea una lista de espacios
                      padding: const EdgeInsets.all(16),
                      itemCount: espacios.length,
                      itemBuilder: (context, index) {
                        final espacio = espacios[index];

                        return Card(  // Crea una tarjeta para cada espacio
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(espacio.nombre),  // Muestra el nombre del espacio
                            subtitle: Text('Capacidad: ${espacio.capacidad}\nHorario: ${espacio.horarioIni.format(context)} - ${espacio.horarioFin.format(context)}'),  // Muestra la capacidad y horario del espacio
                            trailing: IconButton(
                              icon: const Icon(Icons.edit), // Ícono de editar
                              onPressed: () async { 
                                await Navigator.push(   // Navega a la pantalla de edición del espacio
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditarEspacio(espacio: espacio),  // Pasa el espacio seleccionado a la pantalla de edición
                                  ),
                                );
                                setState(() {
                                  // Vuelve a cargar los espacios después de editar
                                  futureEspacios = cargarEspacios();
                                });
                              },
                            ),
                          ),
                        );
                      },
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

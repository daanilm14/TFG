import 'package:flutter/material.dart';
import 'Espacio.dart';
import 'EditarEspacio.dart';

class ListaEspacios extends StatefulWidget {
  const ListaEspacios({super.key});

  @override
  State<ListaEspacios> createState() => _ListaEspaciosState();
}

class _ListaEspaciosState extends State<ListaEspacios> {
  late Future<List<Espacio>> futureEspacios;

  @override
  void initState() {
    super.initState();
    // Creamos un objeto auxiliar de la clase Espacio
    Espacio espacioAuxiliar = Espacio(
      nombre: '',
      capacidad: 0,
      horarioIni: TimeOfDay(hour: 0, minute: 0),
      horarioFin: TimeOfDay(hour: 0, minute: 0),
      descripcion: '',
    );
    // Cargamos los espacios utilizando el método getEspacios() del objeto auxiliar
    futureEspacios = espacioAuxiliar.getEspacios();
  }

  // Función para cargar los espacios a través del objeto auxiliar
  Future<List<Espacio>> cargarEspacios(Espacio espacioAuxiliar) async {
    final espacios = await espacioAuxiliar.getEspacios();
    return espacios;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double titleSize = screenWidth * 0.04;
    final double backIconSize = screenWidth * 0.025;

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
                  future: futureEspacios,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No hay espacios disponibles."));
                    }

                    final espacios = snapshot.data!;

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: espacios.length,
                      itemBuilder: (context, index) {
                        final espacio = espacios[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(espacio.nombre),
                            subtitle: Text('Capacidad: ${espacio.capacidad}\nHorario: ${espacio.horarioIni.format(context)} - ${espacio.horarioFin.format(context)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditarEspacio(espacio: espacio),
                                  ),
                                );
                                setState(() {
                                  // Vuelve a cargar los espacios después de editar
                                  futureEspacios = cargarEspacios(espacio);
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

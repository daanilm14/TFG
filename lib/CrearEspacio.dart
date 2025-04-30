import 'package:flutter/material.dart';
import 'Espacio.dart';

class CrearEspacio extends StatefulWidget {
  @override
  _CrearEspacioState createState() => _CrearEspacioState();
}

class _CrearEspacioState extends State<CrearEspacio> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController capacidadController = TextEditingController();

  TimeOfDay horaInicio = TimeOfDay.now();
  TimeOfDay horaFin = TimeOfDay.now();

  Future<void> _seleccionarHoraInicio(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: horaInicio,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) {
      setState(() {
        horaInicio = picked;
      });
    }
  }

  Future<void> _seleccionarHoraFin(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: horaFin,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) {
      setState(() {
        horaFin = picked;
      });
    }
  }

  void _crearEspacio() async {
    final nombre = nombreController.text.trim();
    final descripcion = descripcionController.text.trim();
    final capacidad = int.tryParse(capacidadController.text.trim());

    if (nombre.isEmpty || descripcion.isEmpty || capacidad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    Espacio nuevoEspacio = Espacio(
      nombre: nombre,
      capacidad: capacidad,
      horarioIni: horaInicio,
      horarioFin: horaFin,
      descripcion: descripcion,
    );

    await nuevoEspacio.addEspacio(nombre, capacidad, horaInicio, horaFin, descripcion);
    Navigator.pop(context);
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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CABECERA
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
                          'CREAR ESPACIO',
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

                const Text('Nombre'),
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    hintText: 'Nombre del espacio',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 20),

                const Text('Descripción'),
                TextField(
                  controller: descripcionController,
                  decoration: InputDecoration(
                    hintText: 'Descripción del espacio',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[300],
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 20),

                const Text('Capacidad'),
                TextField(
                  controller: capacidadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Capacidad máxima',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 30),

                // Row para alinear horizontalmente los botones de horario
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Horario Inicio'),
                          SizedBox(height: 5),
                          Container(
                            width: double.infinity, // Para que ocupe todo el espacio disponible
                            child: ElevatedButton(
                              onPressed: () => _seleccionarHoraInicio(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(color: Colors.black),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.access_time, color: Colors.black),
                                  SizedBox(width: 10),
                                  Text(
                                    '${horaInicio.hour.toString().padLeft(2, '0')}:${horaInicio.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Horario Fin'),
                          SizedBox(height: 5),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _seleccionarHoraFin(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(color: Colors.black),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.access_time, color: Colors.black),
                                  SizedBox(width: 10),
                                  Text(
                                    '${horaFin.hour.toString().padLeft(2, '0')}:${horaFin.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Botón para crear espacio
                Center(
                  child: ElevatedButton(
                    onPressed: _crearEspacio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Crear Espacio',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

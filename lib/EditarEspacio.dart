import 'package:flutter/material.dart';
import 'Espacio.dart';

class EditarEspacio extends StatefulWidget {
  final Espacio espacio;
  const EditarEspacio({super.key, required this.espacio});

  @override
  _EditarEspacioState createState() => _EditarEspacioState();
}

class _EditarEspacioState extends State<EditarEspacio> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController capacidadController = TextEditingController();

  late TimeOfDay horaInicio;
  late TimeOfDay horaFin;

  @override
  void initState() {
    super.initState();
    // Inicializamos los valores del espacio actual
    nombreController.text = widget.espacio.nombre;
    descripcionController.text = widget.espacio.descripcion;
    capacidadController.text = widget.espacio.capacidad.toString();
    horaInicio = widget.espacio.horarioIni;
    horaFin = widget.espacio.horarioFin;
  }

  Future<void> _seleccionarHoraInicio(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: horaInicio,
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
    );
    if (picked != null) {
      setState(() {
        horaFin = picked;
      });
    }
  }

  void _guardarCambios() async {
    final nombre = nombreController.text.trim();
    final descripcion = descripcionController.text.trim();
    final capacidad = int.tryParse(capacidadController.text.trim());

    if (nombre.isEmpty || descripcion.isEmpty || capacidad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    // Actualizamos el espacio
    Espacio espacioActualizado = Espacio(
      nombre: nombre,
      capacidad: capacidad,
      horarioIni: horaInicio,
      horarioFin: horaFin,
      descripcion: descripcion,
    );

    //await espacioActualizado.updateEspacio(); // Llamada al método para actualizar el espacio
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double titleSize = screenWidth * 0.04;
    final double backIconSize = screenWidth * 0.025;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EDITAR ESPACIO',
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          iconSize: backIconSize,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Nombre
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

                // Descripción
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
                  maxLines: 3,
                ),
                SizedBox(height: 20),

                // Capacidad
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
                SizedBox(height: 20),

                // Hora de Inicio
                const Text('Hora de Inicio'),
                ElevatedButton(
                  onPressed: () => _seleccionarHoraInicio(context),
                  child: Text('${horaInicio.hour.toString().padLeft(2, '0')}:${horaInicio.minute.toString().padLeft(2, '0')}'),
                ),
                SizedBox(height: 20),

                // Hora de Fin
                const Text('Hora de Fin'),
                ElevatedButton(
                  onPressed: () => _seleccionarHoraFin(context),
                  child: Text('${horaFin.hour.toString().padLeft(2, '0')}:${horaFin.minute.toString().padLeft(2, '0')}'),
                ),
                SizedBox(height: 30),

                // Botón para guardar los cambios
                Center(
                  child: ElevatedButton(
                    onPressed: _guardarCambios,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Guardar Cambios',
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

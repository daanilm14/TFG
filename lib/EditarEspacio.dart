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

  void _guardarCambios() async {
    String nuevoNombre = nombreController.text.trim();
    String nuevaDescripcion = descripcionController.text.trim();
    String capacidadText = capacidadController.text.trim();

    String nombreFinal = widget.espacio.nombre;
    String descripcionFinal = widget.espacio.descripcion;
    int capacidadFinal = widget.espacio.capacidad;
    TimeOfDay horarioInicioFinal = widget.espacio.horarioIni;
    TimeOfDay horarioFinFinal = widget.espacio.horarioFin;

    bool hayCambios = false;

    // Verificar y actualizar campos solo si se cambiaron y no están vacíos
    if (nuevoNombre.isNotEmpty && nuevoNombre != nombreFinal) {
      bool nombreActualizado = await widget.espacio.updateNombre(nombreFinal, nuevoNombre);
      if (nombreActualizado) {
        nombreFinal = nuevoNombre;
        hayCambios = true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo actualizar el nombre. Ya existe un espacio con ese nombre')),
        );
        return; // Salir y no continuar con otros cambios si falla el nombre
      }
    }

    if (nuevaDescripcion.isNotEmpty && nuevaDescripcion != descripcionFinal) {
      descripcionFinal = nuevaDescripcion;
      await widget.espacio.updateDescripcion(widget.espacio.nombre, descripcionFinal);
      hayCambios = true;
    }

    int? nuevaCapacidad = int.tryParse(capacidadText);
    if (nuevaCapacidad != null && nuevaCapacidad != capacidadFinal) {
      if (nuevaCapacidad <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La capacidad debe ser mayor a 0')),
        );
        return;
      }
      await widget.espacio.updateCapacidad(widget.espacio.nombre, nuevaCapacidad);
      capacidadFinal = nuevaCapacidad;
      hayCambios = true;
    }

    if (horaInicio != horarioInicioFinal) {
      horarioInicioFinal = horaInicio;
      await widget.espacio.updateHorarioIni(widget.espacio.nombre, horarioInicioFinal);
      hayCambios = true;
    }

    if (horaFin != horarioFinFinal) {
      horarioFinFinal = horaFin;
      if (horarioFinFinal.hour < horarioInicioFinal.hour ||
          (horarioFinFinal.hour == horarioInicioFinal.hour && horarioFinFinal.minute <= horarioInicioFinal.minute)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El horario de fin debe ser mayor que el de inicio')),
        );
        return;
      }
      await widget.espacio.updateHorarioFin(widget.espacio.nombre, horarioFinFinal);
      hayCambios = true;
    }

    if (!hayCambios) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se detectaron cambios válidos')),
      );
      return;
    }

    Espacio espacioActualizado = Espacio(
      nombre: nombreFinal,
      capacidad: capacidadFinal,
      horarioIni: horarioInicioFinal,
      horarioFin: horarioFinFinal,
      descripcion: descripcionFinal,
    );

    // await espacioActualizado.updateEspacio();  // Descomenta si tienes método
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambios guardados correctamente')),
    );
    Navigator.pop(context);
  }

  void _borrarEspacio() async {
    try {
      await widget.espacio.deleteEspacio(widget.espacio.nombre);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Espacio eliminado correctamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
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
              Row(
                children: [
                  IconButton(
                    iconSize: backIconSize,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'EDITAR ESPACIO',
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

              // Nombre
              Align(
                alignment: Alignment.centerLeft,
                child: const Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  hintText: 'Nombre del espacio',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 20),

              // Descripción
              Align(
                alignment: Alignment.centerLeft,
                child: const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: descripcionController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Descripción del espacio',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 20),

              // Capacidad
              Align(
                alignment: Alignment.centerLeft,
                child: const Text('Capacidad', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
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
              const SizedBox(height: 20),

              // Horarios
              Align(
                alignment: Alignment.centerLeft,
                child: const Text('Horario', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
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
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: double.infinity, // Para que ocupe todo el espacio disponible
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
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // BOTONES GUARDAR Y BORRAR
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _guardarCambios,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: const Text(
                        'Guardar',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _borrarEspacio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: const Text(
                        'Borrar Espacio',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

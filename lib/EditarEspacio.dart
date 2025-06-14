import 'package:flutter/material.dart';
import 'Espacio.dart';

// Clase para editar un espacio existente
// Permite modificar los campos del espacio y guardar los cambios en la base de datos
// También permite eliminar el espacio si es necesario
// 
class EditarEspacio extends StatefulWidget {
  final Espacio espacio;      // Espacio a editar, pasado como parámetro al constructor
  const EditarEspacio({super.key, required this.espacio});

  @override
  _EditarEspacioState createState() => _EditarEspacioState();
}

class _EditarEspacioState extends State<EditarEspacio> {
  final TextEditingController nombreController = TextEditingController();       // Controlador para el campo de nombre
  final TextEditingController descripcionController = TextEditingController();  // Controlador para el campo de descripción
  final TextEditingController capacidadController = TextEditingController();    // Controlador para el campo de capacidad

  late TimeOfDay horaInicio;    // Hora de inicio del horario del espacio
  late TimeOfDay horaFin;       // Hora de fin del horario del espacio

  // Inicializa los controladores y las horas de inicio y fin con los valores del espacio existente
  @override
  void initState() {
    super.initState();
    nombreController.text = widget.espacio.nombre;    // Inicializa el controlador de nombre con el nombre del espacio
    descripcionController.text = widget.espacio.descripcion;  // Inicializa el controlador de descripción con la descripción del espacio
    capacidadController.text = widget.espacio.capacidad.toString(); // Inicializa el controlador de capacidad con la capacidad del espacio
    horaInicio = widget.espacio.horarioIni; // Inicializa la hora de inicio con el horario de inicio del espacio
    horaFin = widget.espacio.horarioFin;  // Inicializa la hora de fin con el horario de fin del espacio
  }

  // Métodos para seleccionar las horas de inicio y fin utilizando un TimePicker
  // Muestra un selector de hora y actualiza la hora de inicio si se selecciona una hora válida.
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
  // Muestra un selector de hora y actualiza la hora de fin si se selecciona una hora válida.
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

  // Método para guardar los cambios realizados en el espacio
  // Verifica que los campos no estén vacíos y actualiza los valores en la base de datos
  // Si hay cambios, muestra un mensaje de éxito y regresa a la pantalla anterior
  // Si no hay cambios, muestra un mensaje indicando que no se detectaron cambios válidos
  //
  void guardarCambios() async {
    String nuevoNombre = nombreController.text.trim();              // Nombre ingresado por el administrador
    String nuevaDescripcion = descripcionController.text.trim();    // Descripción ingresada por el administrador
    String capacidadText = capacidadController.text.trim();         // Capacidad ingresada por el administrador

    String nombreFinal = widget.espacio.nombre;                 // Nombre actual del espacio
    String descripcionFinal = widget.espacio.descripcion;       // Descripción actual del espacio
    int capacidadFinal = widget.espacio.capacidad;              // Capacidad actual del espacio 
    TimeOfDay horarioInicioFinal = widget.espacio.horarioIni;   // Horario de inicio actual del espacio
    TimeOfDay horarioFinFinal = widget.espacio.horarioFin;      // Horario de fin actual del espacio

    bool hayCambios = false;    // Bandera para verificar si se realizaron cambios

    // Verificar y actualizar campos solo si se cambiaron y no están vacíos
    if (nuevoNombre.isNotEmpty && nuevoNombre != nombreFinal) {
      bool nombreActualizado = await widget.espacio.updateNombre(nombreFinal, nuevoNombre); // Actualiza el nombre del espacio en la base de datos
      if (nombreActualizado) {  // Si el nombre se actualizó correctamente
        nombreFinal = nuevoNombre;  // Actualiza el nombre final
        hayCambios = true;  // Marca que hay cambios
      } else {
        ScaffoldMessenger.of(context).showSnackBar( // Si no se pudo actualizar el nombre, muestra un mensaje de error
          const SnackBar(content: Text('No se pudo actualizar el nombre. Ya existe un espacio con ese nombre')),
        );
        return; // Salir y no continuar con otros cambios si falla el nombre
      }
    }

    if (nuevaDescripcion.isNotEmpty && nuevaDescripcion != descripcionFinal) {    // Verifica si la nueva descripción no está vacía y es diferente a la actual
      descripcionFinal = nuevaDescripcion;  // Actualiza la descripción final
      await widget.espacio.updateDescripcion(widget.espacio.nombre, descripcionFinal);  // Actualiza la descripción del espacio en la base de datos
      hayCambios = true;  // Marca que hay cambios
    }

    int? nuevaCapacidad = int.tryParse(capacidadText);  
    if (nuevaCapacidad != null && nuevaCapacidad != capacidadFinal) {   // Verifica si la nueva capacidad es un número válido y diferente a la actual
      if (nuevaCapacidad <= 0) {  // Verifica si la nueva capacidad es menor o igual a 0
        ScaffoldMessenger.of(context).showSnackBar(   // Si la capacidad es menor o igual a 0, muestra un mensaje de error
          const SnackBar(content: Text('La capacidad debe ser mayor a 0')),
        );
        return;
      }
      await widget.espacio.updateCapacidad(widget.espacio.nombre, nuevaCapacidad);  // Actualiza la capacidad del espacio en la base de datos
      capacidadFinal = nuevaCapacidad;  // Actualiza la capacidad final
      hayCambios = true;  // Marca que hay cambios
    }

    if (horaInicio != horarioInicioFinal) { // Verifica si la hora de inicio ha cambiado
      horarioInicioFinal = horaInicio;  // Actualiza la hora de inicio final
      await widget.espacio.updateHorarioIni(widget.espacio.nombre, horarioInicioFinal); // Actualiza la hora de inicio del espacio en la base de datos
      hayCambios = true;  // Marca que hay cambios
    }

    if (horaFin != horarioFinFinal) { // Verifica si la hora de fin ha cambiado
      horarioFinFinal = horaFin;  // Actualiza la hora de fin final
      if (horarioFinFinal.hour < horarioInicioFinal.hour ||
          (horarioFinFinal.hour == horarioInicioFinal.hour && horarioFinFinal.minute <= horarioInicioFinal.minute)) { // Verifica si la hora de fin es menor o igual a la de inicio
        ScaffoldMessenger.of(context).showSnackBar( // Si la hora de fin es menor o igual a la de inicio, muestra un mensaje de error
          const SnackBar(content: Text('El horario de fin debe ser mayor que el de inicio')), 
        );  
        return;
      }
      await widget.espacio.updateHorarioFin(widget.espacio.nombre, horarioFinFinal);  // Actualiza la hora de fin del espacio en la base de datos
      hayCambios = true;  // Marca que hay cambios
    }

    if (!hayCambios) {  // Si no se realizaron cambios válidos
      ScaffoldMessenger.of(context).showSnackBar(   // Muestra un mensaje indicando que no se detectaron cambios válidos
        const SnackBar(content: Text('No se detectaron cambios válidos')),  
      );
      return;
    }
    // Si se realizaron cambios, muestra un mensaje de éxito y regresa a la pantalla anterior
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambios guardados correctamente')),
    );
    Navigator.pop(context);
  }

  // Método para borrar el espacio actual
  // Elimina el espacio de la base de datos y muestra un mensaje de éxito o error
  void borrarEspacio() async {
    try {
      await widget.espacio.deleteEspacio(widget.espacio.nombre);    // Elimina el espacio de la base de datos
      ScaffoldMessenger.of(context).showSnackBar(   // Muestra un mensaje de éxito
        const SnackBar(content: Text('Espacio eliminado correctamente')), 
      );
      Navigator.pop(context); // Regresa a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( // Si ocurre un error al eliminar, muestra un mensaje de error
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  // Método para construir la interfaz de usuario del formulario de edición
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;    // Ancho de la pantalla
    final screenHeight = MediaQuery.of(context).size.height;  // Alto de la pantalla

    final double titleSize = screenWidth * 0.04;        // Tamaño del texto del título
    final double backIconSize = screenWidth * 0.025;    // Tamaño del icono de retroceso

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

              // Nombre Del Espacio
              Align(
                alignment: Alignment.centerLeft,
                child: const Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(  // Campo de texto para el nombre del espacio
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
              TextField(  // Campo de texto para la descripción del espacio
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
              TextField(  // Campo de texto para la capacidad del espacio
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
                      width: double.infinity, 
                      child: ElevatedButton(    // Botón para seleccionar la hora de inicio
                        onPressed: () => _seleccionarHoraInicio(context),   // Muestra el selector de hora para la hora de inicio
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
                              '${horaInicio.hour.toString().padLeft(2, '0')}:${horaInicio.minute.toString().padLeft(2, '0')}',  // Formatea la hora de inicio para mostrarla en el botón
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
                      width: double.infinity,
                      child: ElevatedButton(  // Botón para seleccionar la hora de fin
                        onPressed: () => _seleccionarHoraFin(context),  // Muestra el selector de hora para la hora de fin
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
                              '${horaFin.hour.toString().padLeft(2, '0')}:${horaFin.minute.toString().padLeft(2, '0')}',  // Formatea la hora de fin para mostrarla en el botón
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
                    ElevatedButton(   // Botón para guardar los cambios realizados en el espacio
                      onPressed: guardarCambios,  // Llama al método para guardar los cambios
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
                    ElevatedButton( // Botón para borrar el espacio actual
                      onPressed: borrarEspacio, // Llama al método para borrar el espacio
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

import 'package:flutter/material.dart';
import 'Espacio.dart';

// Pantalla para crear un nuevo espacio
// Esta pantalla permite al usuario ingresar los detalles del espacio, como nombre, descripción, capacidad y horarios de inicio y fin.
// Al presionar el botón "Crear Espacio", se valida la información ingresada y se crea un nuevo espacio si todo es correcto.
//
class CrearEspacio extends StatefulWidget {
  @override
  crearEspacioState createState() => crearEspacioState();
}

class crearEspacioState extends State<CrearEspacio> {
  final TextEditingController nombreController = TextEditingController();         // Controlador para el campo de nombre del espacio
  final TextEditingController descripcionController = TextEditingController();    // Controlador para el campo de descripción del espacio
  final TextEditingController capacidadController = TextEditingController();      // Controlador para el campo de capacidad del espacio

  TimeOfDay horaInicio = TimeOfDay.now();   // Hora de inicio del espacio, inicializada a la hora actual
  TimeOfDay horaFin = TimeOfDay.now();      // Hora de fin del espacio, inicializada a la hora actual

  // Método para seleccionar la hora de inicio del espacio
  // Muestra un selector de hora y actualiza la hora de inicio si se selecciona una hora válida.
  Future<void> seleccionarHoraInicio(BuildContext context) async {
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

  // Método para seleccionar la hora de fin del espacio
  // Muestra un selector de hora y actualiza la hora de fin si se selecciona una hora válida.
  Future<void> seleccionarHoraFin(BuildContext context) async {
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

  // Método para crear un nuevo espacio
  // Valida los campos ingresados y crea un nuevo espacio si todo es correcto.
  // Si el espacio ya existe, muestra un mensaje de error.
  // Si hay algún campo vacío o inválido, muestra un mensaje de error.
  // Al finalizar, cierra la pantalla actual y regresa a la pantalla anterior.
  void crearEspacio() async {
    final nombre = nombreController.text.trim();                        // Obtener el nombre del espacio ingresado    
    final descripcion = descripcionController.text.trim();              // Obtener la descripción del espacio ingresada
    final capacidad = int.tryParse(capacidadController.text.trim());    // Obtener la capacidad del espacio ingresada y la convierte a entero

    if (nombre.isEmpty || descripcion.isEmpty || capacidad == null) {     // Validar que todos los campos estén completos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),  // Mostrar mensaje de error si algún campo está vacío
      );
      return;
    }
    bool existeEspacio = await Espacio.existeEspacio(nombre);     // Verificar si ya existe un espacio con el mismo nombre
    if (existeEspacio) {                                          // Si el espacio ya existe, mostrar un mensaje de error           
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya existe un espacio con ese nombre')),
      );
      return;
    }

    Espacio nuevoEspacio = Espacio(     // Crear una nueva instancia de Espacio con los datos ingresados
      nombre: nombre,
      capacidad: capacidad,
      horarioIni: horaInicio,
      horarioFin: horaFin,
      descripcion: descripcion,
    );

    await nuevoEspacio.addEspacio(nombre, capacidad, horaInicio, horaFin, descripcion); // Agregar el nuevo espacio a la base de datos
    Navigator.pop(context); // Cerrar la pantalla actual y regresar a la pantalla anterior
  }


  // Método para construir la interfaz de usuario de la pantalla CrearEspacio
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;        // Obtener el ancho de la pantalla
    final screenHeight = MediaQuery.of(context).size.height;      // Obtener la altura de la pantalla

    final double titleSize = screenWidth * 0.04;                // Tamaño del texto del título
    final double backIconSize = screenWidth * 0.025;            // Tamaño del icono de retroceso

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
                // FORMULARIO DE CREACIÓN DE ESPACIO
                const Text('Nombre'),
                TextField(                        // Campo de texto para ingresar el nombre del espacio
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
                TextField(                        // Campo de texto para ingresar la descripción del espacio        
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
                TextField(                        // Campo de texto para ingresar la capacidad del espacio
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
                            width: double.infinity, 
                            child: ElevatedButton(          // Botón para seleccionar la hora de inicio
                              onPressed: () => seleccionarHoraInicio(context),  // Llama al método para seleccionar la hora de inicio
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
                                  Text( // Muestra la hora de inicio seleccionada
                                    '${horaInicio.hour.toString().padLeft(2, '0')}:${horaInicio.minute.toString().padLeft(2, '0')}',  // Formatea la hora para mostrarla con dos dígitos
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
                            child: ElevatedButton(      // Botón para seleccionar la hora de fin
                              onPressed: () => seleccionarHoraFin(context), // Llama al método para seleccionar la hora de fin
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
                                  Text( // Muestra la hora de fin seleccionada
                                    '${horaFin.hour.toString().padLeft(2, '0')}:${horaFin.minute.toString().padLeft(2, '0')}',  // Formatea la hora para mostrarla con dos dígitos
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
                    onPressed: crearEspacio, // Llama al método para crear el espacio
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

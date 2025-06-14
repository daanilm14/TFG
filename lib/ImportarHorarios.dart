import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'Reserva.dart';

// Clase para importar horarios desde un archivo de texto
// Esta clase permite al usuario seleccionar un archivo de texto con reservas y subirlas a la base de datos
class ImportarHorarios extends StatefulWidget {
  const ImportarHorarios({super.key});

  @override
  State<ImportarHorarios> createState() => _ImportarHorariosState();
}

class _ImportarHorariosState extends State<ImportarHorarios> {
  String? _filePath;                                      // Ruta del archivo seleccionado
  List<Map<String, String>> reservasImportadas = [];      // Lista para almacenar las reservas importadas
  bool _subiendo = false;                                 // Indicador de si se está subiendo información

  // Método para seleccionar un archivo de texto
  // Este método usa el paquete file_picker para permitir al usuario seleccionar un archivo .txt
  // El archivo debe tener un formato específico: cada línea debe contener 7 campos separados por '|'
  // Los campos son: descripción, estado, evento, fecha, hora, id_espacio, id_usuario
  // Si el archivo se selecciona correctamente, se lee su contenido y se parsea
  // Si hay algún error en el formato, se muestra un mensaje en la consola
  Future<void> seleccionarArchivo() async {
    final result = await FilePicker.platform.pickFiles(   // Selecciona un archivo
      type: FileType.custom,                              // Permite seleccionar archivos personalizados
      allowedExtensions: ['txt'],                         // Solo permite archivos con extensión .txt
      withData: true,                                     // Permite obtener los bytes del archivo seleccionado
    );

    // Verifica si se seleccionó un archivo
    if (result != null) {
      final fileName = result.files.single.name;  // Obtiene el nombre del archivo seleccionado
      if (!fileName.toLowerCase().endsWith('.txt')) { // Verifica si el archivo tiene la extensión .txt
        ScaffoldMessenger.of(context).showSnackBar(   // Muestra un mensaje si el archivo no es .txt
          const SnackBar(content: Text('Por favor, seleccione un archivo con extensión .txt')),
        );
        return;
      }
      if (result.files.single.bytes != null) {  // Verifica si el archivo tiene bytes disponibles
        final fileBytes = result.files.single.bytes!;       // Obtiene los bytes del archivo
        final contenido = String.fromCharCodes(fileBytes);  // Convierte los bytes a una cadena de texto
        await leerArchivoYParsear(contenido);              // Llama al método para leer y parsear el contenido del archivo
        setState(() {                                       // Actualiza el estado del widget para reflejar el archivo seleccionado   
          _filePath = fileName;
        });
      }
    }
  }
  // Método para leer el contenido del archivo y parsearlo
  // Este método recibe el contenido del archivo como una cadena de texto
  // Divide el contenido en líneas y luego en campos separados por '|'
  // Crea un mapa para cada reserva con los campos correspondientes
  Future<void> leerArchivoYParsear(String contenido) async {
    try {
      final lines = contenido.split('\n');        // Divide el contenido en líneas

      reservasImportadas.clear();                 // Limpia la lista de reservas importadas antes de agregar nuevas

      for (final lineRaw in lines) {              // Itera sobre cada línea del contenido
        final line = lineRaw.trim();              // Elimina espacios en blanco al inicio y al final de la línea  
        if (line.isEmpty) continue;               // Ignorar líneas vacías

        final campos = line.split('|');           // Divide la línea en campos usando el separador '|'

        if (campos.length != 7) {                 // Verifica que la línea tenga exactamente 7 campos
          print('Línea con formato incorrecto (campos: ${campos.length}): "$line"');  // Imprime un mensaje de error si la línea no tiene 7 campos
          continue; // Saltar línea mal formada
        }

        // Crea un mapa para la reserva con los campos correspondientes
        final reserva = {
          'descripcion': campos[0].trim(),
          'estado': campos[1].trim(),
          'evento': campos[2].trim(),
          'fecha': campos[3].trim(),
          'hora': campos[4].trim(),
          'id_espacio': campos[5].trim(),
          'id_usuario': campos[6].trim(),
        };

        reservasImportadas.add(reserva);  // Agrega la reserva al listado de reservas importadas
      }
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( // Muestra un mensaje de error si ocurre algún problema al leer el archivo
        SnackBar(content: Text('Error al leer archivo: $e')),
      );
    }
  }



  // Método para parsear la hora desde una cadena de texto
  TimeOfDay _parseHora(String horaStr) {
    final parts = horaStr.split(':');                                   // Divide la cadena en partes usando ':' como separador
    if (parts.length != 2) return const TimeOfDay(hour: 0, minute: 0);  // Si no tiene exactamente 2 partes, retorna una hora por defecto (00:00)
    final hour = int.tryParse(parts[0]) ?? 0;                           // Intenta parsear la primera parte como hora, si falla, usa 0
    final minute = int.tryParse(parts[1]) ?? 0;                         // Intenta parsear la segunda parte como minuto, si falla, usa 0           
    return TimeOfDay(hour: hour, minute: minute);                       // Retorna un objeto TimeOfDay con la hora y minuto parseados
  }

  // Método para subir las reservas importadas a la base de dato
  Future<void> subirReservas() async {
    if (reservasImportadas.isEmpty) {     // Verifica si hay reservas para importar
      ScaffoldMessenger.of(context).showSnackBar( // Muestra un mensaje si no hay reservas para importar
        const SnackBar(content: Text('No hay reservas para importar')),
      );
      return;
    }
    
    setState(() => _subiendo = true); // Cambia el estado a subiendo para deshabilitar el botón de importación

    int exitos = 0;   // Contador de reservas importadas exitosamente
    int errores = 0;  // Contador de errores al importar reservas

    for (final reserva in reservasImportadas) { // Itera sobre cada reserva importada
      try {
        final descripcion = reserva['descripcion'] ?? '';
        final estado = reserva['estado'] ?? 'pendiente';
        final evento = reserva['evento'] ?? '';
        final fecha = reserva['fecha'] ?? '';
        final horaStr = reserva['hora'] ?? '00:00';
        final id_espacio = reserva['id_espacio'] ?? '';
        final id_usuario = reserva['id_usuario'] ?? '';
        final hora = _parseHora(horaStr);

        // Llama al método addReserva de la clase Reserva para agregar la reserva a la base de datos
        await Reserva.addReserva(id_usuario, id_espacio, fecha, hora, evento, descripcion, estado); 
        exitos++; // Incrementa el contador de éxitos si la reserva se agrega correctamente
      } catch (e) {
        errores++;  // Incrementa el contador de errores si ocurre un problema al agregar la reserva
        print('Error importando reserva: $e');
      }
    }

    setState(() => _subiendo = false);

    ScaffoldMessenger.of(context).showSnackBar( // Muestra un mensaje al usuario con el resultado de la importación
      SnackBar(
        content: Text('Importación completada: $exitos éxitos, $errores errores.'),
      ),
    );

    Navigator.pop(context);
  }

  // Método para construir un botón con texto e ícono
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;        // Ancho de la pantalla
    final screenHeight = MediaQuery.of(context).size.height;      // Altura de la pantalla
    final double titleSize = screenWidth * 0.04;                  // Tamaño del título 
    final double backIconSize = screenWidth * 0.025;              // Tamaño del ícono de retroceso

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: SingleChildScrollView(
            child: Column(
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
                          'IMPORTAR HORARIOS',
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

                // BOTÓN PARA SELECCIONAR ARCHIVO
                ElevatedButton.icon(  
                  onPressed: _subiendo ? null : seleccionarArchivo, // Deshabilita el botón si se está subiendo información
                  icon: const Icon(Icons.file_open),
                  label: const Text('Seleccionar archivo de texto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),

                // RUTA DEL ARCHIVO
                Text(
                  _filePath == null
                      ? 'No se ha seleccionado archivo.'
                      : 'Archivo seleccionado: $_filePath',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 24),

                // INDICADOR DE RESERVAS IMPORTADAS
                if (reservasImportadas.isNotEmpty)
                  Text(
                    'Número de reservas: ${reservasImportadas.length}', 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[700],
                    ),
                  ),
                const SizedBox(height: 24),

                // BOTÓN IMPORTAR A FIREBASE
                ElevatedButton.icon(
                  onPressed: _subiendo ? null : subirReservas,  // Deshabilita el botón si se está subiendo información
                  icon: _subiendo   
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color.fromARGB(255, 0, 0, 0)),
                        )
                      : const Icon(Icons.upload),
                  label: Text(_subiendo ? 'Subiendo...' : 'Importar a Firebase'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

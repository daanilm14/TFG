import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'Reserva.dart';

class ImportarHorarios extends StatefulWidget {
  const ImportarHorarios({super.key});

  @override
  State<ImportarHorarios> createState() => _ImportarHorariosState();
}

class _ImportarHorariosState extends State<ImportarHorarios> {
  String? _filePath;
  List<Map<String, String>> reservasImportadas = [];
  bool _subiendo = false;

  Future<void> _seleccionarArchivo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
      withData: true, // Necesario para web
    );

    if (result != null && result.files.single.bytes != null) {
      final fileBytes = result.files.single.bytes!;
      final contenido = String.fromCharCodes(fileBytes);
      await _leerArchivoYParsear(contenido);
      setState(() {
        _filePath = result.files.single.name;
      });
    }
  }

  Future<void> _leerArchivoYParsear(String contenido) async {
    try {
      final lines = contenido.split('\n');

      reservasImportadas.clear();

      for (final lineRaw in lines) {
        final line = lineRaw.trim();
        if (line.isEmpty) continue; // Ignorar líneas vacías

        final campos = line.split('|');

        if (campos.length != 7) {
          print('Línea con formato incorrecto (campos: ${campos.length}): "$line"');
          continue; // Saltar línea mal formada
        }

        final reserva = {
          'descripcion': campos[0].trim(),
          'estado': campos[1].trim(),
          'evento': campos[2].trim(),
          'fecha': campos[3].trim(),
          'hora': campos[4].trim(),
          'id_espacio': campos[5].trim(),
          'id_usuario': campos[6].trim(),
        };

        reservasImportadas.add(reserva);
      }
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al leer archivo: $e')),
      );
    }
  }




  TimeOfDay _parseHora(String horaStr) {
    final parts = horaStr.split(':');
    if (parts.length != 2) return const TimeOfDay(hour: 0, minute: 0);
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _subirReservas() async {
    if (reservasImportadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay reservas para importar')),
      );
      return;
    }

    setState(() => _subiendo = true);

    int exitos = 0;
    int errores = 0;

    for (final reserva in reservasImportadas) {
      try {
        final descripcion = reserva['descripcion'] ?? '';
        final estado = reserva['estado'] ?? 'pendiente';
        final evento = reserva['evento'] ?? '';
        final fecha = reserva['fecha'] ?? '';
        final horaStr = reserva['hora'] ?? '00:00';
        final id_espacio = reserva['id_espacio'] ?? '';
        final id_usuario = reserva['id_usuario'] ?? '';
        final hora = _parseHora(horaStr);

        await Reserva.addReserva(id_usuario, id_espacio, fecha, hora, evento, descripcion, estado);
        exitos++;
      } catch (e) {
        errores++;
        print('Error importando reserva: $e');
      }
    }

    setState(() => _subiendo = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Importación completada: $exitos éxitos, $errores errores.'),
      ),
    );

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
                  onPressed: _subiendo ? null : _seleccionarArchivo,
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
                  onPressed: _subiendo ? null : _subirReservas,
                  icon: _subiendo
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
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

import 'package:flutter/material.dart';
import 'package:tfg/Usuario.dart';
import 'package:intl/intl.dart';
import 'Espacio.dart';
import 'Reserva.dart';
import 'GestionAdmin.dart';
import 'RealizarReserva.dart';

class HomeAdmin extends StatefulWidget {
  final Usuario usuario;
  const HomeAdmin({super.key, required this.usuario});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  DateTime _selectedDate = DateTime.now();
  late Future<List<Espacio>> _espaciosFuture;
  late Future<List<Reserva>> _reservasFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    Espacio espacio = Espacio(
      capacidad: 0,
      horarioIni: TimeOfDay.now(),
      horarioFin: TimeOfDay.now(),
      nombre: '',
      descripcion: '',
    );
    _espaciosFuture = espacio.getEspacios();
    String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);
    _reservasFuture = Reserva.getReservasPorFecha(formattedDate);
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
      _loadData();
    });
  }

  String _formatHora(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  List<String> _generateHoras(TimeOfDay ini, TimeOfDay fin) {
    List<String> horas = [];
    for (int h = ini.hour; h < fin.hour; h++) {
      horas.add('${h.toString().padLeft(2, '0')}:00');
    }
    return horas;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      _onDateChanged(picked);
    }
  }

  Widget _buildTable(List<Espacio> espacios, List<Reserva> reservas) {
    Set<String> allHoras = {};
    Map<String, List<String>> espacioHoras = {};

    for (var espacio in espacios) {
      final horas = _generateHoras(espacio.horarioIni, espacio.horarioFin);
      espacioHoras[espacio.nombre] = horas;
      allHoras.addAll(horas);
    }

    final sortedHoras = allHoras.toList()..sort();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        border: TableBorder.all(color: Colors.grey, width: 1),
        columns: [
          const DataColumn(label: Text('Espacio')),
          ...sortedHoras.map((hora) => DataColumn(label: Text(hora))).toList(),
        ],
        rows: espacios.map((espacio) {
          final horasEspacio = espacioHoras[espacio.nombre]!;
          return DataRow(cells: [
            DataCell(Text(espacio.nombre)),
            ...sortedHoras.map((hora) {
              if (!horasEspacio.contains(hora)) {
                return const DataCell(Text('-'));
              }

              final reserva = reservas.firstWhere(
                (res) =>
                    res.id_espacio == espacio.nombre &&
                    res.hora == TimeOfDay(
                      hour: int.parse(hora.split(':')[0]),
                      minute: int.parse(hora.split(':')[1]),
                    ),
                orElse: () => Reserva(
                  id_espacio: '',
                  fecha: '',
                  hora: TimeOfDay(hour: 0, minute: 0),
                  evento: '',
                  id_usuario: '',
                  descripcion: '',
                  estado: '',
                ),
              );

              final bool hayReserva = reserva.id_espacio.isNotEmpty;

              if (hayReserva) {
                return DataCell(Container(
                  color: Colors.redAccent,
                  alignment: Alignment.center,
                  child: Text(
                    reserva.evento,
                    style: const TextStyle(color: Colors.white),
                  ),
                ));
              } else {
                return DataCell(
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RealizarReserva(
                              usuario: widget.usuario,
                              espacio: espacio,
                              fecha: DateFormat('dd/MM/yyyy').format(_selectedDate),
                              hora: TimeOfDay(
                                hour: int.parse(hora.split(':')[0]),
                                minute: int.parse(hora.split(':')[1]),
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                );
              }
            }).toList(),
          ]);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double titleSize = screenWidth * 0.04;
    final double fontSize = screenWidth * 0.015;
    final double iconContainerSize = titleSize * 1.2;
    final double iconSize = titleSize * 0.6;

    String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.005,
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: iconContainerSize),
                Expanded(
                  child: Center(
                    child: Text(
                      'ADMINISTRACIÓN',
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GestionAdmin(usuario: widget.usuario),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: titleSize * 0.2),
                        width: iconContainerSize,
                        height: iconContainerSize,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.settings, color: Colors.black, size: iconSize),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.usuario.nombre,
                        style: TextStyle(fontSize: fontSize, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Fecha:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Text(formattedDate,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Seleccionar fecha'),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.02),

            Expanded(
              child: FutureBuilder<List<Espacio>>(
                future: _espaciosFuture,
                builder: (context, snapshotEspacios) {
                  if (snapshotEspacios.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshotEspacios.hasData ||
                      snapshotEspacios.data!.isEmpty) {
                    return const Center(child: Text('No hay espacios disponibles'));
                  }

                  return FutureBuilder<List<Reserva>>(
                    future: _reservasFuture,
                    builder: (context, snapshotReservas) {
                      if (snapshotReservas.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final espacios = snapshotEspacios.data!;
                      final reservas = snapshotReservas.data ?? [];

                      return _buildTable(espacios, reservas);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  // Fecha seleccionada, por defecto hoy
  DateTime _selectedDate = DateTime.now();

  // Lista de espacios y reservas
  Future<List<Espacio>> espacios = Future.value([]);
  Future<List<Reserva>> reservas = Future.value([]);

  // Controladores para scroll horizontal y vertical en la tabla
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData(); // Carga inicial de datos al iniciar
  }

  @override
  void dispose() {
    // Liberar recursos de los controladores al destruir el widget
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  // Carga datos de espacios y reservas según la fecha seleccionada
  void _loadData() {
    espacios = Espacio.getEspacios();
    String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);
    reservas = Reserva.getReservasPorFecha(formattedDate);
  }

  // Actualiza la fecha seleccionada y recarga los datos en caso de que se cambie 
  // la fecha en el selector.
  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
      _loadData();
    });
  }

  // Genera una lista de horas en formato string entre ini y fin (horas completas)
  List<String> _generateHoras(TimeOfDay ini, TimeOfDay fin) {
    List<String> horas = [];
    for (int h = ini.hour; h < fin.hour; h++) {
      horas.add('${h.toString().padLeft(2, '0')}:00');
    }
    return horas;
  }

  // Muestra un selector de fecha y actualiza la fecha seleccionada
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

  // Construye la tabla con horarios y espacios, marcando reservas y disponibilidad
  Widget _buildTable(List<Espacio> espacios, List<Reserva> reservas) {
    Set<String> allHoras = {};
    Map<String, List<String>> espacioHoras = {};

    // Para cada espacio, generamos las horas disponibles y las almacenamos
    for (var espacio in espacios) {
      final horas = _generateHoras(espacio.horarioIni, espacio.horarioFin);
      espacioHoras[espacio.id_espacio ?? ''] = horas;
      allHoras.addAll(horas);
    }

    // Ordenamos las horas para mostrar columnas en orden
    final sortedHoras = allHoras.toList()..sort();

    return Scrollbar(
      controller: _verticalScrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: SingleChildScrollView(
        controller: _verticalScrollController,
        scrollDirection: Axis.vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna fija con nombres de espacios
            Column(
              children: [
                const SizedBox(height: 48), // Espacio para la cabecera de horas
                ...espacios.map((espacio) => Container(
                      width: 160,
                      height: 48,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.grey.shade100,
                      ),
                      child: Text(
                        espacio.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    )),
              ],
            ),
            const SizedBox(width: 2),
            // Tabla horizontal con horas y celdas de reservas/disponibilidad
            Expanded(
              child: Scrollbar(
                controller: _horizontalScrollController,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      // Cabecera con horas
                      Row(
                        children: sortedHoras.map((hora) {
                          return Container(
                            width: 100,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.blueGrey.shade50,
                            ),
                            child: Text(
                              hora,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          );
                        }).toList(),
                      ),
                      // Filas con celdas por espacio y hora
                      ...espacios.map((espacio) {
                        final horasEspacio = espacioHoras[espacio.id_espacio]!;

                        return Row(
                          children: sortedHoras.map((hora) {
                            final isDisponible = horasEspacio.contains(hora);

                            // Buscar si existe una reserva para ese espacio y hora
                            final reserva = reservas.firstWhere(
                              (res) =>
                                  res.id_espacio == espacio.id_espacio &&
                                  res.hora == TimeOfDay(
                                      hour: int.parse(hora.split(':')[0]),
                                      minute: int.parse(hora.split(':')[1])),
                              orElse: () => Reserva(
                                id_espacio: '',
                                fecha: '',
                                hora: const TimeOfDay(hour: 0, minute: 0),
                                evento: '',
                                id_usuario: '',
                                descripcion: '',
                                estado: '',
                              ),
                            );

                            // Condición de que una reserva esté aceptada
                            final bool hayReserva = reserva.estado == 'aceptada';

                            return Container(
                              width: 100,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                color: !isDisponible
                                    ? Colors.grey.shade200 // No disponible
                                    : hayReserva
                                        ? Colors.red.shade400 // Reserva aceptada
                                        : Colors.green.shade400, // Disponible
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: !isDisponible
                                  ? const Icon(Icons.block, color: Colors.grey)
                                  : hayReserva
                                      ? Tooltip(
                                          message: reserva.descripcion,
                                          child: Text(
                                            reserva.evento,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.add,
                                              color: Colors.white),
                                          // Permite hacer reserva para hora/espacio disponibles
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RealizarReserva(
                                                  usuario: widget.usuario,
                                                  espacio: espacio,
                                                  fecha: DateFormat('dd/MM/yyyy')
                                                      .format(_selectedDate),
                                                  hora: TimeOfDay(
                                                    hour: int.parse(
                                                        hora.split(':')[0]),
                                                    minute: int.parse(
                                                        hora.split(':')[1]),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Tamaños relativos para texto e íconos según pantalla
    final double titleSize = screenWidth * 0.04;
    final double fontSize = screenWidth * 0.015;
    final double iconContainerSize = titleSize * 1.2;
    final double iconSize = titleSize * 0.6;

    String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.005,
          ),
          child: Column(
            children: [
              // Cabecera con título y botón para gestionar administración
              Row(
                children: [
                  SizedBox(width: iconContainerSize), // Espacio para balancear el layout
                  Expanded(
                    child: Center(
                      child: Text(
                        'ADMINISTRACIÓN',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  // Botón para navegar a Gestión Admin
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
                          'GESTIÓN',
                          style: TextStyle(fontSize: fontSize, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),

              // Selector de fecha y botón para abrir calendario
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Fecha:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        )
                      ],
                    ),
                    child: Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade700,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today, size: 20),
                    label: const Text('Seleccionar fecha'),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              // Contenedor principal para la tabla de espacios y reservas
              Expanded(
                child: FutureBuilder<List<Espacio>>(
                  future: espacios,
                  builder: (context, snapshotEspacios) {
                    if (snapshotEspacios.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshotEspacios.hasData || snapshotEspacios.data!.isEmpty) {
                      return const Center(child: Text('No hay espacios disponibles'));
                    }

                    return FutureBuilder<List<Reserva>>(
                      future: reservas,
                      builder: (context, snapshotReservas) {
                        if (snapshotReservas.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final espacios = snapshotEspacios.data!;
                        final reservas = snapshotReservas.data ?? [];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: Colors.blueGrey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: _buildTable(espacios, reservas),
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

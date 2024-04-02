import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistrarInasistencia extends StatefulWidget {
  final String nombres;
  final String grado;
  final String docente;
  final String asignatura;
  const RegistrarInasistencia(
      {super.key,
      required this.nombres,
      required this.grado,
      required this.docente,
      required this.asignatura});

  @override
  State<RegistrarInasistencia> createState() => _RegistrarInasistenciaState();
}

class _RegistrarInasistenciaState extends State<RegistrarInasistencia> {
  String horass = '';
  String horaClase = '';
  int detalleCount = 0;
  final TextEditingController _fechaController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final TextEditingController _detalleController = TextEditingController();
  List<String> horas = [
    'Cuantas Horas faltó el estudiante',
    '1',
    '2',
    '3',
    '4',
    'Fuga',
    'Retardo'
  ];
  late final List<DropdownMenuItem> _horas;

  List<String> horasClase = [
    'Hora Clase',
    'Primera Hora',
    'Segunda Hora',
    'Tercera Hora',
    'Cuarta Hora',
    'Quinta Hora',
    'Sexta Hora',
    'Séptima Hora',
    'Octava Hora'
  ];
  late final List<DropdownMenuItem> _horasClase;

  @override
  void initState() {
    super.initState();
    _horas = horas
        .map((e) => DropdownMenuItem(
              value: !e.contains('Cuantas') ? e[0] : '',
              enabled: !e.contains('Cuantas') ? true : false,
              child: Text(e.contains('Cuantas') ||
                      e.contains('Fuga') ||
                      e.contains('Retardo')
                  ? e
                  : e[0]),
            ))
        .toList();
    _horasClase = horasClase
        .map((e) => DropdownMenuItem(
              value: e.contains('Clase') ? '' : e,
              enabled: !e.contains('Clase') ? true : false,
              child: Text(e),
            ))
        .toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      _fechaController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Widget _buildDatePicker() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _fechaController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Fecha',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        title: const Text('Inasistencia'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                '${widget.nombres} ${widget.grado}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                widget.asignatura,
                style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: _buildDatePicker(),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: DropdownButton(
                  value: horass,
                  items: _horas,
                  onChanged: (value) {
                    setState(() => horass = value);
                  },
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: DropdownButton(
                  value: horaClase,
                  items: _horasClase,
                  onChanged: (value) {
                    setState(() => horaClase = value);
                  },
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalle',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      onChanged: (value) {
                        detalleCount = value.length;
                        setState(() {});
                      },
                      maxLines: 3,
                      controller: _detalleController,
                      decoration: InputDecoration(
                          hoverColor: Colors.yellow,
                          border: const OutlineInputBorder(),
                          fillColor: Colors.yellow,
                          counter: Text(
                            '${detalleCount.toString()} de Mínimo  20 Caracteres',
                            style: TextStyle(
                                color: detalleCount >= 20
                                    ? Colors.blue
                                    : Colors.red,
                                fontSize: 10),
                          )),
                      autocorrect: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            iconColor: MaterialStatePropertyAll(Colors.black),
                            elevation: MaterialStatePropertyAll(Checkbox.width),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.indigoAccent),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        onPressed: () async {},
                        child: SizedBox(
                          width: 0.6 * MediaQuery.of(context).size.width,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Registrar Inasistencia'),
                              Icon(
                                Icons.sick,
                                size: 30,
                                color: Color.fromARGB(255, 254, 204, 221),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

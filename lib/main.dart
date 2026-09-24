import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tablero de tareas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const TableroTareasPage(),
    );
  }
}

class TableroTareasPage extends StatefulWidget {
  const TableroTareasPage({super.key});

  @override
  State<TableroTareasPage> createState() => _TableroTareasPageState();
}

class _TableroTareasPageState extends State<TableroTareasPage> {
  final List<Map<String, dynamic>> _tareas = [
    {'title': 'Subir captura de la lista viva', 'completada': false},
    {'title': 'Responder autoevaluación', 'completada': false},
    {'title': 'Revisar actividad con el docente', 'completada': false},
    {'title': 'Preparar repositorio público', 'completada': false},
    {'title': 'Entregar captura aprobada', 'completada': false},
    {'title': 'Explicar el manejo del estado', 'completada': false},
  ];

  bool _soloPendientes = false;
  int _contadorNuevasTareas = 1;

  void _cambiarEstado(int indice) {
    setState(() {
      _tareas[indice]['completada'] = !_tareas[indice]['completada'];
    });
  }

  void _eliminarTarea(int indice) {
    setState(() {
      _tareas.removeAt(indice);
    });
  }

  // Agrega directamente "Nueva tarea" sin mostrar un diálogo o pedir nombre
  void _agregarTarea() {
    setState(() {
      _tareas.add({
        'title': 'Nueva tarea $_contadorNuevasTareas',
        'completada': false,
      });
      _contadorNuevasTareas++;
    });
  }

  @override
  Widget build(BuildContext context) {
    int completadas = 0;
    for (var tarea in _tareas) {
      if (tarea['completada'] == true) {
        completadas++;
      }
    }

    List<int> indicesVisibles = [];
    for (var i = 0; i < _tareas.length; i++) {
      if (!_soloPendientes || _tareas[i]['completada'] == false) {
        indicesVisibles.add(i);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipo 10A - Tareas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Completadas: $completadas / ${_tareas.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Text('Solo pendientes'),
                Switch(
                  value: _soloPendientes,
                  onChanged: (valor) {
                    setState(() {
                      _soloPendientes = valor;
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: indicesVisibles.length,
              itemBuilder: (context, indiceVisible) {
                int indiceReal = indicesVisibles[indiceVisible];
                Map<String, dynamic> tarea = _tareas[indiceReal];
                bool completada = tarea['completada'];

                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: completada,
                      onChanged: (valor) => _cambiarEstado(indiceReal),
                    ),
                    title: Text(
                      tarea['title'],
                      style: TextStyle(
                        decoration: completada
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: 'Eliminar ${tarea['title']}',
                      onPressed: () => _eliminarTarea(indiceReal),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Agregar tarea',
        onPressed: _agregarTarea,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }
}
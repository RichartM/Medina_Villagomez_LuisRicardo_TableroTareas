import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:actividad_01_tablero_de_tareas_del_equipo/main.dart';

void main() {
  testWidgets('Muestra las tareas y el contador inicial', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Equipo 10A - Tareas'), findsOneWidget);
    expect(find.text('Completadas: 0 / 6'), findsOneWidget);
    expect(find.text('Subir captura de la lista viva'), findsOneWidget);
  });

  testWidgets('Marcar una tarea actualiza el contador y la vista', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    expect(find.text('Completadas: 1 / 6'), findsOneWidget);
    expect(
      find.byType(Checkbox).first.evaluate().single.widget,
      isA<Checkbox>().having((checkbox) => checkbox.value, 'value', true),
    );
  });

  testWidgets('El filtro muestra solamente tareas pendientes', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(find.text('Subir captura de la lista viva'), findsNothing);
    expect(find.text('Responder autoevaluación'), findsOneWidget);
  });

  testWidgets('Permite agregar una tarea nueva', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Agregar tarea'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Nueva tarea de prueba');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Agregar'));
    await tester.pumpAndSettle();

    expect(find.text('Nueva tarea de prueba'), findsOneWidget);
    expect(find.text('Completadas: 0 / 7'), findsOneWidget);
  });

  testWidgets('Permite eliminar una tarea', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Eliminar Responder autoevaluación'));
    await tester.pump();

    expect(find.text('Responder autoevaluación'), findsNothing);
    expect(find.text('Completadas: 0 / 5'), findsOneWidget);
  });
}

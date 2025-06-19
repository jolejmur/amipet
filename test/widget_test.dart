import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ami_pet_app/main.dart';

void main() {
  testWidgets('Pet Care app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our welcome text is present.
    expect(find.text('Bienvenido a Pet Care'), findsOneWidget);
    expect(find.text('Tu app para el cuidado de mascotas'), findsOneWidget);
    
    // Verify that the pet icon is present.
    expect(find.byIcon(Icons.pets), findsOneWidget);
  });
}

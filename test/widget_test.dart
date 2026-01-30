import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:comando_de_voz/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Reconhecimento de Voz'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart'; // Necessário para o TextFormField
import 'package:ambientese/login_screen.dart';

void main() {
  testWidgets('Login screen renders correctly', (WidgetTester tester) async {
    // Remover o 'const' se necessário
    await tester.pumpWidget(LoginScreen());

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.byType(TextFormField),
        findsNWidgets(2)); // Confirma que há dois campos de texto
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ambientese/login_screen.dart';

void main() {
  testWidgets('user can fill out email and password fields',
      (WidgetTester tester) async {
    // Carrega a tela de login sem o 'const' no construtor
    await tester.pumpWidget(MaterialApp(
      home: LoginScreen(), // Remova o 'const' aqui
    ));

    // Preenche o campo de email
    await tester.enterText(find.byKey(Key('email_field')), 'user@example.com');
    // Preenche o campo de senha
    await tester.enterText(find.byKey(Key('password_field')), 'password123');

    // Verifica se o texto foi inserido corretamente nos campos
    expect(find.byKey(Key('email_field')), findsOneWidget);
    expect(find.byKey(Key('password_field')), findsOneWidget);
    expect(find.text('user@example.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);
  });
}

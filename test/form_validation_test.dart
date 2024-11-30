import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ambientese/login_screen.dart';

void main() {
  testWidgets('form validation shows error when fields are empty',
      (WidgetTester tester) async {
    // Carrega a tela de login
    await tester.pumpWidget(MaterialApp(
      // Remova o 'const' aqui
      home: LoginScreen(),
    ));

    // Tenta clicar no botão "Entrar" sem preencher os campos
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    // Verifica se as mensagens de erro aparecem
    expect(find.text('Por favor, insira seu email'), findsOneWidget);
    expect(find.text('Por favor, insira sua senha'), findsOneWidget);
  });
}

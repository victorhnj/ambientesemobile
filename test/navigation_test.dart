import 'package:flutter_test/flutter_test.dart';
import 'package:ambientese/main.dart';

void main() {
  testWidgets('App navigates from Login to Signup',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verifica se a tela inicial é a de login
    expect(find.text('Login'), findsOneWidget);

    // Simula um clique no botão "Cadastrar" e verifica a navegação
    await tester.tap(find.text('Cadastrar'));
    await tester.pump();

    // Verifica se foi navegada para a tela de cadastro
    expect(find.text('Cadastro'), findsOneWidget);
  });
}

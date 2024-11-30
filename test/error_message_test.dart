import 'package:flutter_test/flutter_test.dart';
import 'package:ambientese/login_screen.dart';

void main() {
  testWidgets('Displays error messages for invalid input',
      (WidgetTester tester) async {
    await tester.pumpWidget(LoginScreen());

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(find.text('Por favor, insira seu email'), findsOneWidget);
    expect(find.text('Por favor, insira sua senha'), findsOneWidget);
  });
}

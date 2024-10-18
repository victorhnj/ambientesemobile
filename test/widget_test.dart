import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ambientese/login_screen.dart'; // Certifique-se de que o caminho está correto

void main() {
  testWidgets('Login screen test', (WidgetTester tester) async {
    // Build the LoginScreen widget.
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Verify that the username and password fields are present.
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Verify that the login button is present.
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    // Enter text into the username and password fields.
    await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');

    // Tap the login button.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that the login logic is triggered.
    // This is a placeholder for actual login logic verification.
    // You can add more specific checks based on your login implementation.
    expect(find.text('Username: testuser'), findsNothing);
    expect(find.text('Password: password'), findsNothing);
  });
}

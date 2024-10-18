import 'package:flutter/material.dart';
import 'login_screen.dart';
// Certifique-se de que o caminho está correto // Importa a nova tela de recuperação de senha

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // A tela inicial será a de login
    );
  }
}

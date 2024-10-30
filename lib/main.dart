import 'package:flutter/material.dart';
import 'login_screen.dart'; // Importa a tela de login
import 'tela_inicial.dart'; // Importa a nova tela de perguntas

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
      initialRoute:
          '/tela_inicial', // Define a rota inicial como a tela inicial
      routes: {
        '/': (context) => LoginScreen(), // Rota da tela de login
        '/tela_inicial': (context) =>
            TelaInicial(), // Rota para a nova tela de perguntas
      },
    );
  }
}

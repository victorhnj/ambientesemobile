import 'package:ambientese/Avaliacao/avaliacaopesquisa.dart';
import 'package:ambientese/Avaliacao/avalicaoresposta.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'cadastro_empresa_1.dart';
import 'main_screen.dart';
import 'Avaliacao/avaliacaopesquisa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ambiente-se',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Cor principal
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue, // Substitui o padrão roxo
        ).copyWith(
          secondary: Colors.green, // Cor secundária personalizada
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue, // Cor dos botões
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: AvaliacaoResposta(), // A tela inicial será a de AvaliacaoResposta
    );
  }
}

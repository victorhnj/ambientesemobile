import 'package:ambientese/cadastro_funcionarios.dart';
import 'package:ambientese/cadastro_perguntas.dart';
import 'package:ambientese/main_screen.dart';
import 'package:ambientese/ranking_screen.dart';
import 'package:ambientese/tela_inicial.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

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
      home: RankingScreen(), // Corrigido para definir a tela inicial como login
    );
  }
}

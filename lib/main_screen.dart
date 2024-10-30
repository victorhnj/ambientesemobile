import 'package:flutter/material.dart';
import 'package:ambientese/header.dart';
import 'package:ambientese/custon_drawer.dart';
import 'package:ambientese/cadastro_empresa_1.dart';
import 'package:ambientese/cadastro_perguntas.dart';
import 'package:ambientese/cadastro_funcionarios.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; 

  // Lista de telas para navegação
  final List<Widget> _screens = [
    CadastroForm(), 
    CadastroPerguntaForm(), 
    CadastroFuncionarioForm(),
    // RankingScreen(),
    // AvaliacaoScreen(), 
    // ChecklistScreen(),
  ];

  // Função para alterar a tela atual
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(),
      drawer: CustomDrawer(onTap: _onItemTapped), 
      body: _screens[_currentIndex], 
    );
  }
}

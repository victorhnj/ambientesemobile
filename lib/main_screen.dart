import 'package:flutter/material.dart';
import 'package:ambientese/header.dart';
import 'package:ambientese/custon_drawer.dart';
import 'package:ambientese/cadastro_empresa_1.dart';
import 'package:ambientese/cadastro_perguntas.dart';
import 'componente_tabela.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Dados fictícios para a tabela
  final String tituloDoFormulario = 'EMPRESAS';
  final List<String> colunas = ['Nome', 'Ramo', 'Porte'];
  final List<List<String>> dados = [
    ['TikTok', 'Automotivo', 'Médio'],
    ['Square', 'Tecnologia', 'Pequeno'],
    ['Samsung', 'Construção', 'Grande'],
    ['HP', 'Automotivo', 'Médio'],
    ['HP', 'Automotivo', 'Médio'],
    ['TikTok', 'Automotivo', 'Médio'],
    ['TikTok', 'Automotivo', 'Médio'],
    ['Square', 'Tecnologia', 'Pequeno'],
    ['Samsung', 'Construção', 'Grande'],
    ['HP', 'Automotivo', 'Médio'],
    ['HP', 'Automotivo', 'Médio'],
    ['TikTok', 'Automotivo', 'Médio'],
    ['TikTok', 'Automotivo', 'Médio'],
    ['Square', 'Tecnologia', 'Pequeno'],
    ['Samsung', 'Construção', 'Grande'],
  ];

  // final List<String> colunas = ['Pergunta', 'Eixo'];
  // final List<List<String>> dados = [
  //   ['A ', 'Ambiental'],
  //   ['A ', 'Ambiental'],
  //   ['A ', 'Ambiental'],
  //   ['A ', 'Ambiental'],
  //   ['A', 'Ambiental'],
  //   ['A ', 'Ambiental'],
  //   ['A ', 'Ambiental'],
  //   ['A ', 'Ambiental'],
  //   ['A ', 'Ambiental'],
  //   ['A ', 'Ambiental'],
  //   ['A ', 'Ambiental'],
  //   ['A  d...', 'Ambiental'],
  // ];


  // Lista de telas para navegação
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      TabelaGenerica(
        colunas: colunas,
        dados: dados,
        tituloDoFormulario: tituloDoFormulario,
        onEdit: (int index) {
          print("Editar item: ${dados[index]}");
        },
        onDelete: (int index) {
          print("Excluir item: ${dados[index]}");
        },
        onTap: _onItemTapped,
      ),
      CadastroForm(onTap: _onItemTapped),
      CadastroPerguntaForm(),
    ]);
  }

  // Função para alterar a tela atual
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    print("Tela alterada para o índice: $index");
    // Fecha o drawer apenas se ele estiver aberto
    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.pop(context);
    }
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
import 'dart:convert'; // Para lidar com JSON
import 'package:ambientese/header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AvaliacaoResposta extends StatefulWidget {
  @override
  _AvaliacaoState createState() => _AvaliacaoState();
}

class _AvaliacaoState extends State<AvaliacaoResposta> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  List<String> perguntasGovernamental = [];
  List<String> perguntasSocial = [];
  List<String> perguntasAmbiental = [];

  List<String?> selectedOptionsGovernamental = List<String?>.filled(10, null);
  List<String?> selectedOptionsSocial = List<String?>.filled(10, null);
  List<String?> selectedOptionsAmbiental = List<String?>.filled(10, null);

  List<int> unansweredQuestions = [];

  // Substitua pelo seu token JWT real
  final String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJyb290IiwiY2FyZ28iOiJBZG1pbiIsImV4cCI6MTczMTQ1NDM0Nn0.C-E4c_bfC-Wl0kR0099V-u8BdcDDkIVs1p0JHvJq2aQ'; // Coloque o seu token JWT aqui

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchQuestions(); // Carregar perguntas da API
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Função para fazer a requisição HTTP e buscar as perguntas
  Future<void> fetchQuestions() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/auth/perguntas'), // URL da sua API
      headers: {
        'Authorization': 'Bearer $token', // Enviar o token JWT no cabeçalho
      },
    );

    if (response.statusCode == 200) {
      // Sucesso: Parse as perguntas do JSON
      final data = json.decode(response.body);
      setState(() {
        perguntasGovernamental = List<String>.from(data['governamental']);
        perguntasAmbiental = List<String>.from(data['ambiental']);
        perguntasSocial = List<String>.from(data['social']);
      });
    } else {
      // Em caso de erro, você pode exibir um erro ou algo similar
      print("Erro ao carregar perguntas: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomHeader(),
      body: Column(
        children: [
          CustomHeader(),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Governamental'),
              Tab(text: 'Ambiental'),
              Tab(text: 'Social'),
            ],
            labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            onTap: (_) {},
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                buildSection(perguntasGovernamental, selectedOptionsGovernamental),
                buildSection(perguntasAmbiental, selectedOptionsAmbiental),
                buildSection(perguntasSocial, selectedOptionsSocial),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text('Cancelar', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_tabController.index > 0) {
                      _tabController.animateTo(_tabController.index - 1);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text('Voltar', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: _tabController.index < 2
                      ? () {
                          if (validateCurrentTab()) {
                            _tabController.animateTo(_tabController.index + 1);
                          }
                        }
                      : () {
                          print("Finalizar");
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text(_tabController.index < 2 ? 'Próximo' : 'Finalizar', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir a seção de perguntas com base nas perguntas da API
  Widget buildSection(List<String> perguntas, List<String?> selectedOptions) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: perguntas.length,
      itemBuilder: (context, index) {
        return buildQuestionCard(index, perguntas[index], selectedOptions);
      },
    );
  }

  // Método para construir o cartão de pergunta
  Widget buildQuestionCard(int index, String pergunta, List<String?> selectedOptions) {
    bool isUnanswered = unansweredQuestions.contains(index);
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isUnanswered ? const Color.fromARGB(255, 255, 255, 255) : Colors.white,
        border: Border.all(
          color: isUnanswered ? Colors.red : Colors.blue,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pergunta,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile<String>(
                title: Text("Conforme", style: TextStyle(fontSize: 18.0)),
                value: "Conforme",
                groupValue: selectedOptions[index],
                onChanged: (value) {
                  setState(() {
                    selectedOptions[index] = value;
                    unansweredQuestions.remove(index);
                  });
                },
                activeColor: Colors.blue,
                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                dense: true,
              ),
              RadioListTile<String>(
                title: Text("Não conforme", style: TextStyle(fontSize: 18.0)),
                value: "Não conforme",
                groupValue: selectedOptions[index],
                onChanged: (value) {
                  setState(() {
                    selectedOptions[index] = value;
                    unansweredQuestions.remove(index);
                  });
                },
                activeColor: Colors.blue,
                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                dense: true,
              ),
              RadioListTile<String>(
                title: Text("Não aplicável", style: TextStyle(fontSize: 18.0)),
                value: "Não aplicável",
                groupValue: selectedOptions[index],
                onChanged: (value) {
                  setState(() {
                    selectedOptions[index] = value;
                    unansweredQuestions.remove(index);
                  });
                },
                activeColor: Colors.blue,
                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                dense: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool validateCurrentTab() {
    List<String?> currentOptions;
    switch (_tabController.index) {
      case 0:
        currentOptions = selectedOptionsGovernamental;
        break;
      case 1:
        currentOptions = selectedOptionsAmbiental;
        break;
      case 2:
        currentOptions = selectedOptionsSocial;
        break;
      default:
        currentOptions = [];
    }
    return !currentOptions.contains(null);
  }
}

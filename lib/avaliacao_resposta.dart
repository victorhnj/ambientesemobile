import 'dart:convert'; // Para lidar com JSON
import 'package:ambientese/header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AvaliacaoResposta extends StatefulWidget {
  final List<dynamic> perguntasGovernamental;
  final List<dynamic> perguntasSocial;
  final List<dynamic> perguntasAmbiental;
  final void Function(List<Map<String, dynamic>> answers)? processarRespostas;

  const AvaliacaoResposta(
      {super.key,
      required this.perguntasGovernamental,
      required this.perguntasSocial,
      required this.perguntasAmbiental,
      required this.processarRespostas});

  @override
  _AvaliacaoState createState() => _AvaliacaoState();
}

class _AvaliacaoState extends State<AvaliacaoResposta>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  List<String> perguntasGovernamental = [];
  List<String> perguntasSocial = [];
  List<String> perguntasAmbiental = [];

  List<String?> selectedOptionsGovernamental = [];
  List<String?> selectedOptionsSocial = [];
  List<String?> selectedOptionsAmbiental = [];

  List<int> unansweredQuestions = [];

  final String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJyb290IiwiY2FyZ28iOiJBZG1pbiIsImV4cCI6MTczMzA4NzM5OX0.WV_PTMbPyou3ko8rM--G-u_XNMSfcTKBZO0Q_0g4kic'; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Inicializar listas locais com os valores recebidos por parâmetro
    perguntasGovernamental = widget.perguntasGovernamental
        .map((item) => item['perguntaDescricao'] as String)
        .toList();
    perguntasSocial = widget.perguntasSocial
        .map((item) => item['perguntaDescricao'] as String)
        .toList();
    perguntasAmbiental = widget.perguntasAmbiental
        .map((item) => item['perguntaDescricao'] as String)
        .toList();

    selectedOptionsGovernamental =
        List<String?>.filled(widget.perguntasGovernamental.length, null);
    selectedOptionsSocial =
        List<String?>.filled(widget.perguntasSocial.length, null);
    selectedOptionsAmbiental =
        List<String?>.filled(widget.perguntasAmbiental.length, null);
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
      Uri.parse('http://localhost:8080/auth/perguntas'), 
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        perguntasGovernamental = List<String>.from(data['governamental']);
        perguntasAmbiental = List<String>.from(data['ambiental']);
        perguntasSocial = List<String>.from(data['social']);
      });
    } else {
      print("Erro ao carregar perguntas: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
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
                buildSection(
                    perguntasGovernamental, selectedOptionsGovernamental),
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
                Expanded(
                  child: ElevatedButton(
                    onPressed: _tabController.index > 0
                        ? () {
                            _tabController.animateTo(_tabController.index - 1);
                            setState(() {
                              _tabController.index - 1;
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    child: Text(
                      'Voltar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _tabController.index < 2
                        ? () {
                            _tabController.animateTo(_tabController.index + 1);
                            setState(() {
                              _tabController.index - 1;
                            });
                          }
                        : () {
                            if (validateCurrentTab()) {
                              // Coleta as respostas ao finalizar
                              List<Map<String, dynamic>> answers =
                                  collectAnswers();
                              widget.processarRespostas!(answers);
                            } else {
                              showDialogModal();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _tabController.index < 2 ? Colors.blue : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: _tabController.index < 2
                            ? BorderSide.none
                            : BorderSide(
                                color:
                                    Colors.black), 
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    child: Text(
                      _tabController.index < 2 ? 'Próximo' : 'Finalizar',
                      style: TextStyle(
                        color: _tabController.index < 2
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
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
  Widget buildQuestionCard(
      int index, String pergunta, List<String?> selectedOptions) {
    bool isUnanswered = unansweredQuestions.contains(index);
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isUnanswered
            ? const Color.fromARGB(255, 255, 255, 255)
            : Colors.white,
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                dense: true,
              ),
              RadioListTile<String>(
                title: Text("Não conforme", style: TextStyle(fontSize: 18.0)),
                value: "NaoConforme",
                groupValue: selectedOptions[index],
                onChanged: (value) {
                  setState(() {
                    selectedOptions[index] = value;
                    unansweredQuestions.remove(index);
                  });
                },
                activeColor: Colors.blue,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                dense: true,
              ),
              RadioListTile<String>(
                title: Text("Não aplicável", style: TextStyle(fontSize: 18.0)),
                value: "NaoSeAdequa",
                groupValue: selectedOptions[index],
                onChanged: (value) {
                  setState(() {
                    selectedOptions[index] = value;
                    unansweredQuestions.remove(index);
                  });
                },
                activeColor: Colors.blue,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                dense: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool validateCurrentTab() {
    return !selectedOptionsGovernamental.contains(null) &&
        !selectedOptionsAmbiental.contains(null) &&
        !selectedOptionsSocial.contains(null);
  }

  showDialogModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Atenção'),
          content: Text('Ainda há perguntas a serem respondidas.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> collectAnswers() {
    List<Map<String, dynamic>> formattedAnswers = [];

    // Percorre as perguntas governamentais e coleta as respostas
    for (int i = 0; i < widget.perguntasGovernamental.length; i++) {
      formattedAnswers.add({
        'perguntaId': widget.perguntasGovernamental[i]
            ['perguntaId'], // Usa o perguntaId da pergunta original
        'respostaUsuario': selectedOptionsGovernamental[i],
        'perguntaEixo': 'Governamental',
      });
    }

    // Percorre as perguntas ambientais e coleta as respostas
    for (int i = 0; i < widget.perguntasAmbiental.length; i++) {
      formattedAnswers.add({
        'perguntaId': widget.perguntasAmbiental[i]
            ['perguntaId'], // Usa o perguntaId da pergunta original
        'respostaUsuario': selectedOptionsAmbiental[i],
        'perguntaEixo': 'Ambiental',
      });
    }

    // Percorre as perguntas sociais e coleta as respostas
    for (int i = 0; i < widget.perguntasSocial.length; i++) {
      formattedAnswers.add({
        'perguntaId': widget.perguntasSocial[i]
            ['perguntaId'], // Usa o perguntaId da pergunta original
        'respostaUsuario': selectedOptionsSocial[i],
        'perguntaEixo': 'Social',
      });
    }

    return formattedAnswers;
  }
}

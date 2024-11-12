import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../header.dart';
import 'avalicaoresposta.dart';

class AvaliacaoPesquisa extends StatefulWidget {
  @override
  _AvaliacaoState createState() => _AvaliacaoState();
}

class _AvaliacaoState extends State<AvaliacaoPesquisa> {
  List<dynamic> empresas = []; // Lista para armazenar empresas
  String query = ''; // Armazena a consulta de busca
  FocusNode _focusNode = FocusNode(); // FocusNode para o campo de texto
  dynamic empresaSelecionada; // Variável para armazenar a empresa selecionada
  TextEditingController _textController = TextEditingController(); // Controlador de texto

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Atualiza o estado quando o foco muda
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Libera o FocusNode quando o widget é descartado
    _textController.dispose(); // Libera o controlador de texto
    super.dispose();
  }

  // Função para buscar empresas com tratamento de erro
  Future<void> buscarEmpresas(String nome) async {
    if (nome.isEmpty) {
      setState(() {
        empresas = []; // Limpa a lista se a consulta estiver vazia
      });
      return;
    }

    try {
      final queryParams = {'nome': nome.isNotEmpty ? nome : ''}; // Parâmetros de consulta
      const String URL = 'http://localhost:8080';
      final uri = Uri.parse('$URL/auth/Empresa/avaliacao/search?nome=${queryParams['nome']}');
      final response = await http.get(uri, headers: headers); // Faz a requisição

      if (response.statusCode == 200) {
        setState(() {
          empresas = json.decode(response.body); // Decodifica a resposta JSON
        });
      } else {
        print('Erro ao buscar empresas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro de parsing ou de conexão: $e'); // Captura e exibe a exceção
    }
  }

  Map<String, String> headers = {
    'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJyb290IiwiY2FyZ28iOiJBZG1pbiIsImV4cCI6MTczMTQ1MzM5N30.I3OK0dE9twmqRqtJDS8_yf_JDQ_PZdzX96KtqURcoRU',
    'Content-Type': 'application/json; charset=UTF-8',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomHeader(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Remove o foco do campo de texto
          setState(() {
            empresas = []; // Limpa a lista de empresas
          });
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomHeader(),
              SizedBox(height: 100), // Adiciona uma margem de 100
              Center(
                child: Column(
                  children: [
                    Text(
                      'Escolha a empresa para avaliação:',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _textController, // Atribui o controlador de texto
                                  focusNode: _focusNode, // Atribui o FocusNode ao TextField
                                  onChanged: (value) {
                                    query = value; // Atualiza a consulta de busca
                                    buscarEmpresas(value); // Chama a função de busca
                                    setState(() {
                                      empresaSelecionada = empresas.firstWhere(
                                        (empresa) => empresa['nomeFantasia'] == value,
                                        orElse: () => null,
                                      );
                                    });
                                  },
                                  onTap: () {
                                    // Quando o campo de texto é clicado, busca empresas
                                    buscarEmpresas(query);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Buscar empresa...',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AnimatedOpacity(
                            opacity: empresas.isNotEmpty ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child: empresas.isNotEmpty
                                ? Container(
                                    width: 300, // Define a largura da lista
                                    height: 300,
                                    margin: const EdgeInsets.only(top: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: ListView.builder(
                                      itemCount: empresas.length,
                                      itemBuilder: (context, index) {
                                        final empresa = empresas[index];
                                        return ListTile(
                                          title: Text(empresa['nomeFantasia'] ?? 'Nome não disponível'),
                                          tileColor: index % 2 == 0 ? Colors.white : Colors.grey[200], // Intercalação de cores
                                          onTap: () {
                                            setState(() {
                                              empresaSelecionada = empresa; // Armazena a empresa selecionada
                                              _textController.text = empresa['nomeFantasia'] ?? ''; // Preenche o campo de texto
                                            });
                                          },
                                          selected: empresaSelecionada == empresa,
                                        );
                                      },
                                    ),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Mensagem caso não haja empresas
                    if (empresas.isEmpty)
                      SizedBox(height: 16),
                    AnimatedOpacity(
                      opacity: empresaSelecionada != null ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: ElevatedButton(
                        onPressed: empresaSelecionada != null
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AvaliacaoResposta()),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0077c8),
                          padding: EdgeInsets.symmetric(horizontal: 34, vertical: 22),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Avaliar',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

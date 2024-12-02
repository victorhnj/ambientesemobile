import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './avaliacao_resposta.dart';

class AvaliacaoPesquisa extends StatefulWidget {
  final Function(int, String) saveCompanyData;

  const AvaliacaoPesquisa({super.key, required this.saveCompanyData});

  @override
  _AvaliacaoState createState() => _AvaliacaoState();
}

class _AvaliacaoState extends State<AvaliacaoPesquisa> {
  List<dynamic> empresas = []; 
  String query = ''; 
  FocusNode _focusNode = FocusNode(); 
  dynamic empresaSelecionada; 
  TextEditingController _textController =
      TextEditingController(); 

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); 
    _textController.dispose(); 
    super.dispose();
  }

  // Função para buscar empresas com tratamento de erro
  Future<void> buscarEmpresas(String nome) async {
    if (nome.isEmpty) {
      setState(() {
        empresas = []; 
      });
      return;
    }

    try {
      final queryParams = {
        'nome': nome.isNotEmpty ? nome : ''
      }; 
      const String URL = 'http://localhost:8080';
      final uri = Uri.parse(
          '$URL/auth/Empresa/avaliacao/search?nome=${queryParams['nome']}');
      final response =
          await http.get(uri, headers: headers); 

      if (response.statusCode == 200) {
        setState(() {
          empresas = json.decode(response.body);
        });
      } else {
        print('Erro ao buscar empresas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro de parsing ou de conexão: $e');
    }
  }

  Map<String, String> headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJyb290IiwiY2FyZ28iOiJBZG1pbiIsImV4cCI6MTczMzA4NzM5OX0.WV_PTMbPyou3ko8rM--G-u_XNMSfcTKBZO0Q_0g4kic',
    'Content-Type': 'application/json; charset=UTF-8',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); 
          setState(() {
            empresas = []; 
          });
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100), 
              Center(
                child: Column(
                  children: [
                    Text(
                      'Escolha a empresa para avaliação:',
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
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
                                  controller:
                                      _textController, 
                                  focusNode:
                                      _focusNode, 
                                  onChanged: (value) {
                                    query =
                                        value; 
                                    buscarEmpresas(
                                        value); 
                                    setState(() {
                                      empresaSelecionada = empresas.firstWhere(
                                        (empresa) =>
                                            empresa['nomeFantasia'] == value,
                                        orElse: () => null,
                                      );
                                    });
                                  },
                                  onTap: () {
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
                                    width: 300, 
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
                                          title: Text(empresa['nomeFantasia'] ??
                                              'Nome não disponível'),
                                          tileColor: index % 2 == 0
                                              ? Colors.white
                                              : Colors.grey[
                                                  200], 
                                          onTap: () {
                                            setState(() {
                                              empresaSelecionada =
                                                  empresa;
                                              _textController.text = empresa[
                                                      'nomeFantasia'] ??
                                                  ''; 
                                            });
                                          },
                                          selected:
                                              empresaSelecionada == empresa,
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
                    if (empresas.isEmpty) SizedBox(height: 16),
                    AnimatedOpacity(
                      opacity: empresaSelecionada != null ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: ElevatedButton(
                        onPressed: empresaSelecionada != null
                            ? () => widget.saveCompanyData(
                                empresaSelecionada['id'],
                                empresaSelecionada['nomeFantasia'])
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0077c8),
                          padding: EdgeInsets.symmetric(
                              horizontal: 34, vertical: 22),
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

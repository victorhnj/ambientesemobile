// import 'dart:ffi';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ambientese/avaliacao_resposta.dart';
import 'package:flutter/material.dart';
import 'package:ambientese/header.dart';
import 'package:ambientese/custon_drawer.dart';
import 'package:ambientese/cadastro_empresa_1.dart';
import 'package:ambientese/cadastro_perguntas.dart';
import 'cadastro_funcionarios.dart';
import 'componente_tabela.dart';
import 'tela_inicial.dart';
import 'resultado_avaliacao.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'avaliacao_pesquisa.dart';
import 'rankig_screen.dart';

class MainScreen extends StatefulWidget {
  String token;
  MainScreen({required this.token});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 10;
  bool isFormulario = true;
  String? token;
  String tituloDoFormulario = '';
  List<String> colunas = [];
  List<Map<String, dynamic>> dados = [];
  Map<String, dynamic>? initialData;
  int currentPage = 0;
  String searchString = '';

  // Para a realização dos formulários
  List<int> selectedIdsForm = [];
  int companySelected = -1;
  String companySelectedName = '';
  dynamic governamental = [];
  dynamic ambiental = [];
  dynamic social = [];
  List<Map<String, dynamic>> dadosResultadoAvaliacao = [];
  String _errorMessage = '';
  bool isLoading = false;
  bool finishList = false;

  List<Widget> get _screens => [
        TabelaGenerica(
          colunas: colunas,
          dados: dados,
          tituloDoFormulario: tituloDoFormulario,
          onEdit: (int index) {
            _fetchEmpresa(index);
          },
          onDelete: (int index) {
            _deleteEmpresa(index);
          },
          onTap: _onItemTapped,
          onPageBack: _decrementPage,
          onPageForward: _incrementPage,
          indexTelaFormulario: 3,
          onSearchIconTap: (String value) {
            setState(() {
              currentPage = 0;
              searchString = value;
            });

            _fetchDataEmpresa(value);
          },
          isSelectable: false,
          currentPage: currentPage,
          finishList: finishList,
        ),
        TabelaGenerica(
          colunas: colunas,
          dados: dados,
          tituloDoFormulario: tituloDoFormulario,
          onEdit: (int index) {
            _fetchPergunta(index);
          },
          onDelete: (int index) {
            _deletePergunta(index);
          },
          onTap: _onItemTapped,
          onPageBack: _decrementPage,
          onPageForward: _incrementPage,
          indexTelaFormulario: 4,
          onSearchIconTap: (String value) {
            setState(() {
              currentPage = 0;
              searchString = value;
            });

            _fetchDataPerguntas(value);
          },
          isSelectable: isFormulario,
          createFormulario: (selectedIds) {
            _createFormulario(selectedIds);
          },
          currentPage: currentPage,
          finishList: finishList,
        ),
        TabelaGenerica(
          colunas: colunas,
          dados: dados,
          tituloDoFormulario: tituloDoFormulario,
          onEdit: (int index) {
            _fetchFuncionario(index);
          },
          onDelete: (int index) {
            _deleteFuncionario(index);
          },
          onTap: _onItemTapped,
          onPageBack: _decrementPage,
          onPageForward: _incrementPage,
          indexTelaFormulario: 5,
          onSearchIconTap: (String value) {
            setState(() {
              currentPage = 0;
              searchString = value;
            });

            _fetchDataFuncionarios(value);
          },
          isSelectable: false,
          currentPage: currentPage,
          finishList: finishList,
        ),
        CadastroForm(
            onTap: _onItemTapped,
            initialData: initialData,
            onSave: (updatedData, isEdit) {
              (isEdit == 1)
                  ? _editEmpresa(initialData?['id'], updatedData)
                  : _addEmpresa(updatedData);
            },
            errorMessage: _errorMessage),
        CadastroPerguntaForm(
          onTap: _onItemTapped,
          initialData: initialData,
          onSave: (updatedData, isEdit) {
            (isEdit == 1)
                ? _editPergunta(initialData?['id'], updatedData)
                : _addPergunta(updatedData);
          },
        ),
        CadastroFuncionarioForm(
          onTap: _onItemTapped,
          initialData: initialData,
          onSave: (updatedData, isEdit) {
            (isEdit == 1)
                ? _editFuncionario(initialData?['id'], updatedData)
                : _addFuncionario(updatedData);
          },
        ),
        TelaInicial(onTap: _onItemTapped),
        ResultadosEmpresaScreen(
          companyName: companySelectedName,
          screenData: dadosResultadoAvaliacao,
          exportPDF: (nomeFantasia) => {exportPDF(nomeFantasia)},
          onTap: _onItemTapped,
        ),
        AvaliacaoPesquisa(
          saveCompanyData: (companyId, companyName) {
            companySelected = companyId;
            companySelectedName = companyName;
            _fetchEmpresaPerguntas();
          },
        ),
        AvaliacaoResposta(
          perguntasGovernamental: governamental,
          perguntasAmbiental: ambiental,
          perguntasSocial: social,
          processarRespostas: (answers) => {processarRespostas(answers)},
        ),
        RankingScreen(
          finishList1: finishList,
          currentPage1: currentPage,
        ),
      ];

  @override
  void initState() {
    super.initState();
    _fetchDataEmpresa(); 
    token = widget.token;
  }

  final String URL = 'http://localhost:8080';
  Map<String, String> get headers {
    return {
      'Authorization': 'Bearer $token', 
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  void _fetchDataEmpresa([search = '']) async {
    setState(() {
      isLoading = true; 
    });

    try {
      final resultado = await buscarDadosEmpresa(currentPage, search);
      setState(() {
        dados = resultado as List<Map<String, dynamic>>;
        tituloDoFormulario = 'EMPRESAS';
        colunas = ['Nome', 'Ramo', 'Porte'];
        finishList = dados[0]['finishList'];
      });

      if (dados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Nenhum dado foi encontrado!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor:
                Colors.red, 
            behavior: SnackBarBehavior.floating, 
            duration: Duration(seconds: 3), 
          ),
        );
      }
    } catch (e) {
      print('Erro ao buscar dados: $e');
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }

  void _fetchDataPerguntas([search = '']) async {
    setState(() {
      isLoading = true; 
    });

    try {
      final resultado = await buscarDadosPerguntas(currentPage, search);
      setState(() {
        dados = resultado as List<Map<String, dynamic>>;
        tituloDoFormulario = isFormulario ? 'FORMULÁRIO' : 'PERGUNTAS';
        colunas = ['Pergunta', 'Eixo'];
        finishList = dados[0]['finishList'];
      });
    } catch (e) {
      print('Erro ao buscar dados: $e');
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }

  void _fetchDataFuncionarios([search = '']) async {
    setState(() {
      isLoading = true; 
    });

    try {
      final resultado = await buscarDadosFuncionarios(currentPage, search);
      setState(() {
        dados = resultado as List<Map<String, dynamic>>;
        tituloDoFormulario = 'FUNCIONÁRIOS';
        colunas = ['Nome', 'Cargo'];
        finishList = dados[0]['finishList'];
      });
    } catch (e) {
      print('Erro ao buscar dados: $e');
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }

  void _incrementPage() {
    if (dados[0]["finishList"] == false) {
      setState(() {
        currentPage += 1;
      });
      _fetchCurrentData(); 
    }
  }

  void _decrementPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage -= 1;
      });
      _fetchCurrentData();
    }
  }

  // Função para determinar qual conjunto de dados buscar com base na tela ativa
  void _fetchCurrentData() {
    if (_currentIndex == 0) {
      _fetchDataEmpresa();
    } else if (_currentIndex == 1) {
      _fetchDataPerguntas();
    } else if (_currentIndex == 2) {
      _fetchDataFuncionarios();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(onTap: _onItemTapped),
      drawer: CustomDrawer(onTap: _onItemTapped),
      body: _screens[_currentIndex],
    );
  }

  void _onItemTapped(int index, [bool? isFormulario]) {
    setState(() {
      _currentIndex = index;
      currentPage = 0; 
      this.isFormulario = isFormulario != null ? true : false;
      searchString = '';
    });

    if (index == 0) {
      _fetchDataEmpresa();
    } else if (index == 1) {
      _fetchDataPerguntas();
    } else if (_currentIndex == 2) {
      _fetchDataFuncionarios();
    }

    if (index == 0 || index == 1 || index == 2) {
      setState(() {
        initialData = null;
      });
    }

    print("Tela alterada para o índice: $index");
  }

  // Função para buscar dados da empresa
  Future<List<dynamic>> buscarDadosEmpresa(int page,
      [String search = '']) async {
    try {
      if (search.isNotEmpty) {
        setState(() {
          currentPage = 0;
          searchString = search;
        });
      }
      final queryParams = <String, String>{
        'nome': searchString,
        'page': page.toString()
      };
      final uri = Uri.parse('$URL/auth/Empresa/search')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> resultado = jsonDecode(utf8.decode(response.bodyBytes));

        return resultado.map((item) {
          return {
            'id': item['id'], 
            'Nome': item['nomeFantasia'] ?? '', 
            'Porte': item['porteEmpresas'] ?? '', 
            'Ramo': item['ramo'] ?? '', 
            'finishList': item['finishList'], 
          };
        }).toList();
      } else {
        print('Erro ao buscar dados da empresa: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro: $e');
      return [];
    }
  }

  // Função para buscar dados de perguntas
  Future<List<dynamic>> buscarDadosPerguntas(int page,
      [String search = '']) async {
    try {
      final queryParams = <String, String>{
        'nome': searchString,
        'page': page.toString()
      };
      final uri = Uri.parse('$URL/auth/Perguntas/search')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> resultado = jsonDecode(utf8.decode(response.bodyBytes));

        return resultado.map((item) {
          return {
            'id': item['id'],
            'Pergunta': item['descricao'] ?? '', 
            'Eixo': item['eixo'] ?? '', 
            'isSelected': false,
            'finishList': item['finishList'], 
          };
        }).toList();
      } else {
        print('Erro ao buscar dados de perguntas: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro: $e');
      return [];
    }
  }

  // Função para buscar dados dos funcionários
  Future<List<dynamic>> buscarDadosFuncionarios(int page,
      [String search = '']) async {
    try {
      if (search.isNotEmpty) {
        setState(() {
          currentPage = 0;
          searchString = search;
        });
      }
      final queryParams = <String, String>{
        'nome': searchString,
        'page': page.toString()
      };
      final uri = Uri.parse('$URL/auth/Funcionario/search')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> resultado = jsonDecode(utf8.decode(response.bodyBytes));

        return resultado.map((item) {
          return {
            'id': item['id'], 
            'Nome': item['nome'] ?? '', 
            'Cargo': item['cargo']['descricao'] ?? '', 
            'finishList': item['finishList'], 
          };
        }).toList();
      } else {
        print('Erro ao buscar dados de funcionários: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro: $e');
      return [];
    }
  }

  //Para a exclusão
  Future<void> _deleteEmpresa(int id) async {
    final uri = Uri.parse('$URL/auth/Empresa/Delete/$id');

    try {
      final response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          dados.removeWhere((item) => item['id'] == id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Empresa excluída com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor:
                Colors.green, 
            behavior: SnackBarBehavior.floating, 
            duration: Duration(seconds: 3), 
          ),
        );
      } else {
        print("Erro ao excluir a empresa: ${response.statusCode}");

        String errorMessage;
        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? 'Erro desconhecido';
        } catch (decodeError) {
          errorMessage = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, 
            behavior:
                SnackBarBehavior.floating, 
            duration:
                Duration(seconds: 4), 
          ),
        );
      }
    } catch (e) {
      print("Erro de conexão: $e");
      _showErrorSnackbar("Erro de conexão ao excluir a empresa.");
    }
  }

  Future<void> _deletePergunta(int id) async {
    final uri = Uri.parse('$URL/auth/Perguntas/Delete/$id');

    try {
      final response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          dados.removeWhere((item) => item['id'] == id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pergunta excluída com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor:
                Colors.green, 
            behavior: SnackBarBehavior.floating, 
            duration: Duration(seconds: 3), 
          ),
        );
      } else {
        print("Erro ao excluir a pergunta: ${response.statusCode}");

        String errorMessage;
        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? 'Erro desconhecido';
        } catch (decodeError) {
          errorMessage = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, 
            behavior:
                SnackBarBehavior.floating, 
            duration:
                Duration(seconds: 4), 
          ),
        );
      }
    } catch (e) {
      print("Erro de conexão: $e");
      _showErrorSnackbar(
          "Erro ao deletar, a pergunta está sendo utilizadas em avaliações.");
    }
  }

  Future<void> _deleteFuncionario(int id) async {
    final uri = Uri.parse('$URL/auth/Funcionario/Delete/$id');

    try {
      final response = await http.delete(uri, headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          dados.removeWhere((item) => item['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Funcionário excluído com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor:
                Colors.green, 
            behavior: SnackBarBehavior.floating, 
            duration: Duration(seconds: 3), 
          ),
        );
      } else {
        print("Erro ao excluir o funcionario: ${response.statusCode}");

        String errorMessage;
        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? 'Erro desconhecido';
        } catch (decodeError) {
          errorMessage = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, 
            behavior:
                SnackBarBehavior.floating, 
            duration:
                Duration(seconds: 4), 
          ),
        );
      }
    } catch (e) {
      print("Erro de conexão: $e");
      _showErrorSnackbar("Erro de conexão ao excluir o funcionario.");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _fetchFuncionario(int id) async {
    final uri = Uri.parse('$URL/auth/Funcionario/Get/$id');

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final dynamic decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          initialData = decodedResponse;
          _currentIndex = 5;
        });
      } else {
        print("Erro ao buscar os dados do funcionário: ${response.statusCode}");
        _showErrorSnackbar("Erro ao buscar os dados do funcionário.");
      }
    } catch (e) {
      print("Erro de conexão: $e");
      _showErrorSnackbar("Erro de conexão ao buscar os dados do funcionário.");
    }
  }

  Future<void> _editFuncionario(
      int id, Map<String, dynamic> updatedData) async {
    final uri = Uri.parse('$URL/auth/Funcionario/Edit/$id');
    try {
      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Funcionário atualizado com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor:
                Colors.green, 
            behavior: SnackBarBehavior.floating, 
            duration: Duration(seconds: 3), 
          ),
        );

        _fetchDataFuncionarios();
        setState(() {
          initialData = null;
          _currentIndex = 2;
        });
      } else {
        String errorMessage;

        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? 'Erro desconhecido';
        } catch (decodeError) {
          errorMessage = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, 
            behavior:
                SnackBarBehavior.floating, 
            duration:
                Duration(seconds: 4), 
          ),
        );
      }
    } catch (e) {
      print("Erro de conexão: $e");
    }
  }

  Future<void> _addFuncionario(Map<String, dynamic> newData) async {
    final uri = Uri.parse('$URL/auth/Funcionario/Add');
    print("Iniciando adição de novo funcionário");

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(newData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Funcionário adicionado com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor:
                Colors.green, 
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3), 
          ),
        );

        _fetchDataFuncionarios();
        setState(() {
          _currentIndex = 2;
        });
      } else {
        String errorMessage;

        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? 'Erro desconhecido';
        } catch (decodeError) {
          errorMessage = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, 
            behavior:
                SnackBarBehavior.floating, 
            duration:
                Duration(seconds: 4), 
          ),
        );
      }
    } catch (e) {
      print("Erro de conexão: $e");

      String errorMessage;
      if (e is FormatException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _fetchEmpresa(int id) async {
    final uri = Uri.parse('$URL/auth/Empresa/$id');

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final dynamic decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          initialData = decodedResponse;
          _currentIndex = 3;
        });
      } else {
        print("Erro ao buscar os dados da empresa: ${response.statusCode}");
        _showErrorSnackbar("Erro ao buscar os dados da empresa.");
      }
    } catch (e) {
      print("Erro de conexão: $e");
      _showErrorSnackbar("Erro de conexão ao buscar os dados da empresa.");
    }
  }

  Future<void> _editEmpresa(int id, Map<String, dynamic> updatedData) async {
    final uri = Uri.parse('$URL/auth/Empresa/Edit/$id');
    try {
      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Empresa atualizada com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor:
                Colors.green, 
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3), 
          ),
        );

        _fetchDataEmpresa();
        setState(() {
          initialData = null;
          _currentIndex = 0;
        });
      } else {
        String errorMessage;

        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? 'Erro desconhecido';
        } catch (decodeError) {
          errorMessage = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, 
            behavior:
                SnackBarBehavior.floating, 
            duration:
                Duration(seconds: 4), 
          ),
        );
      }
    } catch (e) {
      print("Erro de conexão: $e");
    }
  }

  Future<void> _addEmpresa(Map<String, dynamic> newData) async {
    final uri = Uri.parse('$URL/auth/Empresa/Add');

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(newData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Empresa adicionada com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor:
                Colors.green,
            behavior: SnackBarBehavior.floating, 
            duration: Duration(seconds: 3), 
          ),
        );

        _fetchDataEmpresa();
        setState(() {
          _currentIndex = 0; 
        });
      } else {
        String errorMessage;

        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? 'Erro desconhecido';
        } catch (decodeError) {
          errorMessage = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, 
            behavior:
                SnackBarBehavior.floating, 
            duration:
                Duration(seconds: 4), 
          ),
        );
      }
    } catch (e) {
      print("Erro de conexão: $e");

      String errorMessage;

      // Verifica se o erro é do tipo FormatException
      if (e is FormatException) {
        errorMessage = e.message; 
      } else {
        errorMessage = e.toString(); 
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red, 
          behavior:
              SnackBarBehavior.floating, 
          duration:
              Duration(seconds: 4), 
        ),
      );
    }
  }

  // Perguntas
  Future<void> _fetchPergunta(int id) async {
    final uri = Uri.parse('$URL/auth/Perguntas/$id');

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final dynamic decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          initialData = decodedResponse;
          _currentIndex = 4;
        });
      } else {
        print("Erro ao buscar os dados da pergunta: ${response.statusCode}");
        _showErrorSnackbar("Erro ao buscar os dados da pergunta.");
      }
    } catch (e) {
      print("Erro de conexão: $e");
      _showErrorSnackbar("Erro de conexão ao buscar os dados da pergunta.");
    }
  }

  Future<void> _editPergunta(int id, Map<String, dynamic> updatedData) async {
    final uri = Uri.parse('$URL/auth/Perguntas/Edit/$id');
    print("Iniciando EDIÇÃO de nova pergunta");

    try {
      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pergunta atualizada com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor:
                Colors.green, 
            behavior: SnackBarBehavior.floating, 
            duration: Duration(seconds: 3), 
          ),
        );

        _fetchDataPerguntas();
        setState(() {
          initialData = null;
          _currentIndex = 1;
        });
      } else {
        String errorMessage;

        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? 'Erro desconhecido';
        } catch (decodeError) {
          errorMessage = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior:
                SnackBarBehavior.floating, 
            duration:
                Duration(seconds: 4), 
          ),
        );
      }
    } catch (e) {
      print("Erro de conexão: $e");
    }
  }

  Future<void> _addPergunta(Map<String, dynamic> newData) async {
    final uri = Uri.parse('$URL/auth/Perguntas/Add');
    print("Iniciando adição de nova pergunta");

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(newData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pergunta adicionada com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor:
                Colors.green, 
            behavior: SnackBarBehavior.floating, 
            duration: Duration(seconds: 3), 
          ),
        );

        _fetchDataPerguntas();
        setState(() {
          _currentIndex = 1; 
        });
      } else {
        String errorMessage;

        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? 'Erro desconhecido';
        } catch (decodeError) {
          errorMessage = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, 
            behavior:
                SnackBarBehavior.floating, 
            duration:
                Duration(seconds: 4), 
          ),
        );
      }
    } catch (e) {
      print("Erro de conexão: $e");

      String errorMessage;
      if (e is FormatException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _createFormulario(List<int> selectedIds) async {
    final uri = Uri.parse('$URL/checklist/Add?eixo=Ambiental');
    final companyData = {
      'descricao': 'Teste',
      'selectedPerguntasIds': selectedIds
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(companyData),
      );

      if (response.statusCode == 200) {
        print("Formulário criado com sucesso");

        setState(() {
          selectedIdsForm = selectedIds;
          _currentIndex = 8;
        });

        print("selectedIds: $selectedIds");
        print("selectedIdsForm: $selectedIdsForm");
      } else {
        print("Erro ao adicionar formulário");
      }
    } catch (e) {
      print("Erro de conexão: $e");
    }
  }

  Future<bool> verifyActiveForm() async {
    final uri = Uri.parse('$URL/auth/haveAvaliacaoAtiva/$companySelected');

    try {
      final response = await http.get(
        uri,
        headers: headers,
      );

      return response.statusCode == 200
          ? jsonDecode(response.body)
          : throw Exception("Erro ao verificar formulário ativo.");
    } catch (e) {
      print("Erro de conexão: $e");
      throw Exception("Erro de conexão ao verificar formulário ativo.");
    }
  }

  // Para a avaliação
  final checkListId = 2;
  Future<void> _fetchEmpresaPerguntas() async {
    final uri = Uri.parse(
        '$URL/auth/questionario/$checkListId?empresaId=$companySelected');
    final bool hasActiveForm = await verifyActiveForm();
    final props = {
      'companySelected': companySelected,
      'isNew': true,
    };
    const questionNumbers = 10;

    if (!hasActiveForm) {
      try {
        final response = await http.get(uri, headers: headers);
        setState(() {
          governamental = [];
          ambiental = [];
          social = [];
        });

        if (response.statusCode == 200) {
          final data = jsonDecode(
              utf8.decode(response.bodyBytes)); 
          print("Dados do formulário: $data");

          if (!(props['isNew'] as bool)) {
            data['formularioRequests'].forEach((item) {
              if (item['eixo'] == 'Governamental') {
                if (governamental.length < questionNumbers) {
                  // tem que ver essa parada aqui depois
                  governamental.add(item);
                }
              } else if (item['eixo'] == 'Ambiental') {
                if (ambiental.length < questionNumbers) {
                  // tem que ver essa parada aqui depois
                  ambiental.add(item);
                }
              } else if (item['eixo'] == 'Social') {
                if (social.length < questionNumbers) {
                  // tem que ver essa parada aqui depois
                  social.add(item);
                }
              }
            });
          } else {
            data['formularioRequests'].forEach((item) {
              item.remove('numeroPergunta');
              if (item['perguntaEixo'] == 'Governamental') {
                governamental.add(item);
              } else if (item['perguntaEixo'] == 'Ambiental') {
                ambiental.add(item);
              } else if (item['perguntaEixo'] == 'Social') {
                social.add(item);
              }
            });
          }

          print("Perguntas Governamentais: $governamental");
          print("Perguntas Ambientais: $ambiental");
          print("Perguntas Sociais: $social");

          setState(() {
            _currentIndex = 9;
          });
        } else {
          print("Erro ao buscar os dados da empresa: ${response.statusCode}");
          _showErrorSnackbar("Erro ao buscar os dados da empresa.");
        }
      } catch (e) {
        print("Erro de conexão: $e");
        _showErrorSnackbar("Erro de conexão ao buscar os dados da empresa.");
      }
    } else {
      print("Já existe um formulário ativo para esta empresa.");
    }
  }

  Future<void> processarRespostas(List<Map<String, dynamic>> answers) async {
    final uri = Uri.parse(
        '$URL/auth/processarRespostas?empresa_id=$companySelected&is_complete=true');

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(answers),
      );

      if (response.statusCode == 200) {
        print('Respostas enviadas com sucesso!');

        // Processar as respotas para a pagina de resultados
        final data =
            jsonDecode(utf8.decode(response.bodyBytes)); 

        List<Map<String, dynamic>> resultado =
            processarDadosResultadoAvaliacao(data['respostas'], {
          "pontuacaoAmbiental": data['pontuacaoAmbiental'],
          "pontuacaoGovernamental": data['pontuacaoGovernamental'],
          "pontuacaoSocial": data['pontuacaoSocial']
        });

        setState(() {
          dadosResultadoAvaliacao = resultado;
          _currentIndex = 7;
        });
      } else {
        print('Erro ao enviar respostas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro de requisição: $e');
    }
  }

  processarDadosResultadoAvaliacao(dynamic answers, dynamic percentages) {
    // Filtrando dados para cada eixo específico
    List<dynamic> socialData = answers
        .where((answer) => answer['pergunta']['eixo'] == 'Social')
        .toList();

    List<dynamic> governamentalData = answers
        .where((answer) => answer['pergunta']['eixo'] == 'Governamental')
        .toList();

    List<dynamic> ambientalData = answers
        .where((answer) => answer['pergunta']['eixo'] == 'Ambiental')
        .toList();

    // Transformando os dados filtrados em estrutura similar a _screenData
    return [
      {
        'title': 'Governamental',
        'color': Colors.blue,
        'questions': governamentalData.map((answer) {
          return {
            "question": answer['pergunta']['descricao'],
            "status": formatStatus(answer['resposta'])
          };
        }).toList(),
        'percentage': percentages['pontuacaoGovernamental'],
      },
      {
        'title': 'Ambiental',
        'color': Colors.green,
        'questions': ambientalData.map((answer) {
          return {
            "question": answer['pergunta']['descricao'],
            "status": formatStatus(answer['resposta'])
          };
        }).toList(),
        'percentage': percentages['pontuacaoAmbiental'],
      },
      {
        'title': 'Social',
        'color': Colors.orange,
        'questions': socialData.map((answer) {
          return {
            "question": answer['pergunta']['descricao'],
            "status": formatStatus(answer['resposta'])
          };
        }).toList(),
        'percentage': percentages['pontuacaoSocial'],
      },
    ];
  }

  String formatStatus(String status) {
    switch (status) {
      case 'Conforme':
        return 'Conforme';
      case 'NaoConforme':
        return 'Não conforme';
      case 'NaoSeAdequa':
        return 'Não se aplica';
      default:
        return status;
    }
  }

  Future<void> exportPDF(String nomeFantasia) async {
    // Cria o Uri diretamente
    final uri = Uri.parse('$URL/pdf/getPdf/$companySelected');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Não foi possível abrir o PDF';
    }
  }
}

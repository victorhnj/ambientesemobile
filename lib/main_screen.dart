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

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 7;
  bool isFormulario = true;

  String tituloDoFormulario = '';
  List<String> colunas = [];
  // List<List<dynamic>> dados = [];
  List<Map<String, dynamic>> dados = [];

  Map<String, dynamic>? initialData;

  int currentPage = 0;

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
            _fetchDataEmpresa(value);
          },
          isSelectable: false,
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
            _fetchDataPerguntas(value);
          },
          isSelectable: isFormulario,
          createFormulario: (selectedIds) {
            _createFormulario(selectedIds);
          },
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
            _fetchDataFuncionarios(value);
          },
          isSelectable: false,
        ),
        CadastroForm(onTap: _onItemTapped, initialData: initialData, onSave: (updatedData, isEdit) {
          (isEdit == 1) ? _editEmpresa(initialData?['id'], updatedData) : _addEmpresa(updatedData);
        },),
        CadastroPerguntaForm(onTap: _onItemTapped, initialData: initialData, onSave: (updatedData, isEdit) {
          (isEdit == 1) ? _editPergunta(initialData?['id'], updatedData) : _addPergunta(updatedData);
        },),
        CadastroFuncionarioForm(onTap: _onItemTapped, initialData: initialData, onSave: (updatedData, isEdit) {
          (isEdit == 1) ? _editFuncionario(initialData?['id'], updatedData) : _addFuncionario(updatedData); 
        },),
        TelaInicial(onTap: _onItemTapped),
        ResultadosEmpresaScreen(companyName: 'Johnson & Johnson'),
        
      ];

  @override
  void initState() {
    super.initState();
    _fetchDataEmpresa(); // Busca inicial dos dados de empresas
  }

  void _fetchDataEmpresa([search = '']) async {
    final resultado = await buscarDadosEmpresa(currentPage, search);
    setState(() {
      dados = resultado as List<Map<String, dynamic>>;
      tituloDoFormulario = 'EMPRESAS';
      colunas = ['Nome', 'Ramo', 'Porte'];
    });
  }

  void _fetchDataPerguntas([search = '']) async {
    final resultado = await buscarDadosPerguntas(currentPage, search);
    setState(() {
      dados = resultado as List<Map<String, dynamic>>;
      tituloDoFormulario = 'PERGUNTAS';
      colunas = ['Pergunta', 'Eixo'];
    });
  }

  void _fetchDataFuncionarios([search = '']) async {
    final resultado = await buscarDadosFuncionarios(currentPage, search);
    setState(() {
      dados = resultado as List<Map<String, dynamic>>;
      tituloDoFormulario = 'FUNCIONÁRIOS';
      colunas = ['Nome', 'Cargo'];
    });
  }


  void _incrementPage() {
    setState(() {
      currentPage += 1;
    });
    _fetchCurrentData(); // Busca dados da próxima página
  }

  void _decrementPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage -= 1;
      });
      _fetchCurrentData(); // Busca dados da página anterior
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
      currentPage = 0; // Resetar para a primeira página ao mudar de tela
      this.isFormulario = isFormulario != null ? true : false;
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

    if (Scaffold.of(context).isDrawerOpen) {
      // Navigator.pop(context);
    }
  }

  // Função para buscar dados da empresa
  Future<List<dynamic>> buscarDadosEmpresa(int page, [String search = '']) async {
    try {
      final queryParams = <String, String>{'nome': search, 'page': page.toString()};
      final uri = Uri.parse('$URL/auth/Empresa/search').replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> resultado = jsonDecode(utf8.decode(response.bodyBytes));;

        return resultado.map((item) {
          return {
            'id': item['id'], // Inclui o ID
            'Nome': item['nomeFantasia'] ?? '', // Nome
            'Porte': item['porteEmpresas'] ?? '', // Porte
            'Ramo': item['ramo'] ?? '',          // Ramo
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
  Future<List<dynamic>> buscarDadosPerguntas(int page, [String search = '']) async {
    try {
      final queryParams = <String, String>{'nome': search, 'page': page.toString()};
      final uri = Uri.parse('$URL/auth/Perguntas/search').replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> resultado = jsonDecode(utf8.decode(response.bodyBytes));

        return resultado.map((item) {
          return {
            'id': item['id'], // Inclui o ID
            'Pergunta': item['descricao'] ?? '', // Nome
            'Eixo': item['eixo'] ?? '', // Porte
            'isSelected': false, // Porte
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
  Future<List<dynamic>> buscarDadosFuncionarios(int page, [String search = '']) async {
    try {
      final queryParams = <String, String>{'nome': search, 'page': page.toString()};
      final uri = Uri.parse('$URL/auth/Funcionario/search').replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> resultado = jsonDecode(utf8.decode(response.bodyBytes));

        return resultado.map((item) {
          return {
            'id': item['id'], // Inclui o ID
            'Nome': item['nome'] ?? '', // Nome
            'Cargo': item['cargo']['descricao'] ?? '', // Porte
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
          // Remove the item from the list after deletion
          dados.removeWhere((item) => item['id'] == id);
        });
        print("Empresa excluída com sucesso: ID $id");
      } else {
        print("Erro ao excluir a empresa: ${response.statusCode}");
        // Optionally, show a message to the user
        _showErrorSnackbar("Erro ao excluir a empresa.");
      }
    } catch (e) {
      print("Erro de conexão: $e");
      _showErrorSnackbar("Erro de conexão ao excluir a empresa.");
    }
  }

  Future<void> _deletePergunta(int id) async {
    final uri = Uri.parse('$URL/auth/Pergunta/Delete/$id');
    
    try {
      final response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          // Remove the item from the list after deletion
          dados.removeWhere((item) => item['id'] == id);
        });
        print("Pergunta excluída com sucesso: ID $id");
      } else {
        print("Erro ao excluir a pergunta: ${response.statusCode}");
        // Optionally, show a message to the user
        _showErrorSnackbar("Erro ao excluir a pergunta.");
      }
    } catch (e) {
      print("Erro de conexão: $e");
      _showErrorSnackbar("Erro ao deletar, a pergunta está sendo utilizadas em avaliações.");
    }
  }

  Future<void> _deleteFuncionario(int id) async {
    final uri = Uri.parse('$URL/auth/Funcionario/Delete/$id');
    
    try {
      final response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          // Remove the item from the list after deletion
          dados.removeWhere((item) => item['id'] == id);
        });
        print("Funcionario excluído com sucesso: ID $id");
      } else {
        print("Erro ao excluir o funcionario: ${response.statusCode}");
        // Optionally, show a message to the user
        _showErrorSnackbar("Erro ao excluir o funcionario.");
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
        final dynamic decodedResponse = jsonDecode(response.body);
        
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

  Future<void> _editFuncionario(int id, Map<String, dynamic> updatedData) async {
    final uri = Uri.parse('$URL/auth/Funcionario/Edit/$id');
    try {
      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        // Update local data or refresh list
        print("Funcionario editado com sucesso");

        _fetchDataFuncionarios();
        setState(() {
          initialData = null;
          _currentIndex = 2;
        });
      } else {
        print("Erro ao editar funcionario");
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
        // Successfully added, refresh list or update local data
        print("Funcionário adicionada com sucesso");

        _fetchDataFuncionarios();
        setState(() {
          _currentIndex = 2; // Switches to a different tab or state if needed
        });
      } else {
        print("Erro ao adicionar funcionário");
      }
    } catch (e) {
      print("Erro de conexão: $e");
    }
  }


  Future<void> _fetchEmpresa(int id) async {
    final uri = Uri.parse('$URL/auth/Empresa/$id');
    
    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        
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
        // Update local data or refresh list
        print("Empresa editada com sucesso");

        _fetchDataEmpresa();
        setState(() {
          initialData = null;
          _currentIndex = 2;
        });
      } else {
        print("Erro ao editar empresa");
      }
    } catch (e) {
      print("Erro de conexão: $e");
    }
  }

  Future<void> _addEmpresa(Map<String, dynamic> newData) async {
    final uri = Uri.parse('$URL/auth/Empresa/Add');
    print("Iniciando adição de nova empresa");

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(newData),
      );

      if (response.statusCode == 200) {
        // Successfully added, refresh list or update local data
        print("Empresa adicionada com sucesso");

        _fetchDataFuncionarios();
        setState(() {
          _currentIndex = 2; // Switches to a different tab or state if needed
        });
      } else {
        print("Erro ao adicionar empresa");
      }
    } catch (e) {
      print("Erro de conexão: $e");
    }
  }


  // Perguntas 
  Future<void> _fetchPergunta(int id) async {
    final uri = Uri.parse('$URL/auth/Perguntas/$id');
    
    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        
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
        // Update local data or refresh list
        print("Pergunta editada com sucesso");

        _fetchDataPerguntas();
        setState(() {
          initialData = null;
          _currentIndex = 1;
        });
      } else {
        print("Erro ao editar pergunta");
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
        // Successfully added, refresh list or update local data
        print("Pergunta adicionada com sucesso");

        _fetchDataPerguntas();
        setState(() {
          _currentIndex = 1; // Switches to a different tab or state if needed
        });
      } else {
        print("Erro ao adicionar pergunta");
      }
    } catch (e) {
      print("Erro de conexão: $e");
    }
  }


  Future<void> _createFormulario(List<int> selectedIds) async {
    final uri = Uri.parse('$URL/auth/Pergunta/Delete/');
    print("selectedIds: $selectedIds");
    
    try {
      final response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          // Remove the item from the list after deletion
          // dados.removeWhere((item) => item['id'] == id);
        });
        // print("Pergunta excluída com sucesso: ID $id");
      } else {
        print("Erro ao excluir a pergunta: ${response.statusCode}");
        // Optionally, show a message to the user
        _showErrorSnackbar("Erro ao excluir a pergunta.");
      }
    } catch (e) {
      print("Erro de conexão: $e");
      _showErrorSnackbar("Erro ao deletar, a pergunta está sendo utilizadas em avaliações.");
    }
  }


  static const String URL = 'http://localhost:8080';
  Map<String, String> headers = {
    'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJyb290IiwiY2FyZ28iOiJBZG1pbiIsImV4cCI6MTczMjYwMDUwMH0.FEAYxrG6VU8IoUQ6G6YkP3mrxK05Exz9oYFdBXaMy5A',
    'Content-Type': 'application/json; charset=UTF-8',
  };
}

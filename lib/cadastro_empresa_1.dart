import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'header.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CadastroForm(onTap: (int ) {  },),
    );
  }
}

class CadastroForm extends StatefulWidget {
  final Function(int) onTap;
  final Map<String, dynamic>? initialData;
  final void Function(Map<String, dynamic> updatedData, int indexTelaFormulario)? onSave;

  CadastroForm({required this.onTap, this.initialData,  this.onSave});

  @override
  _CadastroFormState createState() => _CadastroFormState();
}

class _CadastroFormState extends State<CadastroForm> {
  int _currentIndex = 0; // Índice para controlar o formulário atual
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeFantasiaController = TextEditingController();
  final TextEditingController _razaoSocialController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();

  final TextEditingController _inscricaoSocialController = TextEditingController();
  final TextEditingController _telefoneEmpresasController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ramoController = TextEditingController();
  String? _porteSelecionado;

  final TextEditingController _nomeSolicitanteController = TextEditingController();
  final TextEditingController _telefoneSolicitanteController = TextEditingController();


@override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _nomeFantasiaController.text = widget.initialData!['nomeFantasia'] ?? '';
      _razaoSocialController.text = widget.initialData!['razaoSocial'] ?? '';
      _cnpjController.text = widget.initialData!['cnpj'] ?? '';
      _inscricaoSocialController.text = widget.initialData!['inscricaoSocial'] ?? '';
      _telefoneEmpresasController.text = widget.initialData!['telefoneEmpresas'] ?? '';
      _cepController.text = widget.initialData!['endereco']?['cep'] ?? '';
      _ufController.text = widget.initialData!['endereco']?['uf'] ?? '';
      _cidadeController.text = widget.initialData!['endereco']?['cidade'] ?? '';
      _bairroController.text = widget.initialData!['endereco']?['bairro'] ?? '';
      _logradouroController.text = widget.initialData!['endereco']?['logradouro'] ?? '';
      _numeroController.text = widget.initialData!['endereco']!['numero'].toString();
      _emailController.text = widget.initialData!['email'] ?? '';
      _ramoController.text = widget.initialData!['ramo'] ?? '';
      _porteSelecionado = widget.initialData!['porteEmpresas'];
      _nomeSolicitanteController.text = widget.initialData!['nomeSolicitante'] ?? '';
      _telefoneSolicitanteController.text = widget.initialData!['telefoneSolicitante'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pega a altura e largura da tela
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Center(
            child: IntrinsicHeight(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 150,
                ),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_currentIndex == 0) _buildEmpresaForm(height, width),
                      if (_currentIndex == 1) _buildEnderecoForm(height, width),
                      if (_currentIndex == 2) _buildInformacoesPessoaisForm(height, width),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Primeiro formulário - Empresa
  Widget _buildEmpresaForm(double height, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Empresa', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _nomeFantasiaController,
          decoration: InputDecoration(
            labelText: 'Nome Fantasia',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _razaoSocialController,
          decoration: InputDecoration(
            labelText: 'Razão Social',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _cnpjController,
          decoration: InputDecoration(
            labelText: 'CNPJ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _inscricaoSocialController,
          decoration: InputDecoration(
            labelText: 'Inscrição Social',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _telefoneEmpresasController,
          decoration: InputDecoration(
            labelText: 'Telefone da Empresa',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.02),
        DropdownButtonFormField<String>(
          value: _porteSelecionado,
          decoration: InputDecoration(
            labelText: 'Porte da Empresa',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          items: ['Pequeno', 'Médio', 'Grande']
              .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _porteSelecionado = value;
            });
          },
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _ramoController,
          decoration: InputDecoration(
            labelText: 'Ramo',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.04),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  widget.onTap(0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                child: Text(
                  'Cancelar',
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
                onPressed: null, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _currentIndex = 1;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                child: Text(
                  'Próximo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Segundo formulário - Endereço
  Widget _buildEnderecoForm(double height, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Endereço', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _cepController,
          decoration: InputDecoration(
            labelText: 'CEP',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _ufController,
          decoration: InputDecoration(
            labelText: 'UF',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _cidadeController,
          decoration: InputDecoration(
            labelText: 'Cidade',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _bairroController,
          decoration: InputDecoration(
            labelText: 'Bairro',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _logradouroController,
          decoration: InputDecoration(
            labelText: 'Rua',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _numeroController,
          decoration: InputDecoration(
            labelText: 'Número',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.04),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  widget.onTap(0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                child: Text(
                  'Cancelar',
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
                onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _currentIndex = 2;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                child: Text(
                  'Próximo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Terceiro formulário - Informações Pessoais
  Widget _buildInformacoesPessoaisForm(double height, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Informações pessoais', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _nomeSolicitanteController,
          decoration: InputDecoration(
            labelText: 'Nome do solicitante',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _telefoneSolicitanteController,
          decoration: InputDecoration(
            labelText: 'Telefone do solicitante',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        SizedBox(height: height * 0.04),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  widget.onTap(0);
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12), 
                ),
                child: Text(
                  'Cancelar',
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
                onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedData = {
                      'nomeFantasia': _nomeFantasiaController.text,
                      'razaoSocial': _razaoSocialController.text,
                      'cnpj': _cnpjController.text,
                      'inscricaoSocial': _inscricaoSocialController.text,
                      'telefoneEmpresas': _telefoneEmpresasController.text,
                      'endereco': {
                        'cep': _cepController.text,
                        'uf': _ufController.text,
                        'cidade': _cidadeController.text,
                        'bairro': _bairroController.text,
                        'logradouro': _logradouroController.text,
                        'numero': int.tryParse(_numeroController.text) ?? 0, 
                      },
                      'email': _emailController.text,
                      'ramo': _ramoController.text,
                      'porteEmpresas': _porteSelecionado,
                      'nomeSolicitante': _nomeSolicitanteController.text,
                      'telefoneSolicitante': _telefoneSolicitanteController.text,
                    };

                    if (widget.onSave != null) {
                      widget.initialData == null ? widget.onSave!(updatedData, 0) : widget.onSave!(updatedData, 1);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                child: Text(
                  widget.initialData == null ? 'Adicionar' : 'Salvar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

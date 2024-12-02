import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'header.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CadastroForm(
        onTap: (int) {},
      ),
    );
  }
}

class CadastroForm extends StatefulWidget {
  final Function(int) onTap;
  final Map<String, dynamic>? initialData;
  final void Function(
      Map<String, dynamic> updatedData, int indexTelaFormulario)? onSave;
  final String? errorMessage;

  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _telefoneEmpresaMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _telefoneSolicitanteMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  CadastroForm(
      {required this.onTap, this.initialData, this.onSave, this.errorMessage});

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

  final TextEditingController _inscricaoSocialController =
      TextEditingController();
  final TextEditingController _telefoneEmpresasController =
      TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _ramoController;
  String? _porteSelecionado;

  final TextEditingController _nomeSolicitanteController =
      TextEditingController();
  final TextEditingController _telefoneSolicitanteController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _nomeFantasiaController.text = widget.initialData!['nomeFantasia'] ?? '';
      _razaoSocialController.text = widget.initialData!['razaoSocial'] ?? '';
      _inscricaoSocialController.text =
          widget.initialData!['inscricaoSocial'] ?? '';
      _cepController.text = widget.initialData!['endereco']?['cep'] ?? '';
      _ufController.text = widget.initialData!['endereco']?['uf'] ?? '';
      _cidadeController.text = widget.initialData!['endereco']?['cidade'] ?? '';
      _bairroController.text = widget.initialData!['endereco']?['bairro'] ?? '';
      _logradouroController.text =
          widget.initialData!['endereco']?['logradouro'] ?? '';
      _numeroController.text =
          widget.initialData!['endereco']!['numero'].toString();
      _emailController.text = widget.initialData!['email'] ?? '';
      _ramoController = widget.initialData!['ramo'] ?? '';
      _porteSelecionado = widget.initialData!['porteEmpresas'];
      _nomeSolicitanteController.text =
          widget.initialData!['nomeSolicitante'] ?? '';

      final cnpj = widget.initialData!['cnpj'] ?? '';
      _cnpjController.text = widget._cnpjMask?.maskText(cnpj) ?? cnpj;

      final telefoneSolicitante =
          widget.initialData!['telefoneSolicitante'] ?? '';
      if (telefoneSolicitante.isNotEmpty) {
        _telefoneSolicitanteController.text =
            widget._telefoneSolicitanteMask.maskText(telefoneSolicitante);
      }

      final telefoneEmpresa = widget.initialData!['telefoneEmpresas'] ?? '';
      if (telefoneEmpresa.isNotEmpty) {
        _telefoneEmpresasController.text =
            widget._telefoneEmpresaMask.maskText(telefoneEmpresa);
      }

      final cep = widget.initialData!['endereco']?['cep'] ?? '';
      if (cep.isNotEmpty) {
        _cepController.text = widget._cepMask.maskText(cep);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      if (_currentIndex == 2)
                        _buildInformacoesPessoaisForm(height, width),
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
        Text('Empresa',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _nomeFantasiaController,
          decoration: InputDecoration(
            labelText: 'Nome Fantasia',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o nome fantasia';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _razaoSocialController,
          decoration: InputDecoration(
            labelText: 'Razão Social',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira a razão social';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          inputFormatters: [widget._cnpjMask],
          controller: _cnpjController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'CNPJ',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o CNPJ';
            } else if (widget._cnpjMask.getUnmaskedText() != '' &&
                widget._cnpjMask.getUnmaskedText().length != 14) {
              return 'CNPJ inválido';
            } else if (_cnpjController.text.length != 18) {
              return 'CNPJ inválido';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _inscricaoSocialController,
          decoration: InputDecoration(
            labelText: 'Inscrição Social',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira a inscrição social';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _telefoneEmpresasController,
          inputFormatters: [widget._telefoneEmpresaMask], // Adiciona a máscara
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Telefone da Empresa',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o telefone da empresa';
            } else if (widget._telefoneEmpresaMask.getUnmaskedText() != '' &&
                widget._telefoneEmpresaMask.getUnmaskedText().length != 11) {
              print(
                  'entrou primeiro ${widget._telefoneEmpresaMask.getUnmaskedText().length}');
              return 'Telefone inválido';
            } else if (_telefoneEmpresasController.text.length != 15) {
              print(
                  'entrou segundo ${_telefoneEmpresasController.text.length}');

              return 'Telefone inválido';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),
        DropdownButtonFormField<String>(
          value: _porteSelecionado,
          decoration: InputDecoration(
            labelText: 'Porte da Empresa',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, selecione o porte da empresa';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),

        DropdownButtonFormField<String>(
          value: _ramoController,
          decoration: InputDecoration(
            labelText: 'Ramo da Empresa',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          items:
              ['Automotivo', 'Indústria', 'Educação', 'Comércio', 'Agricultura']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
          onChanged: (value) {
            setState(() {
              _ramoController = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, selecione o ramo da empresa';
            }
            return null;
          },
        ),


        SizedBox(height: height * 0.11),
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
        Text('Endereço',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _cepController,
          inputFormatters: [widget._cepMask],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'CEP',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o CEP';
            } else if (widget._cepMask.getUnmaskedText() != '' &&
                widget._cepMask.getUnmaskedText().length != 8) {
              return 'CEP inválido';
            } else if (_cepController.text.length != 9) {
              return 'CEP inválido';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _ufController,
          decoration: InputDecoration(
            labelText: 'UF',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira a UF';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _cidadeController,
          decoration: InputDecoration(
            labelText: 'Cidade',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira a cidade';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _bairroController,
          decoration: InputDecoration(
            labelText: 'Bairro',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o bairro';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _logradouroController,
          decoration: InputDecoration(
            labelText: 'Rua',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira a rua';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _numeroController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Número',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o número';
            } else if (int.tryParse(value) == null) {
              return 'Por favor, insira apenas números';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.195),
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
        Text('Informações pessoais',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _nomeSolicitanteController,
          decoration: InputDecoration(
            labelText: 'Nome do solicitante',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o nome do solicitante';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _telefoneSolicitanteController,
          inputFormatters: [widget._telefoneSolicitanteMask],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Telefone do solicitante',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o telefone do solicitante';
            } else if (widget._telefoneSolicitanteMask.getUnmaskedText() !=
                    '' &&
                widget._telefoneSolicitanteMask.getUnmaskedText().length !=
                    11) {
              return 'Telefone inválido';
            } else if (_telefoneSolicitanteController.text.length != 15) {
              return 'Telefone inválido';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o email';
            }
            return null;
          },
        ),
        SizedBox(height: height * 0.45),
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
                      'cnpj': widget._cnpjMask.getUnmaskedText() != ''
                          ? widget._cnpjMask.getUnmaskedText()
                          : limparCnpj(_cnpjController.text),
                      'inscricaoSocial': _inscricaoSocialController.text,
                      'telefoneEmpresas':
                          widget._telefoneEmpresaMask.getUnmaskedText() != ''
                              ? widget._telefoneEmpresaMask.getUnmaskedText()
                              : _telefoneEmpresasController.text,
                      'endereco': {
                        'cep': widget._cepMask.getUnmaskedText() != ''
                            ? widget._cepMask.getUnmaskedText()
                            : _cepController.text,
                        'uf': _ufController.text,
                        'cidade': _cidadeController.text,
                        'bairro': _bairroController.text,
                        'logradouro': _logradouroController.text,
                        'numero': int.tryParse(_numeroController.text) ?? 0,
                      },
                      'email': _emailController.text,
                      'ramo': _ramoController,
                      'porteEmpresas': _porteSelecionado,
                      'nomeSolicitante': _nomeSolicitanteController.text,
                      'telefoneSolicitante': widget._telefoneSolicitanteMask
                                  .getUnmaskedText() !=
                              ''
                          ? widget._telefoneSolicitanteMask.getUnmaskedText()
                          : _telefoneSolicitanteController.text,
                    };

                    if (widget.onSave != null) {
                      widget.initialData == null
                          ? widget.onSave!(updatedData, 0)
                          : widget.onSave!(updatedData, 1);
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

String limparCnpj(String cnpj) {
  return cnpj.replaceAll(RegExp(r'[^0-9]'), '');
}

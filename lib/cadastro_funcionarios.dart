import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CadastroFuncionarioForm(onTap: (int ) {  },),
    );
  }
}

class CadastroFuncionarioForm extends StatefulWidget {
  final Function(int) onTap;
  final Map<String, dynamic>? initialData;
  final void Function(Map<String, dynamic> updatedData, int indexTelaFormulario)? onSave;

  CadastroFuncionarioForm({required this.onTap, this.initialData,  this.onSave});

  @override
  _CadastroFuncionarioFormState createState() => _CadastroFuncionarioFormState();
}

class _CadastroFuncionarioFormState extends State<CadastroFuncionarioForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String? _cargoSelecionado;

  @override
  void initState() {
    super.initState();

    // Check if initialData is provided and fill the form fields
    if (widget.initialData != null) {
      _nomeController.text = widget.initialData!['nome'] ?? '';
      _cpfController.text = widget.initialData!['cpf'] ?? '';
      _dataNascimentoController.text = widget.initialData!['dataNascimento'] ?? '';
      _emailController.text = widget.initialData!['email'] ?? '';
      _loginController.text = widget.initialData!['usuario']?['login'] ?? '';
      _senhaController.text = widget.initialData!['usuario']?['password'] ?? '';
      _cargoSelecionado = widget.initialData!['cargo']?['descricao'];
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _dataNascimentoController.dispose();
    _emailController.dispose();
    _loginController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

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
                  minHeight: height - 150, //* 0.85
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
                      Text(
                        'Funcionário',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: height * 0.02),
                      TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      TextFormField(
                        controller: _cpfController,
                        decoration: InputDecoration(
                          labelText: 'CPF',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o CPF';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      TextFormField(
                        controller: _dataNascimentoController,
                        decoration: InputDecoration(
                          labelText: 'Data de Nascimento',
                          hintText: 'DD/MM/AAAA',
                          suffixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a data de nascimento';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      TextFormField(
                        controller: _loginController,
                        decoration: InputDecoration(
                          labelText: 'Login',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o login';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      TextFormField(
                        controller: _senhaController,
                        obscureText: true,
                        enabled: widget.initialData == null ? true : false, // Disables the field for editing
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a senha';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      DropdownButtonFormField<String>(
                        value: _cargoSelecionado,
                        decoration: InputDecoration(
                          labelText: 'Cargo',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        items: ['Consultor', 'Gestor']
                            .map((label) => DropdownMenuItem(
                                  child: Text(label),
                                  value: label,
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _cargoSelecionado = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, selecione o cargo';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.04),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                widget.onTap(2);
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
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Collect the updated data from the form fields
                                  Map<String, Object?> updatedData = {};
                                  if (widget.initialData == null) {
                                    updatedData = {
                                      'nome': _nomeController.text,
                                      'cpf': _cpfController.text,
                                      'dataNascimento': _dataNascimentoController.text,
                                      'email': _emailController.text,
                                      'cargo': _cargoSelecionado,
                                      'usuario': {
                                        'isAdmin': false,
                                        'login': _loginController.text,
                                        'password': _senhaController.text,
                                      },
                                    };
                                  } else {
                                    updatedData = {
                                      'nome': _nomeController.text,
                                      'cpf': _cpfController.text,
                                      'dataNascimento': _dataNascimentoController.text,
                                      'email': _emailController.text,
                                      'login': _loginController.text,
                                      'cargo': _cargoSelecionado,
                                    };
                                  }
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
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
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
}

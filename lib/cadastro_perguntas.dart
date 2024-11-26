import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CadastroPerguntaForm(onTap: (int ) {  },),
    );
  }
}

class CadastroPerguntaForm extends StatefulWidget {
  final Function(int) onTap;
  final Map<String, dynamic>? initialData;
  final void Function(Map<String, dynamic> updatedData, int indexTelaFormulario)? onSave;

  CadastroPerguntaForm({required this.onTap, this.initialData,  this.onSave});

  @override
  _CadastroPerguntaFormState createState() => _CadastroPerguntaFormState();
}

class _CadastroPerguntaFormState extends State<CadastroPerguntaForm> {
  int _currentIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _perguntaController = TextEditingController();

  String? _eixoSelecionado;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _perguntaController.text = widget.initialData!['descricao'] ?? '';
      _eixoSelecionado = widget.initialData!['eixo'];
    }
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
                    minHeight: height - 150,
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
                        'Pergunta',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: height * 0.02),
                      DropdownButtonFormField<String>(
                        value: _eixoSelecionado,
                        decoration: InputDecoration(
                          labelText: 'Eixo da pergunta',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        items: ['Ambiental', 'Governamental', 'Social'] // Exemplo de opções
                            .map((label) => DropdownMenuItem(
                                  child: Text(label),
                                  value: label,
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _eixoSelecionado = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, selecione o eixo da pergunta';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      TextFormField(
                        controller: _perguntaController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Pergunta',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a pergunta';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.04),
                      Spacer(), // Adiciona espaço flexível para empurrar os botões para o final
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                widget.onTap(1);
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
                                  final updatedData = {
                                    'descricao': _perguntaController.text,
                                    'eixo': _eixoSelecionado,
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

import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  final Function(int, [bool]) onTap;

  const TelaInicial({Key? key, required this.onTap}) : super(key: key);

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Center(
            child: IntrinsicHeight(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: height - 150,
                ),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue[100],
                      child: const Icon(
                        Icons.person,
                        size: 70,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Bem-vindo!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Conheça algumas das principais ações que você pode realizar...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit, color: Color(0xFF0D47A1)),
                      label: const Text(
                        'Realizar Avaliação',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF0D47A1)),
                      ),
                      onPressed: () => widget.onTap(1, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[50],
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person_add,
                          color: Color(0xFF0D47A1)),
                      label: const Text(
                        'Cadastrar Empresa',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF0D47A1)),
                      ),
                      onPressed: () => widget.onTap(3),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[50],
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.question_answer,
                          color: Color(0xFF0D47A1)),
                      label: const Text(
                        'Adicionar Pergunta',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF0D47A1)),
                      ),
                      onPressed: () => widget.onTap(4),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[50], // Fundo azul claro
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon:
                          const Icon(Icons.group_add, color: Color(0xFF0D47A1)),
                      label: const Text(
                        'Adicionar Funcionário',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF0D47A1)),
                      ),
                      onPressed: () => widget.onTap(5),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[50], // Fundo azul claro
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: const Color(0xFF0077C8), // Mesma cor de fundo
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80, // Altura ajustada conforme a tela de login
                child: Image.asset(
                  'images/logo.png', // Logo da sua aplicação
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Ação para o menu lateral
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person,
                  size: 60, color: Colors.black), // Ícone de pessoa em preto
            ),
            const SizedBox(height: 16),
            const Text(
              'Bem vindo!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black), // Texto em preto
            ),
            const SizedBox(height: 8),
            const Text(
              'Conheça algumas das principais opções que você pode realizar...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black), // Texto em preto
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon:
                  const Icon(Icons.edit, color: Colors.black), // Ícone em preto
              label: const Text(
                'Realizar Avaliação',
                style: TextStyle(color: Colors.black), // Texto em preto
              ),
              onPressed: () {
                // Navegar para a tela de avaliação
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white, // Fundo branco para o botão
                side: BorderSide(color: Colors.black), // Borda preta
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add,
                  color: Colors.black), // Ícone em preto
              label: const Text(
                'Cadastrar Empresa',
                style: TextStyle(color: Colors.black), // Texto em preto
              ),
              onPressed: () {
                // Navegar para a tela de cadastro de empresa
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white, // Fundo branco para o botão
                side: BorderSide(color: Colors.black), // Borda preta
              ),
            ),
          ],
        ),
      ),
    );
  }
}

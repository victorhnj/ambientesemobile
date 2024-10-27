import 'package:ambientese/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            backgroundColor: Color(0xFF0077C8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(
                  height: 80, // Aumentado de 60 para 80
                  child: Image.asset(
                  'images/logo.png', // Logo da sua aplicação
                  ),
                ),
                ],
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'images/background_login.jpg'), // Imagem de fundo
                  fit: BoxFit.cover,
                ),
              ),
            ),
            LoginForm(), // O formulário de login
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/login'), // URL da API
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'login': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Sucesso no login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Bem-Sucedido!'),
            backgroundColor: Color(0xFF2ecc71),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
                top: 10.0, right: 10.0, left: 300.0, bottom: 830),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else if (response.statusCode == 401) {
        // Falha no login
        setState(() {
          _hasError = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Usuário ou Senha incorretos!'),
              backgroundColor: Color.fromARGB(255, 204, 64, 46),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                  top: 10.0, right: 10.0, left: 250.0, bottom: 830),
            ),
          );
        });
      } else {
        // Erro interno do servidor
        setState(() {
          _errorMessage = 'Erro interno do servidor';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao fazer login. Tente novamente mais tarde.';
      });
      print('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: 400.0,
        height: 500.0,
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Adicionando o texto "LOGIN" aqui
            Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF363636),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuário ou Email',
                labelStyle: TextStyle(
                    color: _hasError
                        ? Colors.red
                        : Color.fromARGB(255, 54, 54, 54)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: _hasError
                          ? Colors.red
                          : Color.fromARGB(255, 54, 54, 54)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: _hasError
                          ? Colors.red
                          : Color.fromARGB(255, 54, 54, 54),
                      width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(
                    color: _hasError
                        ? Colors.red
                        : Color.fromARGB(255, 54, 54, 54)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: _hasError
                          ? Colors.red
                          : Color.fromARGB(255, 54, 54, 54)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: _hasError
                          ? Colors.red
                          : Color.fromARGB(255, 54, 54, 54),
                      width: 2.0),
                ),
              ),
              obscureText: true,
            ),
            if (_hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Ação para 'Esqueci minha senha'
                },
                child: Text(
                  'Esqueci minha senha',
                  style: TextStyle(color: Colors.black),
                ),
                style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.grey.withOpacity(0.2)),
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1681CA),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
            SizedBox(height: 40), // Aumenta o espaçamento antes dos ícones
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(), // Adiciona um espaço flexível
                IconButton(
                  icon: ImageIcon(
                    AssetImage('images/whatswhite.png'),
                    size: 52.42, // 43.68 * 1.2
                    color: Colors.green, // Cor verde para WhatsApp
                  ),
                  onPressed: () {
                    // Ação para WhatsApp
                  },
                ),
                SizedBox(width: 30), // Espaçamento de 30px
                IconButton(
                  icon: ImageIcon(
                    AssetImage('images/instawhite.png'),
                    size: 52.42, // 43.68 * 1.2
                    color: Colors.orange, // Cor laranja para Instagram
                  ),
                  onPressed: () {
                    // Ação para Instagram
                  },
                ),
                SizedBox(width: 30), // Espaçamento de 30px
                IconButton(
                  icon: ImageIcon(
                    AssetImage('images/facewhite.png'),
                    size: 52.42, // 43.68 * 1.2
                    color: Colors.blue, // Cor azul para Facebook
                  ),
                  onPressed: () {
                    // Ação para Facebook
                  },
                ),
                Spacer(), // Adiciona um espaço flexível
              ],
            ),
          ],
        ),
      ),
    );
  }
}

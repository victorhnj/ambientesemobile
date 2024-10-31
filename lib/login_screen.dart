import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'images/background_login.jpg'), // Imagem de fundo
                  fit: BoxFit.cover, // Ajusta a imagem para cobrir toda a tela
                ),
              ),
            ),
            Column(
              children: [
                AppBar(
                  backgroundColor: Color(0xFF0077C8),
                  centerTitle: true,
                  toolbarHeight: 70, // Ajuste a altura conforme necessário
                  title: Image.asset(
                    'images/logo.png',
                    height: 75, // Ajuste a altura conforme necessário
                  ),
                ),
                Expanded(
                  child: Center(
                    child: LoginForm(), // O formulário de login
                  ),
                ),
              ],
            ),
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
      } else if (response.statusCode == 401) {
        // Falha no login
        setState(() {
          _hasError = true;
          _errorMessage = 'Usuário ou Senha incorretos!';
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
        height: 600.0,
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
                height: 60.0), // Espaçamento no topo aumentado de 20 para 40
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
                    fontSize: 15.0,
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
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // Ação para 'Esqueci minha senha'
                },
                child: Text(
                  'Esqueci minha senha',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            if (_hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 10),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF1681CA),
                ),
              )
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1681CA),
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, // Reduzido de 50 para 40
                          vertical: 20), // Aumenta o tamanho do botão
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Menos arredondado
                      ),
                    ),
                    child: Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 40), // Aumenta o espaçamento antes dos ícones
            Spacer(
              //adicione uma borda na parte de cima
              flex: 10,
            ), // Adiciona um espaço flexível
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: ImageIcon(
                  AssetImage('images/whatswhite.png'),
                  size: 52.42, // 43.68 * 1.2
                  color: Colors.grey[600], // Cor cinza escuro meio claro
                  ),
                  onPressed: () async {
                  const url = 'https://api.whatsapp.com/send?phone=554430380838&text=Mensagem%20atrav%C3%A9s%20do%20site'; // Substitua pelo link desejado
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                  },
                ),
                SizedBox(width: 60), // Espaçamento de 60px
                IconButton(
                  icon: ImageIcon(
                    AssetImage('images/instawhite.png'),
                    size: 52.42, // 43.68 * 1.2
                    color: Colors.grey[600], // Cor cinza escuro meio claro
                  ),
                  onPressed: () async {
                  const url = 'https://www.instagram.com/ambientese.eng/'; // Substitua pelo link desejado
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                  },
                ),
                SizedBox(width: 60), // Espaçamento de 60px
                IconButton(
                  icon: ImageIcon(
                    AssetImage('images/facewhite.png'),
                    size: 52.42, // 43.68 * 1.2
                    color: Colors.grey[600], // Cor cinza escuro meio claro
                  ),
                  onPressed: () async {
                  const url = 'https://www.facebook.com/ambientese.eng/'; // Substitua pelo link desejado
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                  },
                ),
              ],
            ),
            Spacer(), // Adiciona um espaço flexível
          ],
        ),
      ),
    );
  }
}

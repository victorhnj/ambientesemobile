import 'package:ambientese/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.grey[800]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0D47A1)),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF0D47A1),
          selectionColor: Colors.blue[100],
          selectionHandleColor: Color(0xFF0D47A1),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue[50]),
            foregroundColor: MaterialStateProperty.all(Color(0xFF0D47A1)),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(Colors.white),
          fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Color(0xFF0D47A1);
              }
              return Colors.white;
            },
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF0D47A1),
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF0D47A1),
          ),
        ),
      ),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale('pt', 'BR'),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            backgroundColor: Color(0xFF0077C8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                  child: Image.asset(
                    'images/logo.png',
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String? token = prefs.getString('token');
                  if (token != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainScreen(token: token)),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/background_login.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            LoginForm(),
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
  String token = '';
  Timer? _inactivityTimer;

  String getToken() {
    return token;
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(Duration(minutes: 5), _logout);
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/login'),
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
        setState(() {
          token = json.decode(response.body)['token'];
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(token: token)),
        );
      } else if (response.statusCode == 401) {
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
  void initState() {
    super.initState();
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetInactivityTimer,
      onPanDown: (_) => _resetInactivityTimer,
      child: Center(
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
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  IconButton(
                    icon: ImageIcon(
                      AssetImage('images/whatswhite.png'),
                      size: 52.42,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      // Ação para WhatsApp
                    },
                  ),
                  SizedBox(width: 30),
                  IconButton(
                    icon: ImageIcon(
                      AssetImage('images/instawhite.png'),
                      size: 52.42,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      // Ação para Instagram
                    },
                  ),
                  SizedBox(width: 30),
                  IconButton(
                    icon: ImageIcon(
                      AssetImage('images/facewhite.png'),
                      size: 52.42,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      // Ação para Facebook
                    },
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

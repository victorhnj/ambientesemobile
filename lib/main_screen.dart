import 'package:flutter/material.dart';
import 'package:ambientese/header.dart';
import 'package:ambientese/custon_drawer.dart';
import 'cadastro_empresa_1.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(),
      drawer: CustomDrawer(),
      body: Center(
        child: CadastroForm(),
      ),
    );
  }
}
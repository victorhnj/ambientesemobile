import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int, [bool]) onTap;
  
  CustomDrawer({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF0077C8),
            ),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ExpansionTile(
            title: Text('Cadastro', style: TextStyle(fontSize: 18)),
            children: [
              ListTile(
                title: Text('Cadastrar Empresa'),
                onTap: () => onTap(0),
              ),
              ListTile(
                title: Text('Cadastrar Pergunta'),
                onTap: () => onTap(1),
              ),
              ListTile(
                title: Text('Cadastrar Funcionário'),
                onTap: () => onTap(2),
              ),
              // ListTile(
              //   title: Text('Cadastrar Formulário'),
              //   onTap: () => onTap(1, true),
              // ),
            ],
          ),
          ListTile(
            title: Text('Avaliação', style: TextStyle(fontSize: 18)),
            onTap: () => onTap(1, true),
          ),
          ListTile(
            title: Text('Ranking', style: TextStyle(fontSize: 18)),
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}
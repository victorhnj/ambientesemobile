import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
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
          ListTile(
            title: Text('Cadastro', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              
            },
          ),
          ListTile(
            title: Text('Ranking', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              
            },
          ),
          ListTile(
            title: Text('Avaliação', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              
            },
          ),
          ListTile(
            title: Text('Checklist', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              
            },
          ),
        ],
      ),
    );
  }
}
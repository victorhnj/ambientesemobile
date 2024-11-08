import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final Function(int) onTap;

  CustomHeader({required this.onTap});

  @override
  Size get preferredSize => Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFF0077C8),
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.white, size: 36.0),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            GestureDetector(
              onTap: () {
              onTap(6);
              },
              child: Container(
              padding: EdgeInsets.only(right: 16.0),
              child: SizedBox(
                height: 60,
                child: Image.asset(
                'images/logo.png',
                fit: BoxFit.contain,
                ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
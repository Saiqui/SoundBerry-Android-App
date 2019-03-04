import 'package:flutter/material.dart';

Widget menuGauche = Drawer(
  child: ListView(

    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        child: Text('Menu Gauche',
        style: TextStyle(color: Colors.white,)
        ),
        decoration: BoxDecoration(
          color: Colors.deepPurple[900],
        ),
      ),
    ],
  ),
);
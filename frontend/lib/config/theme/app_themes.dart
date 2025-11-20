import 'package:flutter/material.dart';

ThemeData theme() {
  final theme = ThemeData.light();
  return theme.copyWith(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    textTheme: theme.textTheme.apply(fontFamily: 'Butler'),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

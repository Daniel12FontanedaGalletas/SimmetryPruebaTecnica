import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: const Color(0xFF1D1D1D),
    fontFamily:
        'Muli', // Se puede cambiar por una fuente más estilizada si se añade
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFFC7C7C7)),
      bodyLarge: TextStyle(color: Color(0xFFC7C7C7)),
      titleLarge: TextStyle(color: Colors.white),
    ),
    appBarTheme: appBarTheme(),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF252525),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF252525),
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.blueAccent,
      background: Color(0xFF1D1D1D),
      surface: Color(0xFF252525),
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
  );
}

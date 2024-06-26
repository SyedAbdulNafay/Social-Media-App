import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        surface: Color(0xFF212121),
        primary: Color(0xFF272727),
        secondary: Color(0xFF404040),
        inversePrimary: Color(0xFFABF600)),
    textTheme: ThemeData.light()
        .textTheme
        .apply(bodyColor: Colors.grey[200], displayColor: Colors.white));

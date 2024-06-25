import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        background: Colors.black,
        primary: Colors.grey.shade900,
        secondary: Colors.grey.shade600,
        inversePrimary: Colors.white),
    textTheme: ThemeData.light()
        .textTheme
        .apply(bodyColor: Colors.grey[200], displayColor: Colors.white));

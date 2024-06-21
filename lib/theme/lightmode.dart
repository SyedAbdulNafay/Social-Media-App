import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        background: Colors.grey.shade300,
        primary: Colors.white,
        secondary: Colors.grey.shade500,
        inversePrimary: Colors.black),
    textTheme: ThemeData.light()
        .textTheme
        .apply(bodyColor: Colors.grey[800], displayColor: Colors.black));

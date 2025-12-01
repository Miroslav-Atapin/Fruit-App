import 'package:flutter/material.dart';

final appTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 135, 98)),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Color.fromARGB(255, 84, 66, 64),
    centerTitle: true,
    elevation: 0,
  ),
  tabBarTheme: TabBarThemeData(
    indicatorColor: const Color.fromARGB(255, 255, 135, 98),
    labelColor: const Color.fromARGB(255, 255, 135, 98),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) => Color.fromARGB(255, 255, 135, 98)),
    )
  ),
  textTheme: TextTheme(
    titleMedium: TextStyle(
      fontSize: 18,
    ),
    labelSmall: TextStyle(
      color: Colors.black.withAlpha(150),
      fontSize: 13
    ),
  ),
);

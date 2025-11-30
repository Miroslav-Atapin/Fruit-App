import 'package:flutter/material.dart';

final appTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primarySwatch: Colors.green,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    centerTitle: true,
    elevation: 0,
  ),
  tabBarTheme: TabBarThemeData(
    indicatorColor: const Color.fromARGB(255, 255, 135, 98),
    labelColor: const Color.fromARGB(255, 255, 135, 98),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: const Color.fromARGB(255, 255, 250, 241),
    contentPadding: EdgeInsets.all(16.0),
  )
);

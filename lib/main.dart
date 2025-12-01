import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fruit_app/features/home_page/home_page.dart';
import 'package:flutter_fruit_app/features/themes/themes.dart';

void main(){
  runApp(const FruitApp());
}

class FruitApp extends StatelessWidget {
  const FruitApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      home: HomePage(),
    );
  }
}


import 'package:flutter/material.dart';

class Recipes extends StatefulWidget{
  const Recipes({super.key});
  
  @override
  State<StatefulWidget> createState() => _RecipesState();
}

class _RecipesState extends State<StatefulWidget>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("recipes"),
    );
  }
}
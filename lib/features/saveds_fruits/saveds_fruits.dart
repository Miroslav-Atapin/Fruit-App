import 'package:flutter/material.dart';

class SavedsFruets extends StatefulWidget{
  const SavedsFruets({super.key});
  
  @override
  State<StatefulWidget> createState() => _SavedsFruetsState();
}

class _SavedsFruetsState extends State<StatefulWidget>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("saved fruets"),
    );
  }
}
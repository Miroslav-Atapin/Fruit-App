import 'package:flutter/material.dart';
import 'package:flutter_fruit_app/repositories/models/fruit.dart';

class FruitsInfo extends StatefulWidget {
  final Fruit selectedFruit;

  const FruitsInfo({super.key, required this.selectedFruit});

  @override
  State<StatefulWidget> createState() => _FruitsInfoState();
}

class _FruitsInfoState extends State<FruitsInfo> {

  @override
  Widget build(BuildContext context) {
    final selectedFruit = (context.widget as FruitsInfo).selectedFruit;
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedFruit.name),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
        ],
      ),
      body: Column(
        children: [
          Text(selectedFruit.name),
          Text(selectedFruit.family),
          Text("${selectedFruit.sugar}"),
          Text("${selectedFruit.calories}"),
        ],
      ),
    );
  }
}

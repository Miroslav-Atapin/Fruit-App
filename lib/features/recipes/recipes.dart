import 'package:flutter/material.dart';
import 'package:flutter_fruit_app/features/createNewRecipes/createNewRecipes.dart';

class Recipes extends StatefulWidget {
  const Recipes({super.key});

  @override
  State<StatefulWidget> createState() => _RecipesState();
}

class _RecipesState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("recipes"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => createNewRecipes()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

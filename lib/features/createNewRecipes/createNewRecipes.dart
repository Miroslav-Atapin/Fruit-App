import 'package:flutter/material.dart';

class createNewRecipes extends StatefulWidget {
  const createNewRecipes({super.key});

  @override
  State<StatefulWidget> createState() => _createNewRecipesState();
}

class _createNewRecipesState extends State<StatefulWidget> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Создание рецепта")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Название рецепта*',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Описание рецепта',
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}

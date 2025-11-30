import 'package:flutter/material.dart';
import 'package:flutter_fruit_app/repositories/models/fruit.dart';
import 'package:flutter_fruit_app/repositories/list_all_fruets/list_all_fruets_repositories.dart';
import 'package:flutter_fruit_app/repositories/models/fruits_storage.dart';
import 'package:flutter_fruit_app/repositories/models/recipes_storage.dart';

class CreateNewRecipe extends StatefulWidget {
  const CreateNewRecipe({super.key});

  @override
  State<CreateNewRecipe> createState() => _CreateNewRecipeState();
}

class _CreateNewRecipeState extends State<CreateNewRecipe> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<Fruit>? selectedFruits;
  List<Fruit>? allFruits;
  Set<int> selectedIndexes = {};

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<List<Fruit>> fetchAllFruits() async {
    return await ListAllFruitsRepositories().getFruits();
  }

  Future<List<Fruit>> fetchSelectedFruits() async {
    final favoriteFruitIds = await FruitsStorage.getFavoriteFruitIds();
    final fruits = await fetchAllFruits();
    return fruits
        .where((fruit) => favoriteFruitIds.contains(fruit.id))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    fetchSelectedFruits().then((fruits) {
      setState(() {
        this.selectedFruits = fruits;
      });
    });
    fetchAllFruits().then((fruits) {
      setState(() {
        this.allFruits = fruits;
      });
    });
  }

  // Сборка рецепта и сохранение
  Future<void> saveRecipe() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final chosenIngredients = selectedIndexes.map((i) => selectedFruits!.elementAt(i)).toList();

    if (title.isEmpty || chosenIngredients.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ошибка'),
          content: Text('Заполните название рецепта и выберите хотя бы один ингредиент.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('OK'))
          ],
        ),
      );
      return;
    }

    try {
      await RecipeStorage.addRecipe(title, description, chosenIngredients);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Готово'),
          content: Text('Ваш рецепт успешно сохранён!'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('ОК')),
          ],
        ),
      );
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ошибка'),
          content: Text('Что-то пошло не так при сохранении рецепта.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('OK')),
          ],
        ),
      );
    }
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
            Divider(height: 32),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  primary: false,
                  itemCount: selectedFruits?.length ?? 0,
                  itemBuilder: (context, index) {
                    final fruit = selectedFruits![index];
                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(fruit.name),
                      value: selectedIndexes.contains(index),
                      onChanged: (bool? checked) {
                        if (checked!) {
                          selectedIndexes.add(index);
                        } else {
                          selectedIndexes.remove(index);
                        }
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ),
            Spacer(),
            // Кнопка Сохранить
            Container(
              width: double.maxFinite,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                child: Text('Сохранить'),
                onPressed: () async {
                  await saveRecipe();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
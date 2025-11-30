import 'package:flutter/material.dart';
import 'package:flutter_fruit_app/features/createNewRecipes/create_new_recipes.dart';
import 'package:flutter_fruit_app/repositories/models/recipes_storage.dart';

class Recipes extends StatefulWidget {
  const Recipes({super.key});

  @override
  State<StatefulWidget> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  List<Map<String, dynamic>> recipes = [];

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    final loadedRecipes = await RecipeStorage.getRecipes();
    setState(() {
      recipes = loadedRecipes;
    });
  }

  // Отображаем список рецептов
  Widget buildRecipeList() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(thickness: 1),
      padding: EdgeInsets.all(16),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        final ingredients = recipe['ingredients'].cast<Map<String, dynamic>>();
        final totalNutrition = calculateTotalNutrition(ingredients);

        return Card(
          elevation: 2,
          color: Colors.white,
          child: Column(
            children: [
              Text(
                recipe['title'],
                style: Theme.of(context).textTheme.titleLarge,
              ),

              Text(recipe['description']),

              Text(
                'Состав: ${ingredients.map((fruit) => fruit['name']).join(', ')}',
              ),

              Text(
                'Калории: ${totalNutrition['calories']} ккал\nБелки: ${totalNutrition['proteins']} г\nЖиры: ${totalNutrition['fats']} г\nУглеводы: ${totalNutrition['carbohydrates']} г',
              ),
              Row(
                children: [
                  Spacer(),
                  TextButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text('Удалить'),
                    onPressed: () async {
                      await RecipeStorage.deleteRecipeByTitle(recipe['title']);
                      loadRecipes();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, num> calculateTotalNutrition(
    List<Map<String, dynamic>> ingredients,
  ) {
    var calories = 0.0;
    var proteins = 0.0;
    var fats = 0.0;
    var carbohydrates = 0.0;

    for (final ingredient in ingredients) {
      calories += ingredient['nutritions']['calories'] ?? 0.0;
      proteins += ingredient['nutritions']['proteins'] ?? 0.0;
      fats += ingredient['nutritions']['fats'] ?? 0.0;
      carbohydrates += ingredient['nutritions']['carbohydrates'] ?? 0.0;
    }

    return {
      'calories': calories.roundToDouble(),
      'proteins': proteins.roundToDouble(),
      'fats': fats.roundToDouble(),
      'carbohydrates': carbohydrates.roundToDouble(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: recipes.isNotEmpty
          ? buildRecipeList()
          : Center(child: Text('Нет рецептов')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => CreateNewRecipe()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

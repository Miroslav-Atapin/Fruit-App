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

  Future<void> _refreshRecipes() async {
    setState(() {
      loadRecipes();
    });
  }

  Map<String, double> calculateTotalNutrition(
    List<Map<String, dynamic>> ingredients,
  ) {
    double calories = 0.0;
    double proteins = 0.0;
    double fats = 0.0;
    double carbohydrates = 0.0;

    for (var ingredient in ingredients) {
      calories += ingredient['nutritions']['calories'] ?? 0.0;
      proteins += ingredient['nutritions']['proteins'] ?? 0.0;
      fats += ingredient['nutritions']['fats'] ?? 0.0;
      carbohydrates += ingredient['nutritions']['carbohydrates'] ?? 0.0;
    }

    return {
      'calories': calories,
      'proteins': proteins,
      'fats': fats,
      'carbohydrates': carbohydrates,
    };
  }

  double sumOfNutrients(Map<String, double> nutritionValues) {
    return nutritionValues.values.fold<double>(
      0.0,
      (prev, element) => prev + element,
    );
  }

  Widget buildRecipeCard(Map<String, dynamic> recipe) {
    final ingredients = recipe['ingredients'];
    final totalNutrition = calculateTotalNutrition(
      ingredients.cast<Map<String, dynamic>>(),
    );
    final totalSum = sumOfNutrients(totalNutrition);

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe['title'],
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                recipe['description'],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Полезные вещества:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Суммма полезных веществ ${totalSum.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Калорийность: ${totalNutrition['calories']?.toStringAsFixed(1)} ккал\n'
                'Белки: ${totalNutrition['proteins']?.toStringAsFixed(1)} г\n'
                'Жиры: ${totalNutrition['fats']?.toStringAsFixed(1)} г\n'
                'Углеводы: ${totalNutrition['carbohydrates']?.toStringAsFixed(1)} г',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: OutlinedButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Удалить'),
                onPressed: () async {
                  await RecipeStorage.deleteRecipeByTitle(recipe['title']);
                  loadRecipes();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRecipeList() {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: RefreshIndicator(
        onRefresh: _refreshRecipes,
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return buildRecipeCard(recipe);
          },
        ),
      ),
    );
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

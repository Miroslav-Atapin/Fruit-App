import 'dart:convert';

import 'package:flutter_fruit_app/repositories/models/fruit.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RecipeStorage {
  static const String _recipesKey = 'recipes_list';

  // Получение списка рецептов
  static Future<List<Map<String, dynamic>>> getRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final recipesJson = prefs.getStringList(_recipesKey) ?? [];
    return recipesJson.map((jsonStr) => jsonDecode(jsonStr) as Map<String, dynamic>).toList();
  }

  // Добавление нового рецепта
  static Future<void> addRecipe(String title, String description, List<Fruit> ingredients) async {
    final prefs = await SharedPreferences.getInstance();
    final newRecipe = {
      'title': title,
      'description': description,
      'ingredients': ingredients.map((fruit) => fruit.toJson()).toList(),
    };
    final currentRecipes = await getRecipes();
    currentRecipes.add(newRecipe);
    await prefs.setStringList(_recipesKey, currentRecipes.map(jsonEncode).toList());
  }

  // Удаление рецепта по названию
  static Future<void> deleteRecipeByTitle(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final currentRecipes = await getRecipes();
    currentRecipes.removeWhere((recipe) => recipe['title'] == title);
    await prefs.setStringList(_recipesKey, currentRecipes.map(jsonEncode).toList());
  }
}
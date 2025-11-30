import 'package:shared_preferences/shared_preferences.dart';

class SavedsFruitsHelper {
  static const String _favoriteFruitsKey = 'favorite_fruits';

  static Future<List<int>> getFavoriteFruitIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteFruitsKey)?.map(int.parse).toList() ?? [];
  }

  static Future<void> addFavoriteFruit(int fruitId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteFruitIds = await getFavoriteFruitIds();
    if (!favoriteFruitIds.contains(fruitId)) {
      favoriteFruitIds.add(fruitId);
      await prefs.setStringList(_favoriteFruitsKey, favoriteFruitIds.map((id) => id.toString()).toList());
    }
  }

  static Future<void> removeFavoriteFruit(int fruitId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteFruitIds = await getFavoriteFruitIds();
    favoriteFruitIds.remove(fruitId);
    await prefs.setStringList(_favoriteFruitsKey, favoriteFruitIds.map((id) => id.toString()).toList());
  }

  static Future<bool> isFavorite(int fruitId) async {
    final favoriteFruitIds = await getFavoriteFruitIds();
    return favoriteFruitIds.contains(fruitId);
  }
}
class Fruit {
  final int id;
  final String name;
  final String family;
  final double carbohydrates;
  final double protein;
  final double fat;
  final int calories;
  final double sugar;
  bool isFavorite; // Добавляем поле для отслеживания избранного состояния

  Fruit({
    required this.id,
    required this.name,
    required this.family,
    required this.carbohydrates,
    required this.protein,
    required this.fat,
    required this.calories,
    required this.sugar,
    this.isFavorite = false,
  });

  factory Fruit.fromJson(Map<String, dynamic> json) {
    return Fruit(
      id: json['id'],
      name: json['name'] ?? '',
      family: json['family'] ?? '',
      carbohydrates:
          json['nutritions']['carbohydrates']?.roundToDouble() ?? 0.0,
      protein: json['nutritions']['protein']?.roundToDouble() ?? 0.0,
      fat: json['nutritions']['fat']?.roundToDouble() ?? 0.0,
      calories: json['nutritions']['calories'] ?? 0,
      sugar: json['nutritions']['sugar']?.roundToDouble() ?? 0.0,
    );
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_fruit_app/repositories/models/fruit.dart';

class ListAllFruitsRepositories {
  Future<List<Fruit>> getFruits() async {
    try {
      final response = await Dio().get('https://www.fruityvice.com/api/fruit/all');
    
      if(response.statusCode != 200) throw Exception("Ошибка загрузки фруктов");

      final fruitsList = (response.data as List)
          .map((fruitData) => Fruit.fromJson(fruitData))
          .toList();
      return fruitsList;
    } catch(e) {
      print('Ошибка при загрузке фруктов: ${e.toString()}');
      rethrow;
    }
  }
}
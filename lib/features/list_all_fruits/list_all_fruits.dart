import 'package:flutter/material.dart';
import 'package:flutter_fruit_app/features/fruits_info/fruits_info.dart';
import 'package:flutter_fruit_app/repositories/list_all_fruets/list_all_fruets_repositories.dart';
import 'package:flutter_fruit_app/repositories/models/fruit.dart';
import 'package:flutter_fruit_app/repositories/models/saveds_fruits_helper.dart';

class ListAllFruits extends StatefulWidget {
  const ListAllFruits({super.key});

  @override
  State<StatefulWidget> createState() => _ListAllFruitsState();
}

class _ListAllFruitsState extends State<ListAllFruits> {
  late Future<List<Fruit>> futureFruits;

  @override
  void initState() {
    futureFruits = ListAllFruitsRepositories().getFruits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Fruit>>(
        future: futureFruits,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final fruits = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
              ),
              itemCount: fruits.length,
              itemBuilder: (context, index) {
                final fruit = fruits[index];
                return ListTile(
                  title: Text(fruit.name),
                  subtitle: Text(fruit.family),
                  trailing: FutureBuilder<bool>(
                    future: SavedsFruitsHelper.isFavorite(fruit.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final isFavorite = snapshot.data!;
                        return IconButton(
                          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                          onPressed: () async {
                            if (isFavorite) {
                              await SavedsFruitsHelper.removeFavoriteFruit(fruit.id);
                            } else {
                              await SavedsFruitsHelper.addFavoriteFruit(fruit.id);
                            }
                            setState(() {}); // Обновляем состояние
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FruitsInfo(selectedFruit: fruit),
                      ),
                    ).then((value) {
                      if (value != null && value is bool) {
                        setState(() {}); // Обновляем состояние при возвращении
                      }
                    });
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки фруктов'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            futureFruits = ListAllFruitsRepositories().getFruits();
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
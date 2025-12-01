import 'package:flutter/material.dart';
import 'package:flutter_fruit_app/features/fruits_info/fruits_info.dart';
import 'package:flutter_fruit_app/repositories/models/fruit.dart';
import 'package:flutter_fruit_app/repositories/list_all_fruets/list_all_fruets_repositories.dart';
import 'package:flutter_fruit_app/repositories/models/fruits_storage.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

class SavedFruits extends StatefulWidget {
  const SavedFruits({super.key});

  @override
  State<StatefulWidget> createState() => _SavedFruitsState();
}

class _SavedFruitsState extends State<SavedFruits> {
  late Future<List<Fruit>> futureFruits;

  @override
  void initState() {
    futureFruits = _getFavoriteFruits();
    super.initState();
  }

  Future<List<Fruit>> _getFavoriteFruits() async {
    final favoriteFruitIds = await FruitsStorage.getFavoriteFruitIds();
    final fruits = await ListAllFruitsRepositories().getFruits();
    return fruits
        .where((fruit) => favoriteFruitIds.contains(fruit.id))
        .toList();
  }

  Future<void> _refreshFruits() async {
    setState(() {
      futureFruits = _getFavoriteFruits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshFruits,
        child: FutureBuilder<List<Fruit>>(
          future: futureFruits,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final fruits = snapshot.data!;
              if (fruits.isEmpty) {
                return Center(
                  child: Text('Вы пока ничего не добавили в избранное'),
                );
              }
              return StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                itemCount: fruits.length,
                itemBuilder: (context, index) {
                  final fruit = fruits[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FruitsInfo(selectedFruit: fruit),
                        ),
                      );
                      setState(() {});
                    },
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
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fruit.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    Text(
                                      fruit.family,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              FutureBuilder<bool>(
                                future: FruitsStorage.isFavorite(fruit.id),
                                builder: (context, favoriteSnapshot) {
                                  if (favoriteSnapshot.hasData) {
                                    final isFavorite = favoriteSnapshot.data!;
                                    return IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                      ),
                                      onPressed: () async {
                                        if (isFavorite) {
                                          await FruitsStorage.removeFavoriteFruit(
                                            fruit.id,
                                          );
                                        } else {
                                          await FruitsStorage.addFavoriteFruit(
                                            fruit.id,
                                          );
                                        }
                                        setState(() {
                                          futureFruits = _getFavoriteFruits();
                                        });
                                      },
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Произошла ошибка'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          futureFruits = _getFavoriteFruits();
                        });
                      },
                      child: Text('Обновить страницу'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

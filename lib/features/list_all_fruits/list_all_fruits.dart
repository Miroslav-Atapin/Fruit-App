import 'package:flutter/material.dart';
import 'package:flutter_fruit_app/features/fruits_info/fruits_info.dart';
import 'package:flutter_fruit_app/repositories/list_all_fruets/list_all_fruets_repositories.dart';
import 'package:flutter_fruit_app/repositories/models/fruit.dart';
import 'package:flutter_fruit_app/repositories/models/fruits_storage.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

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

  Future<void> _refreshFruits() async {
    setState(() {
      futureFruits = ListAllFruitsRepositories().getFruits();
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Произошла ошибка'),
                    ElevatedButton(
                      child: Text('Повторить'),
                      onPressed: () {
                        setState(() {
                          futureFruits = ListAllFruitsRepositories().getFruits();
                        });
                      },
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final fruits = snapshot.data!;
              return StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                itemCount: fruits.length,
                itemBuilder: (context, index) {
                  final fruit = fruits[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FruitsInfo(selectedFruit: fruit),
                        ),
                      );
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
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    Text(
                                      fruit.family,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                      style: Theme.of(context).textTheme.labelSmall,
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
                                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                                      onPressed: () async {
                                        if (isFavorite) {
                                          await FruitsStorage.removeFavoriteFruit(fruit.id);
                                        } else {
                                          await FruitsStorage.addFavoriteFruit(fruit.id);
                                        }
                                        setState(() {});
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
            } else {
              // Всё остальное
              return const Center(child: Text('Нет данных'));
            }
          },
        ),
      ),
    );
  }
}
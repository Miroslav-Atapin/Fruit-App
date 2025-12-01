import 'package:flutter/material.dart';
import 'package:flutter_fruit_app/repositories/models/fruit.dart';
import 'package:flutter_fruit_app/repositories/models/fruits_storage.dart';

class FruitsInfo extends StatefulWidget {
  final Fruit selectedFruit;

  const FruitsInfo({super.key, required this.selectedFruit});

  @override
  State<StatefulWidget> createState() => _FruitsInfoState();
}

class _FruitsInfoState extends State<FruitsInfo> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await FruitsStorage.isFavorite(widget.selectedFruit.id);
    setState(() {
      this.isFavorite = isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedFruit.name),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop(isFavorite);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () async {
              if (isFavorite) {
                await FruitsStorage.removeFavoriteFruit(
                  widget.selectedFruit.id,
                );
              } else {
                await FruitsStorage.addFavoriteFruit(widget.selectedFruit.id);
              }
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
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
                    Text(
                      widget.selectedFruit.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Divider(height: 16),
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(), // Гибкая первая колонка
                        1: FixedColumnWidth(
                          120,
                        ), // Фиксированная вторая колонка
                      },
                      children: [
                        TableRow(
                          children: [
                            Text(
                              'Семейство',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              widget.selectedFruit.family,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Порядок',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              widget.selectedFruit.order,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Род',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              widget.selectedFruit.genus,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Калории',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${widget.selectedFruit.calories}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Жир',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${widget.selectedFruit.fat}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Сахар',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${widget.selectedFruit.sugar}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Углеводы',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${widget.selectedFruit.carbohydrates}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              'Белки',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${widget.selectedFruit.protein}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_fruit_app/repositories/models/fruit.dart';
import 'package:flutter_fruit_app/repositories/models/saveds_fruits_helper.dart';

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
    final isFavorite = await SavedsFruitsHelper.isFavorite(
      widget.selectedFruit.id,
    );
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
                await SavedsFruitsHelper.removeFavoriteFruit(
                  widget.selectedFruit.id,
                );
              } else {
                await SavedsFruitsHelper.addFavoriteFruit(
                  widget.selectedFruit.id,
                );
              }
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Text(widget.selectedFruit.name),
          Text(widget.selectedFruit.family),
          Text(widget.selectedFruit.order),
          Text(widget.selectedFruit.genus),
          Text('${widget.selectedFruit.calories}'),
          Text('${widget.selectedFruit.fat}'),
          Text('${widget.selectedFruit.sugar}'),
          Text('${widget.selectedFruit.carbohydrates}'),
          Text('${widget.selectedFruit.protein}'),
        ],
      ),
    );
  }
}

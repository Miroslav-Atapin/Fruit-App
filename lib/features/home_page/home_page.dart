import 'package:flutter/material.dart';
import 'package:flutter_fruit_app/features/list_all_fruits/list_all_fruits.dart';
import 'package:flutter_fruit_app/features/recipes/recipes.dart';
import 'package:flutter_fruit_app/features/saveds_fruits/saveds_fruits.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<StatefulWidget>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  String currentTitle = "";

  void updateTitle(int index) {
    switch (index) {
      case 0:
        setState(() => currentTitle = "Фрукты");
        break;
      case 1:
        setState(() => currentTitle = "Избранное");
        break;
      case 2:
        setState(() => currentTitle = "Рецепты");
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        updateTitle(tabController.index);
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: Text(currentTitle),
            bottom: TabBar(
              controller: tabController,
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.favorite)),
                Tab(icon: Icon(Icons.list)),
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [ListAllFruits(), SavedsFruets(), Recipes()],
          ),
        ),
      ),
    );
  }
}

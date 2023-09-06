import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inhameal_flutter_project/Model/DayMeal.dart';
import 'package:inhameal_flutter_project/View/SettingPage.dart';

class MealPage extends StatelessWidget {
  Cafeteria cafe;

  MealPage({Key? key, required this.cafe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cafe.name ?? ""),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text('08월 27일'),
            ),
            for (Meal meal in cafe.meals ?? []) RoundRectangleWidget(meal: meal)
          ],
        ),
      ),
    );
  }
}

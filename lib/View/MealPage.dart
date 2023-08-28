import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inhameal_flutter_project/Model/DayMeal.dart';

class MealPage extends StatelessWidget {
  Cafeteria cafe;

  MealPage({Key? key, required this.cafe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cafe.name ?? ""),
        centerTitle: true,
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

class RoundRectangleWidget extends StatelessWidget {
  Meal meal;

  RoundRectangleWidget({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey,
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(meal.name ?? "", style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Text(meal.openTime ?? "")
                ],
              ),
              for (String menu in meal.menus ?? [])
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(menu),
                ),
            ],
          ),
        ),
      ),
    );
  }

}

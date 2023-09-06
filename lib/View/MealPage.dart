import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inhameal_flutter_project/Model/DayMeal.dart';
import 'package:inhameal_flutter_project/View/SettingPage.dart';
import 'package:inhameal_flutter_project/View/component/MenuBoardView.dart';

class MealPage extends StatelessWidget {
  Cafeteria cafe;

  Map<String, List<Meal>> category = {
    'brunch': [],
    'lunch': [],
    'dinner': [],
  };

  MealPage({Key? key, required this.cafe}) : super(key: key) {
    cafe.meals?.forEach((meal) {
      category[meal.category]!.add(meal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowIndicator();
        return true;
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            for (var item in category.entries)
                MenuBoardView(name: item.key, meals: item.value),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

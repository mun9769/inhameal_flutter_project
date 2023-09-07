import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inhameal_flutter_project/Model/DayMeal.dart';
import 'package:inhameal_flutter_project/View/SettingPage.dart';
import 'package:inhameal_flutter_project/View/component/MenuBoardView.dart';

class MealPage extends StatefulWidget {
  Cafeteria cafe;

  Map<String, List<Meal>> category = {
    'brunch': [],
    'lunch': [],
    'dinner': [],
    'category': [],
    'self_ramen': [],
  };

  MealPage({Key? key, required this.cafe}) : super(key: key) {
    cafe.meals?.forEach((meal) {
      category[meal.category]!.add(meal);
    });
  }

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowIndicator();
        return true;
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            for (var item in widget.category.entries) ...[
              if(item.value.isNotEmpty) ...[
                MenuBoardView(name: item.key, meals: item.value),
              ]
              else if(item.key =='brunch' || item.key == 'lunch' || item.key == 'dinner') ...[
                MenuBoardView(name: item.key, meals: item.value),
              ]
            ],
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

}

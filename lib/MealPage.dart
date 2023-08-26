import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inhameal_flutter_project/Model/DayMeal.dart';

class MealPage extends StatelessWidget {
  DayMeal? _dayMeal;

  MealPage({Key? key}) : super(key: key) {
    Map<String, dynamic> json = {
      "id": "dummyId",
      "brunch": ["아침", "된장찌개", "김치찌개", "피자"],
      "lunch": ["점심", "된장찌개", "김치찌개", "피자"],
      "dinner": ["저녁", "된장찌개", "김치찌개", "피자"]
    };
    _dayMeal = DayMeal.fromJson(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SingleChildScrollView'),
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
            RoundRectangleWidget(meal: _dayMeal!.brunch),
            RoundRectangleWidget(meal: _dayMeal!.lunch),
            RoundRectangleWidget(meal: _dayMeal!.dinner),
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
        child: Column(
          children: [
            for (String meal in meals)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(meal),
              ),
          ],
        ),
      ),
    );
  }
}

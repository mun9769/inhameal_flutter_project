import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MealPage extends StatelessWidget {
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
            RoundRectangleWidget(),
            RoundRectangleWidget(),
            RoundRectangleWidget(),
            RoundRectangleWidget(),
            RoundRectangleWidget(),
            RoundRectangleWidget(),
            RoundRectangleWidget(),
            RoundRectangleWidget(),
          ],
        ),
      ),
    );
  }
}

class RoundRectangleWidget extends StatelessWidget {
  RoundRectangleWidget({Key? key}) : super(key: key);

  List<String> meals = ["된장찌개", "김치찌개", "피자"];

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

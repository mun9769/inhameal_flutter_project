import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inhameal_flutter_project/Model/day_meal.dart';
import 'package:inhameal_flutter_project/View/component/menu_board_view.dart';

class MealPage extends StatefulWidget { // TODO 꼭 stateful해야하나?
  final Cafeteria cafe;


  MealPage({Key? key, required this.cafe}) : super(key: key);

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
            MenuBoardView(category: 'brunch', meals: widget.cafe.brunch),
            MenuBoardView(category: 'lunch', meals: widget.cafe.lunch),
            MenuBoardView(category: 'dinner', meals: widget.cafe.dinner),
            if(widget.cafe.other != null)
              MenuBoardView(category: 'other', meals: widget.cafe.other!),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

}

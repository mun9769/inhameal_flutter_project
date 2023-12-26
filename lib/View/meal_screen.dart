import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/Model/day_meal.dart';
import 'package:inhameal_flutter_project/View/component/menu_board_view.dart';

class MealPage extends StatelessWidget {
  final Cafeteria cafe;
  final Function() onRefresh;


  MealPage({Key? key, required this.cafe, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowIndicator();
        return true;
      },
      child:
        RefreshIndicator(
          onRefresh: _refresh,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  MenuBoardView(category: 'brunch', meals: cafe.brunch),
                  MenuBoardView(category: 'lunch', meals: cafe.lunch),
                  MenuBoardView(category: 'dinner', meals: cafe.dinner),
                  if(cafe.other != null)
                    MenuBoardView(category: 'other', meals: cafe.other!),
                  SizedBox(height: 40),

                  if(cafe.skipReason != null)
                    Text(cafe.skipReason!)
                ],
              ),
          ),
        )
    );
  }

  Future<void> _refresh() async {
    await onRefresh();
  }
}

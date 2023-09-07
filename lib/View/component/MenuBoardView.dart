import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Model/DayMeal.dart';

class MenuBoardView extends StatelessWidget {
  String name;
  List<Meal> meals;

  MenuBoardView({super.key, required this.name, required this.meals}) {}

  Map<String, String> translateName = {
    'brunch': '아침',
    'lunch': '점심',
    'dinner': '저녁',
    'self_ramen': '셀프라면',
    'snack' : '스낵(조식/석식)'
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 20),
      // margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 7),
            )
          ],
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(translateName[name] ?? "식사",
                      style: TextStyle(fontSize: 24)),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: meals.isNotEmpty
                          ? Text(meals[0].openTime ?? "",
                              style: TextStyle(fontSize: 16))
                          : Text("")),
                ],
              ),
              ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: meals.length,
                itemBuilder: (_, index) {
                  return LayoutBuilder(
                    builder: (_, size) {
                      return makeMenus(meals[index], size.maxWidth / 2);
                    },
                  );
                },
                separatorBuilder: (_, __) {
                  return Divider(thickness: 1);
                },
              ),
              if (meals.length == 0) Text("미운영")
            ],
          ),
        ),
      ),
    );
  }

  Widget makeMenus(Meal meal, double maxWidth) {
    int idx = 0;
    List<String>? menus = meal.menus?.cast<String>();

    if(menus == null) {
      return SizedBox(height: 20);
    }

    List<Row> rows = [];
    while (idx < menus.length) {
      Row row;
      List<String> s = [];

      if (idx + 1 < menus.length &&
          !hasTextOverflow(menus[idx], TextStyle(), maxWidth) &&
          !hasTextOverflow(menus[idx + 1], TextStyle(), maxWidth)) {
        s.add(menus[idx++]);
        s.add(menus[idx++]);
      } else {
        s.add(menus[idx++]);
      }

      row = Row(children: [
        for (String menu in s) Expanded(flex: 1, child: Text(menu))
      ]);

      rows.add(row);
    }
    rows.add(Row(children: [Spacer(), Text(meal.price ?? "")]));
    Column ret = Column(
      children: [
        for (Row row in rows) row,
      ],
    );
    return ret;
  }

  bool hasTextOverflow(String text, TextStyle style, double maxWidth,
      {double minWidth = 0, int maxLines = 1}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(minWidth: minWidth, maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }
}

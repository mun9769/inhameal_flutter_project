import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Model/day_meal.dart';
import '../../constants/colors.dart';

class MenuBoardView extends StatelessWidget {
  final String name;
  final List<Meal> meals;

  MenuBoardView({super.key, required this.name, required this.meals});

  final Map<String, String> categoryKorean = {
    'brunch': '아침',
    'lunch': '점심',
    'dinner': '저녁',
    'self_ramen': '셀프라면',
    'snack': '스낵(조식/석식)'
  };

  final Map<String, Icon> categoryIcon = {
    'brunch': Icon(
      CupertinoIcons.sun_dust,
      size: 18,
    ),
    'lunch': Icon(
      CupertinoIcons.sun_max,
      size: 18,
    ),
    'dinner': Icon(
      CupertinoIcons.moon,
      size: 18,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
      // margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 2),
            )
          ],
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
          child: Column(
            children: [
              Row(
                children: [
                  categoryIcon[name] ?? SizedBox.shrink(),
                  if(categoryIcon[name] != null) SizedBox(width: 5),
                  Text(
                    categoryKorean[name] ?? "식사",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.0),
                      color: AppColors.lightGray,
                    ),
                    child: Text(
                      meals[0].openTime ?? "",
                      style: TextStyle(
                        color: AppColors.deepGray,
                        fontSize: 12.0,
                      ),
                    ),
                  )
                ],
              ),
              ListView.separated(
                padding: meals.isEmpty
                    ? EdgeInsets.zero
                    : EdgeInsets.symmetric(vertical: 16.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: meals.length,
                itemBuilder: (_, index) {
                  return LayoutBuilder(
                    builder: (_, size) {
                      return makeMenus(meals[index], size.maxWidth / 2 - 32);
                    },
                  );
                },
                separatorBuilder: (_, __) {
                  return Divider(thickness: 1);
                },
              ),
              if (meals.isEmpty)
                Column(
                  children: const [
                    Text("미운영"),
                    SizedBox(height: 20),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeMenus(Meal meal, double maxWidth) {
    int idx = 0;
    List<String>? menus = meal.menus?.cast<String>();

    if (menus == null) {
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

      row = Row(
        children: [
          for (String menu in s)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  menu,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
        ],
      );

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

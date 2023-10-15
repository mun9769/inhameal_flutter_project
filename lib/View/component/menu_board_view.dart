import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Model/day_meal.dart';
import '../../constants/colors.dart';

class MenuBoardView extends StatelessWidget {
  final String category;
  final List<Meal> meals;

  MenuBoardView({super.key, required this.category, required this.meals});

  final Map<String, String> categoryKorean = {
    'brunch': '아침',
    'lunch': '점심',
    'dinner': '저녁',
    'self_ramen': '셀프라면',
    'snack': '스낵(조식/석식)',
    'other': '스낵'
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 30),
          child: Column(
            children: [
              Row(
                children: [
                  categoryIcon[category] ?? SizedBox.shrink(),
                  if (categoryIcon[category] != null) SizedBox(width: 5),
                  Text(
                    categoryKorean[category] ?? "식사",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepGray,
                    ),
                  ),
                  SizedBox(width: 5),
                  if (meals.isEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.0),
                        color: AppColors.lightGray,
                      ),
                      child: Text(
                        "미운영",
                        style: TextStyle(
                          color: AppColors.deepGray,
                          fontSize: 12.0,
                        ),
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
                      meals.isNotEmpty ? meals[0].openTime ?? "" : "",
                      style: TextStyle(
                        color: AppColors.deepGray,
                        fontSize: 12.0,
                      ),
                    ),
                  )
                ],
              ),
              meals.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("미운영"),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: meals.isEmpty
                          ? EdgeInsets.zero
                          : EdgeInsets.symmetric(vertical: 16.0),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: meals.length,
                      itemBuilder: (_, index) {
                        return LayoutBuilder(
                          builder: (_, size) {
                            return makeMenus(
                                meals[index], size.maxWidth / 2 - 32);
                          },
                        );
                      },
                      separatorBuilder: (_, __) {
                        return Divider(thickness: 1);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeMenus(Meal meal, double maxWidth) {
    int idx = 0;
    List<String> menus = meal.menus.cast<String>();

    if (menus.isEmpty) {
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

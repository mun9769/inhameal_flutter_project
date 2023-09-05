import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Model/DayMeal.dart';

class MenuBoardView extends StatelessWidget {
  late List<List<String>> lunch;
  List<String> menus = [
    "피자토핑치즈오븐토마토스파게티",
    "얼갈이된장국",
    "고추장오리불고기",
    "어묵계란전",
    "숙주나물",
    "깍두기",
    "아이스홍시"
  ];

  MenuBoardView({super.key}) {
    lunch = [menus, menus, menus];
  }

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
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text("중식", style: TextStyle(fontSize: 24)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                        Text("11:00 ~ 13:30", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lunch.length,
                itemBuilder: (_, index) {
                  return LayoutBuilder(
                    builder: (_, size) {
                      return makeMenus(size.maxWidth / 2);
                    },
                  );
                },
                separatorBuilder: (_, __) {
                  return Divider(thickness: 1);
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeMenus(double maxWidth) {
    int idx = 0;

    List<Row> rows = [];
    while (idx < menus.length) {
      Row row;
      List<String> s = [menus[idx++]];

      if (idx < menus.length &&
          !hasTextOverflow(menus[idx], TextStyle(), maxWidth)) {
        s.add(menus[idx++]);
      }

      row = Row (
        children: [
          for(String menu in s)
            Expanded(
              flex: 1,
              child: Text(menu)
            )
        ]
      );

////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if (idx == menus.length - 1) {
        row = Row(children: [Text(menus[idx++])]);
      } else if (!hasTextOverflow(menus[idx], TextStyle(), maxWidth) &&
          !hasTextOverflow(menus[idx + 1], TextStyle(), maxWidth)) {
        row = Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(menus[idx++]),
            ),
            Expanded(
              flex: 1,
              child: Text(menus[idx++]),
            ),
          ],
        );
      } else {
        row = Row(
          children: [Text(menus[idx++])],
        );
      }
      //////////////////////////////////////////////////////////////////////////////////////////
      rows.add(row);
    }
    rows.add(Row(children: [Spacer(), Text("7000원")]));
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


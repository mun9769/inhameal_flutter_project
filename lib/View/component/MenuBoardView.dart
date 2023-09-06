import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Model/DayMeal.dart';

class MenuBoardView extends StatelessWidget {


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
                padding: EdgeInsets.symmetric(vertical: 16.0),
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

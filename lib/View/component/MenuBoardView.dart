import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Model/DayMeal.dart';

class MenuBoardView extends StatelessWidget{

  List<String> menus = ["순살치킨카츠&어니언크리미소스순살치킨카츠&어니언크리미소스순살치킨카츠&어니언크리미소스순살치킨카츠&어니언크리미소스","얼갈이된장국", "고추장오리불고기", "어묵계란전", "숙주나물", "깍두기", "아이스홍시"];

  MenuBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey,
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text("중식"),//,style: TextStyle(backgroundColor: Colors.blue)),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("11:00 ~ 13:30"),
                  ),  //,style: TextStyle(backgroundColor: Colors.red)),

                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for(String menu in menus)
                    LayoutBuilder(builder: (context, size) {
                      if (hasTextOverflow(menu, TextStyle(fontSize: 36), size.maxWidth) == false)
                        return Text(menu);
                      else
                        return Text("haiwng");
                    }
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool hasTextOverflow(
      String text,
      TextStyle style,
      double maxWidth,
      {double minWidth = 0,
        int maxLines = 1
      }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(minWidth: minWidth, maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(meal.name ?? "", style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Text(meal.openTime ?? "")
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [Spacer(), Text(meal.price ?? "")],
              ),
              if (meal.menus != null) ...[
                for (String menu in meal.menus ?? [])
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Text(menu),
                      ],
                    ),
                  ),
              ] else
                const Text("학식이 없습니다")
            ],
          ),
        ),
      ),
    );
  }
}

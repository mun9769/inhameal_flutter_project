import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/View/component/MenuBoardView.dart';

class SliderPage extends StatefulWidget {
  @override
  State<SliderPage> createState() => _SliderpageState();
}

class _SliderpageState extends State<SliderPage> {
  List itemColors = [Colors.green, Colors.purple, Colors.blue];
  int currentIndex = 0;

  List<String> cafes = ['기숙사식당', '학생식당', '교직원식당'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < itemColors.length; i++)
                  Text(cafes[i],
                    style: TextStyle(
                        background: Paint()
                          ..strokeWidth = 30.0
                          ..color = currentIndex == i ? Colors.blue : Colors.grey
                          ..style = PaintingStyle.stroke
                          ..strokeJoin = StrokeJoin.round),
                  )
              ],
            ),
            CarouselSlider(
              items: [
                for (int i = 0; i < itemColors.length; i++)
                  my_meal_page(),
              ],
              options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      // print(reason.toString());
                      currentIndex = index;
                    });
                  },
                  autoPlay: false),
            ),
          ],
        ),
      ),
    ));
  }
}

class my_meal_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowIndicator();
        return true;
      },
      child: SingleChildScrollView(
          child: Column(
              children: [
                MenuBoardView(),
                MenuBoardView(),
                MenuBoardView(),
                MenuBoardView(),
              ]
          ),
      ),
    );
  }

}

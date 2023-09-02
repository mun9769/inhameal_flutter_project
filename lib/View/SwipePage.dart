import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../Controller/DataController.dart';
import '../Model/DayMeal.dart';
import 'MealPage.dart';

class SwipePage extends StatefulWidget {
  final DayMeal dayMeal;

  SwipePage({Key? key, required this.dayMeal}) : super(key: key);

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  final PageController _pageController = PageController(initialPage: 0);
  final DataController _dataController = DataController();

  late int selectedPage = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    initPages();
  }


  void initPages(){
    final Map<String, Widget> cafepages = {
      "dorm": MealPage(cafe: widget.dayMeal.dormCafe),
      "student": MealPage(cafe: widget.dayMeal.studentCafe),
      "staff": MealPage(cafe: widget.dayMeal.staffCafe),
    };

    List<Widget> tmp = [];
    _dataController.cafeList.forEach((name) {
      tmp.add(cafepages[name]!); // !를 빼는 방법이 없을까?
    });
    _pages = tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  selectedPage = page;
                });
              },
              children: List.generate(_pages.length, (index) {
                return _pages[index];
              }),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PageViewDotIndicator(
                currentItem: selectedPage,
                count: _pages.length,
                unselectedColor: Colors.black26,
                selectedColor: Colors.blue,
                duration: const Duration(milliseconds: 200),
                boxShape: BoxShape.rectangle,
              )),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}


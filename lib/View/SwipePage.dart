import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../Model/DayMeal.dart';
import 'MealPage.dart';


class SwipePage extends StatefulWidget {
  SwipePage({Key? key}) : super(key: key);

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  final PageController _pageController = PageController(initialPage: 0);

  late int selectedPage;
  late final DayMeal dayMeal;

  final List<Widget> _pages = [
    MealPage(
        cafe: Cafeteria(name: "기숙사식당1", meals: [
          Meal(name: "아침", menus: ["아"], openTime: 'test')
        ])),
    MealPage(
        cafe: Cafeteria(name: "기숙사식당2", meals: [
          Meal(name: "아침", menus: ["아"], openTime: 'test')
        ])),
    MealPage(
        cafe: Cafeteria(name: "학생식당   ", meals: [
          Meal(name: "아침", menus: ["아"], openTime: 'test')
        ])),
    MealPage(
        cafe: Cafeteria(name: "교직원식당", meals: [
          Meal(name: "아침", menus: ["아"], openTime: 'test')
        ])),
  ];

  @override
  void initState() {
    selectedPage = 0;
    super.initState();
    dayMeal = DayMeal.fromJson(myjson);
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
              children: List.generate(4, (index) {
                return _pages[index];
              }),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PageViewDotIndicator(
                currentItem: selectedPage,
                count: 4,
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

Map<String, dynamic> myjson = {
  "id": "20230123",
  "dorm_1Cafe": {
    "name": "1기숙사식당",
    "meals": [
      {
        "name": "조식",
        "menus": ["아침", "된장찌개"]
      },
      {
        "name": "점심",
        "menus": ["점심", "된장찌개"]
      },
      {
        "name": "저녁",
        "menus": ["저녁", "된장찌개"]
      },
    ],
  },
  "dorm_2Cafe": {
    "name": "2기숙사식당",
    "meals": [
      {
        "name": "조식",
        "menus": ["아침", "된장찌개"]
      },
      {
        "name": "점심",
        "menus": ["점심", "된장찌개"]
      },
      {
        "name": "저녁",
        "menus": ["저녁", "된장찌개"]
      },
    ],
  },
  "studentCafe": {
    "name": "학생식당",
    "meals": [
      {
        "name": "조식",
        "menus": ["아침", "된장찌개"]
      },
      {
        "name": "점심",
        "menus": ["점심", "된장찌개"]
      },
      {
        "name": "저녁",
        "menus": ["저녁", "된장찌개"]
      },
    ],
  },
  "staffCafe": {
    "name": "교직원식당",
    "meals": [
      {
        "name": "조식",
        "menus": ["아침", "된장찌개"]
      },
      {
        "name": "점심",
        "menus": ["점심", "된장찌개"]
      },
      {
        "name": "저녁",
        "menus": ["저녁", "된장찌개"]
      },
    ],
  },
};

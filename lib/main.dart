import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/MealPage.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import 'Model/DayMeal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SingleChildScrollView',
      home: PageViewExample(),
    );
  }
}

class PageViewExample extends StatefulWidget {
  PageViewExample({Key? key}) : super(key: key);

  @override
  State<PageViewExample> createState() => _PageViewExampleState();
}

class _PageViewExampleState extends State<PageViewExample> {
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
    ));
  }
}


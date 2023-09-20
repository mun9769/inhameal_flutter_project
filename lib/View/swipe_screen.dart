import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/View/setting_screen.dart';
import 'package:inhameal_flutter_project/constants/colors.dart';
import 'package:intl/intl.dart';
import '../Controller/data_controller.dart';
import '../Model/day_meal.dart';
import '../constants/static_variable.dart';
import 'meal_screen.dart';

class SwipePage extends StatefulWidget {
  final DayMeal dayMeal;

  SwipePage({Key? key, required this.dayMeal}) : super(key: key);

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  final PageController _pageController = PageController(initialPage: 0, viewportFraction: 0.9);
  final DataController _dataController = DataController();
  late int selectedPage = 0;

  late List<Widget> _pages;
  late List<String> cafeList;

  @override
  void initState() {
    super.initState();
    initPages();
  }

  void initPages() {
    cafeList = _dataController.cafeList;

    final Map<String, Widget> cafepages = {
      "dorm": MealPage(cafe: widget.dayMeal.dormCafe),
      "student": MealPage(cafe: widget.dayMeal.studentCafe),
      "staff": MealPage(cafe: widget.dayMeal.staffCafe),
    };

    List<Widget> tmp = [];
    for (var name in cafeList) {
      tmp.add(cafepages[name]!);
    }
    _pages = tmp;
  }

  void screenSetState() {
    final Map<String, Widget> cafepages = {
      "dorm": MealPage(cafe: widget.dayMeal.dormCafe),
      "student": MealPage(cafe: widget.dayMeal.studentCafe),
      "staff": MealPage(cafe: widget.dayMeal.staffCafe),
    };

    setState(() {
      cafeList = _dataController.cafeList;
      List<Widget> tmp = [];
      for (var name in cafeList) {
        tmp.add(cafepages[name]!);
      }
      _pages = tmp;
    });
  }

  String getToday() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM월 dd일 ').format(now);
    String? day = DateFormat('E').format(now);
    day = AppVar.weeks[day];
    return formattedDate + (day ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getToday()),
        backgroundColor: AppColors.orange[300],
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage(parentSetState: screenSetState,)));
            },
          )
        ],
      ),
      body: Container(
        color: AppColors.lightGray,
        child: Column(
          children: [
            Container(
              // color: Colors.lightBlue[100],
              color: AppColors.orange[100],
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < _pages.length; i++)
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: selectedPage == i ? AppColors.orange[700] : Colors.white,
                      ),
                      child: Text(
                        AppVar.cafeKorean[cafeList[i]] ?? "식당",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                ],
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}


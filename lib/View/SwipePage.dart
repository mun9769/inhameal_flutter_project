import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/View/SettingPage.dart';
import 'package:inhameal_flutter_project/constants/colors.dart';
import 'package:intl/intl.dart';
import '../Controller/DataController.dart';
import '../Model/DayMeal.dart';
import '../constants/static_variable.dart';
import 'MealPage.dart';

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


  void initPages(){
    cafeList = _dataController.cafeList;

    final Map<String, Widget> cafepages = {
      "dorm": MealPage(cafe: widget.dayMeal.dormCafe),
      "student": MealPage(cafe: widget.dayMeal.studentCafe),
      "staff": MealPage(cafe: widget.dayMeal.staffCafe),
    };

    List<Widget> tmp = [];
    cafeList.forEach((name) {
      tmp.add(cafepages[name]!);
    });
    _pages = tmp;
  }
  void my_setState() {
    final Map<String, Widget> cafepages = {
      "dorm": MealPage(cafe: widget.dayMeal.dormCafe),
      "student": MealPage(cafe: widget.dayMeal.studentCafe),
      "staff": MealPage(cafe: widget.dayMeal.staffCafe),
    };

    setState(() {
      cafeList = _dataController.cafeList;
      List<Widget> tmp = [];
      cafeList.forEach((name) {
        tmp.add(cafepages[name]!);
      });
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
                  MaterialPageRoute(builder: (context) => SettingPage(parentSetState: my_setState,)));
            },
          )
        ],
      ),
      body: Container(
        color: AppColors.orange[50],
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
                        AppVar.translateName[cafeList[i]] ?? "식당",
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


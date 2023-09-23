import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/View/setting_screen.dart';
import 'package:inhameal_flutter_project/constants/colors.dart';
import 'package:intl/intl.dart';
import '../Controller/data_controller.dart';
import '../Model/day_meal.dart';
import '../constants/static_variable.dart';
import 'meal_screen.dart';

class SwipePage extends StatefulWidget {
  DayMeal dayMeal;

  SwipePage({Key? key, required this.dayMeal}) : super(key: key);

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.9);
  final DataController _dataController = DataController();
  late int selectedPage = 0;

  late List<Widget> _pages;
  late List<String> cafeList;

  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    initPages();
    currentDate = DateTime.parse(widget.dayMeal.id);
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

  String getDate() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    String? day = DateFormat('E').format(currentDate);
    day = AppVar.weeks[day];
    if (day == null) return formattedDate;
    day = "($day)";
    return formattedDate + day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/calendar.png', height: 21, width: 20),
            SizedBox(width: 6),
            Text(
              getDate(),
              style: TextStyle(
                  color: AppColors.skyBlue, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: widget.dayMeal.prev
              ? AppColors.skyBlue
              : AppColors.littleDeepGray,
          onPressed: widget.dayMeal.prev
              ? () async {
                  DateTime yesterday = currentDate.add(Duration(days: -1));
                  String formattedDate =
                      DateFormat('yyyyMMdd').format(yesterday);

                  widget.dayMeal =
                      await _dataController.loadData(formattedDate);

                  setState(() {
                    initPages();
                    currentDate = yesterday;
                  });
                }
              : null,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download_outlined),
            color: AppColors.skyBlue,
            onPressed: () async {
              String formattedDate = DateFormat('yyyyMMdd').format(currentDate);
              widget.dayMeal = await _dataController.reloadData(formattedDate);

              setState(() {
                initPages();
              });
            }
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            color: widget.dayMeal.next
                ? AppColors.skyBlue
                : AppColors.littleDeepGray,
            onPressed: widget.dayMeal.next
                ? () async {
                    DateTime tomorrow = currentDate.add(Duration(days: 1));
                    String formattedDate =
                        DateFormat('yyyyMMdd').format(tomorrow);

                    widget.dayMeal =
                        await _dataController.loadData(formattedDate);

                    setState(() {
                      initPages();
                      currentDate = tomorrow;
                    });
                  }
                : null,
          )
        ],
      ),
      body: Container(
        color: AppColors.lightGray,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 19, bottom: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < _pages.length; i++)
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(i, duration: Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 26, right: 26, top: 11, bottom: 11),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.0),
                          color: selectedPage == i
                              ? AppColors.deepBlue
                              : AppColors.gray,
                        ),
                        child: Text(
                          AppVar.cafeKorean[cafeList[i]] ?? "식당",
                          style: TextStyle(
                            color: selectedPage == i
                                ? AppColors.textWhite
                                : AppColors.deepGray,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
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

import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/constants/colors.dart';
import 'package:intl/intl.dart';
import '../Controller/data_controller.dart';
import '../Model/day_meal.dart';
import '../constants/static_variable.dart';
import 'component/menu_board_view.dart';
import 'meal_screen.dart';

//ignore: must_be_immutable
class SwipePage extends StatefulWidget {
  DayMeal dayMeal;

  SwipePage({Key? key, required this.dayMeal}) : super(key: key);

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 1);
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
    _dataController.updateCafePriority(["dorm","student","staff"]);
    cafeList = _dataController.cafeList;

    final Map<String, Widget> cafepages = {
      "dorm": MealPage(cafe: widget.dayMeal.dormCafe, onRefresh: refreshData),
      "student": MealPage(cafe: widget.dayMeal.studentCafe, onRefresh: refreshData),
      "staff": MealPage(cafe: widget.dayMeal.staffCafe, onRefresh: refreshData),
    };

    List<Widget> tmp = [];
    for (var name in cafeList) {
      tmp.add(cafepages[name]!);
    }
    _pages = tmp;
  }

  void refreshData() async {
    String formattedDate = DateFormat('yyyyMMdd').format(currentDate);
    widget.dayMeal = await _dataController.reloadData(formattedDate);
  }

  String _appBarTitle() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    String? day = DateFormat('E').format(currentDate);
    day = AppVar.weeks[day];
    if (day == null) return formattedDate;
    day = "($day)";
    return formattedDate + day;
  }

  void getDayMeal(int days) async {
    DateTime nxt = currentDate.add(Duration(days: days));
    String formattedDate = DateFormat('yyyyMMdd').format(nxt);

    try {
      widget.dayMeal = await _dataController.fetchWeeklyData(formattedDate);
      currentDate = nxt;
    } catch(e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("아직 업데이트되지 않았어요\n매주 주말에 업로드됩니다"),
            actions: <Widget>[
              TextButton(
                onPressed: () { Navigator.of(context).pop(); },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      initPages();
    });
  }

  bool _isToday() {
    final DateFormat formatter = DateFormat('yyyyMMdd');
    final String formattedCurrenntDate = formatter.format(currentDate);
    final String today = formatter.format(DateTime.now());

    return formattedCurrenntDate == today;
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
              _appBarTitle(),
              style: TextStyle(
                  color: AppColors.skyBlue, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: _isToday() ? AppColors.deepGray : AppColors.skyBlue,
          onPressed: _isToday() ? null : () => getDayMeal(-1),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            color: AppColors.skyBlue,
            onPressed: () => getDayMeal(1),
          )
        ],
      ),
      body: Container(
        color: AppColors.lightGray,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 19, bottom: 14, left: 10, right: 10),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < _pages.length; i++)
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(i,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 22, right: 22, top: 8, bottom: 8),
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
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowIndicator();
                  return true;
                },
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
            ),
          ],
        ),
      )
    );
  }


}

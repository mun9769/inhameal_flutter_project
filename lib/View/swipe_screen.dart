import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:inhameal_flutter_project/Model/WidgetData.dart';
import 'package:inhameal_flutter_project/constants/colors.dart';
import 'package:intl/intl.dart';
import '../Controller/data_controller.dart';
import '../Model/day_meal.dart';
import '../constants/static_variable.dart';
import 'component/menu_board_view.dart';

//ignore: must_be_immutable
class SwipePage extends StatefulWidget {
  final VoidCallback onUpdateCafeList;

  SwipePage({Key? key, required this.onUpdateCafeList}) : super(key: key);

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  late PageController _pageController;
  final DataController _dataController = DataController(); // TODO: widget으로 올리기
  late int selectedPage;
  late DayMeal dayMeal; // _dataController를 참조한 것인가? 아님 복사한것인가? // final 붙여도 되나?
  late DateTime currentDate; // final 붙여도 되나?
  late List<Widget> cafepages;

  @override
  void initState() {
    super.initState();
    dayMeal = _dataController.dayMeal;
    currentDate = _dataController.currentDate;
    cafepages = _dataController.cafepages;
    selectedPage = _dataController.selectedPage;

    _pageController = PageController(initialPage: this.selectedPage, viewportFraction: 1);
  }

  void _sendWidgetData() {
    final object = TestWidgetData.of(dayMeal.dormCafe);
    final data = json.encode(object.toJson());
    WidgetKit.setItem('widgetData', data, 'group.inhameal.widget');
    WidgetKit.reloadAllTimelines();
  }

  void _onReorder(int oldIndex, int newIndex) {
    _dataController.onReorder(oldIndex, newIndex);
    setState(() {
      this.selectedPage = _dataController.selectedPage;
    });
    widget.onUpdateCafeList();
    // TODO: alert window
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.transparent,
                  shadowColor: Colors.blue.withOpacity(0.2),
                ),
                child: ReorderableListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _dataController.cafeList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return GestureDetector(
                      key: ValueKey(i),
                      onTap: () {
                        _pageController.animateToPage(i, duration: Duration(milliseconds: 300), curve: Curves.ease);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.0),
                          color: _dataController.selectedPage == i ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSecondary,
                        ),
                        child: Center(
                          child: Text(
                            AppVar.cafeKorean[_dataController.cafeList[i]] ?? "식당",
                            style: TextStyle(
                              color: _dataController.selectedPage == i ? Colors.white : Theme.of(context).colorScheme.background,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w800,
                            ),
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                          ),
                        ),
                      ),
                    );
                  },
                  onReorder: this._onReorder,
                ),
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
                      _dataController.selectedPage = page;
                    });
                  },
                  children: List.generate(cafepages.length, (index) {
                    return cafepages[index];
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    String _appBarTitle() {
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
      String? day = DateFormat('E').format(currentDate);
      day = AppVar.weeks[day];
      if (day == null) return formattedDate;
      day = "($day)";
      return formattedDate + day;
    }

    void getDayMeal(int days) async {
      DateTime tmrw = currentDate.add(Duration(days: days));
      String tmrwStr = DateFormat('yyyyMMdd').format(tmrw);

      try {
        await _dataController.getTmrwDayMeal(tmrwStr);

        setState(() {
          currentDate = _dataController.currentDate;
          cafepages = _dataController.cafepages;
        });
      } catch (e) {
        _showAlert();
      }
    }

    bool _isToday() {
      final DateFormat formatter = DateFormat('yyyyMMdd');
      final String formattedCurrenntDate = formatter.format(currentDate);
      final String today = formatter.format(DateTime.now());

      return formattedCurrenntDate == today;
    }
    // above 3 functions dismiss.

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/calendar.png', height: 21, width: 20, color: Theme.of(context).colorScheme.onPrimary),
          SizedBox(width: 6),
          Text(
            _appBarTitle(),
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: _isToday() ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.onPrimary,
        onPressed: _isToday() ? null : () => getDayMeal(-1),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () => getDayMeal(1),
        )
      ],
    );
  }

  void _showAlert() {
    String content = "아직 업데이트되지 않았어요\n매주 주말에 업로드됩니다 :)";
    showDialog(
      context: context,
      builder: (_) {
        return (Theme.of(context).platform == TargetPlatform.iOS)
            ? CupertinoAlertDialog(
                content: Text(content),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text("확인"),
                  ),
                ],
              )
            : AlertDialog(
                // TODO: 아이폰 안드로이드, 반복코드 줄이기
                content: Text(content),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text("확인"),
                  ),
                ],
              );
      },
    );
  }
}

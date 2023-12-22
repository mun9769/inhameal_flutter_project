import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/View/swipe_screen.dart';
import 'package:intl/intl.dart';

import '../Controller/data_controller.dart';

import '../Model/day_meal.dart';
import '../constants/colors.dart';
import '../constants/static_variable.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  final DataController _dataController = DataController();

  String getDateNow() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DayMeal>(
      future: _dataController.loadData(getDateNow()), // "20240910"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          _dataController.loadSeveralData(getDateNow());
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return reloadView(context, snapshot);
        } else {
          return SwipePage(dayMeal: snapshot.data!);
        }
      },
    );
  }

  Widget reloadView(BuildContext context, AsyncSnapshot snapshot) {
    TextButton button = TextButton(
      onPressed: () {
        setState(() {});
      },
      child: Text("정보를 불러오는데 실패했어요", style: TextStyle(fontSize: 24)),
    );
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/calendar.png', height: 21, width: 20),
            SizedBox(width: 6),
            Text(
              "에러",
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
          color: AppColors.littleDeepGray,
          onPressed: null,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            color: AppColors.littleDeepGray,
            onPressed: null,
          )
        ],
      ),
      body: Container(
        color: AppColors.lightGray,
        child: Center(
          child: Column(
            children: [
              button,
              Text(snapshot.hasError ? "${snapshot.error?.toString()}" : "")
            ],
          ),
        ),
      ),
    );
  }

  String getToday() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM월 dd일 ').format(now);
    String? day = DateFormat('E').format(now);
    day = AppVar.weeks[day];
    return formattedDate + (day ?? "");
  }
}

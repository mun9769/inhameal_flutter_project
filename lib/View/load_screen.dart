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
      future: _dataController.loadData("20230925"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
      child: Text("다시 불러오기", style: TextStyle(fontSize: 24)),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(getToday()),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.lightGray,
        child: Center(
          child: button,
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

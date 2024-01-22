import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:inhameal_flutter_project/View/swipe_screen.dart';
import 'package:intl/intl.dart';
import '../Controller/data_controller.dart';
import '../Model/WidgetData.dart';
import '../Model/day_meal.dart';
import '../constants/colors.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  final DataController _dataController = DataController();

  String _getTodayString() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);
    return formattedDate;
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DayMeal>(
      future: _dataController.fetchWeeklyData(_getTodayString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return reloadView();
        } else {
          return SwipePage(dayMeal: snapshot.data!);
        }
      },
    );
  }

  Widget reloadView() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ":(",
          style: TextStyle(color: AppColors.skyBlue, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: AppColors.lightGray,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("죄송합니다 다시 시도해주세요"),
              SizedBox(height: 6),
              FilledButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text("다시 불러오기", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

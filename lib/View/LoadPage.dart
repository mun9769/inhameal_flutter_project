import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inhameal_flutter_project/View/FailPage.dart';
import 'package:inhameal_flutter_project/View/SwipePage.dart';
import 'package:intl/intl.dart';

import '../Controller/DataController.dart';

import '../Model/DayMeal.dart';
import '../constants/colors.dart';
import '../constants/static_variable.dart';

class LoadPage extends StatefulWidget {
  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  final DataController _dataController = DataController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DayMeal>(
      future: _dataController.loadData(),
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
        backgroundColor: AppColors.orange[300],
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.orange[50],
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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inhameal_flutter_project/View/SwipePage.dart';

import '../Controller/DataController.dart';

import '../Model/DayMeal.dart';


class LoadPage extends StatelessWidget {

  final DataController _dataController = DataController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DayMeal>(
          future: _dataController.fetchDayMeal(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) { // 내가 만든 throw가 이 haserror와 동일한가?
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return SwipePage(dayMeal: snapshot.data!);
            }
          }
      ),
    );
  }

}
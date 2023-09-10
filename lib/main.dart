import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/constants/colors.dart';
import 'View/load_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MaterialApp',
      theme: ThemeData(primaryColor: AppColors.orange[300]),
      home: LoadPage(),
      // home: SwipePage(),
    );
  }
}


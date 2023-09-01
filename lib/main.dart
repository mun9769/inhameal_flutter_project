import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/View/favorite_screen.dart';
import 'View/LoadPage.dart';

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
      home: SafeArea(child: FavScreen()),
    );
  }
}


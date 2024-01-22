import 'package:flutter/material.dart';
import 'View/load_screen.dart';
import 'constants/theme/dark_theme.dart';
import 'constants/theme/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadPage(),
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}


import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/constants/colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  // appBarTheme: AppBarTheme(
  //   backgroundColor: ,
  //   elevation: 0,
  //   iconTheme: IconThemeData(color: Colors.black),
  //   titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
  // ),
  // colorScheme: ColorScheme.light(
  //   background: ,
  //   primary: ,
  //   secondary: ,
  // ),
  // primaryTextTheme: ,

  focusColor: Colors.yellow,
  textTheme: TextTheme(

    labelLarge: TextStyle(color: AppColors.textWhite, fontSize: 14.0, fontWeight: FontWeight.w800),
    labelSmall: TextStyle( color: AppColors.deepGray, fontSize: 14.0, fontWeight: FontWeight.w800),

  )
);
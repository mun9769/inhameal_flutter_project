import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/constants/colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.skyBlue,
    onPrimary: AppColors.appBarTitle,
    secondary: AppColors.lightGray,
    onSecondary: AppColors.gray,
    background: AppColors.deepGray,
    onSurface: AppColors.white,

    error: Colors.red,
    onError: Colors.red,
    onBackground: Colors.black12,
    surface: Colors.black12,
  ),
);

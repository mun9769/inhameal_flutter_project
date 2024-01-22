import 'package:flutter/material.dart';
import 'package:inhameal_flutter_project/constants/colors.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: AppColorsDark.skyBlue,
    onPrimary: AppColorsDark.appBarTitle,
    secondary: AppColorsDark.lightGray,
    onSecondary: AppColorsDark.gray,
    background: AppColorsDark.deepGray,
    onSurface: AppColorsDark.white,

    onBackground: Colors.black12,
    surface: Colors.black12,
    error: Colors.red,
    onError: Colors.red,
  ),
);
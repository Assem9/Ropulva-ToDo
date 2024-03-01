import 'package:flutter/material.dart';
import 'package:ropulva_task/core/themes/colors.dart';

final lightTheme = ThemeData(
    //colorScheme: ColorScheme.fromSeed(seedColor: MyColors.green),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xffFFFFFF),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 30,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      titleMedium:  TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium:  TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    )
);
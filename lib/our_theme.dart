import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wetherapp/colors.dart';

class CustomTheme{

  static final lightTheme=ThemeData(
    cardColor: Colors.white,
    fontFamily: "poppins",
    scaffoldBackgroundColor: Colors.white,
      primaryColor: Vx.gray800,
    iconTheme: const IconThemeData(
      color: Vx.gray600,
    )
  );
  static final darkTheme=ThemeData(
    cardColor: bgColor.withOpacity(0.2),
      fontFamily: "poppins",
      scaffoldBackgroundColor: bgColor,
      primaryColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.white,
      )
  );

}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MyThemeKeys { DARK, BLUE, GREEN, ORANGE, PINK }

class MyThemes {
  static const appColorDark = Color(0xFF232122);
  static const appColorLight = Color(0xFFFFFFFF);
  static const appColor = Color(0xFF232122);
  static const appColorLght = Color(0xFF3D3A3C);
  static const errorColor = Color(0xFFC1405F);
  static const focusColor = Color(0xFF29809B);
  
  static const greenColor = Color(0xFF43AA9E);
  static const orangeColor = Color(0xFFBB7F5F);
  static const pinkColor = Color(0xFFC77BA2);

 

  static final ThemeData darkTheme = ThemeData(
    primaryColor: appColor,
    primaryColorDark: appColorDark,
    primaryColorLight: appColorLight,
    accentColor: appColorLight,
    focusColor: focusColor,
    errorColor: errorColor,
    fontFamily: 'Poppins',
    textSelectionColor: focusColor,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      color: appColor,
    ),
    
  );

  static final ThemeData blueTheme = ThemeData(
    primaryColor: appColor,
    primaryColorDark: focusColor,
    primaryColorLight: appColorLght,
    accentColor: appColorLight,
    focusColor: appColor,
    errorColor: errorColor,
    fontFamily: 'Poppins',
    textSelectionColor: appColor,
    appBarTheme: AppBarTheme(
      color: focusColor,
    ),
  );

  static final ThemeData greenTheme = ThemeData(
    primaryColor: appColor,
    primaryColorDark: greenColor,
    primaryColorLight: appColorLght,
    accentColor: appColor,
    focusColor: focusColor,
    errorColor: errorColor,
    fontFamily: 'Poppins',
    textSelectionColor: focusColor,
    appBarTheme: AppBarTheme(
      color: greenColor,
    ),
  );
  static final ThemeData orangeTheme = ThemeData(
    primaryColor: appColor,
    primaryColorDark: orangeColor,
    primaryColorLight: appColorLght,
    accentColor: appColor,
    focusColor: focusColor,
    errorColor: errorColor,
    fontFamily: 'Poppins',
    textSelectionColor: focusColor,
    appBarTheme: AppBarTheme(
      color: orangeColor,
    ),
    
  );
  static final ThemeData pinkTheme = ThemeData(
    primaryColor: appColor,
    primaryColorDark: pinkColor,
    primaryColorLight: appColorLght,
    accentColor: appColor,
    focusColor: focusColor,
    errorColor: errorColor,
    fontFamily: 'Poppins',
    textSelectionColor: focusColor,
    appBarTheme: AppBarTheme(
      color: pinkColor,
    ),
    
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.DARK:
        return darkTheme;
      case MyThemeKeys.BLUE:
        return blueTheme;
      case MyThemeKeys.GREEN:
        return greenTheme;
      case MyThemeKeys.ORANGE:
        return orangeTheme;
      case MyThemeKeys.PINK:
        return pinkTheme;
      default:
        return darkTheme;
    }
  }
}
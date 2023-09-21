import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui/config/strings.dart';
import '../config/size_config.dart';

Map<int, Color> color = {
  50: const Color.fromRGBO(136, 14, 79, .1),
  100: const Color.fromRGBO(136, 14, 79, .2),
  200: const Color.fromRGBO(136, 14, 79, .3),
  300: const Color.fromRGBO(136, 14, 79, .4),
  400: const Color.fromRGBO(136, 14, 79, .5),
  500: const Color.fromRGBO(136, 14, 79, .6),
  600: const Color.fromRGBO(136, 14, 79, .7),
  700: const Color.fromRGBO(136, 14, 79, .8),
  800: const Color.fromRGBO(136, 14, 79, .9),
  900: const Color.fromRGBO(136, 14, 79, 1),
};

MaterialColor primaryCustom = MaterialColor(0xFFE5097F, color);
MaterialColor secondaryCustom = MaterialColor(0xFF2D4694, color);

class AppTheme {
  AppTheme._();

  static const Color appBackgroundColor = Colors.white;
  //static const Color topBarBackgroundColor = Color(0xFFFFD974);
  static const Color selectedTabBackgroundColor = Color(0xFFFFC442);
  static const Color unSelectedTabBackgroundColor = Color(0xFFFFFFFC);
  static const Color subTitleTextColor = Color(0xFF9F988F);

  static final ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: AppTheme.appBackgroundColor,
      brightness: Brightness.light,
      textTheme: lightTextTheme,
      primaryColor: primaryCustom,
      hintColor: Colors.grey[600],
      fontFamily: "Roboto",
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryCustom,
          selectionColor: primaryCustom,
          selectionHandleColor: primaryCustom),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: appBarThemeLight,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryCustom)
      //inputDecorationTheme: lightInputTheme
      );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    textTheme: darkTextTheme,
    primaryColor: primaryCustom,
    hintColor: Colors.grey,
    fontFamily: Strings.fonts,
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryCustom,
        selectionColor: primaryCustom,
        selectionHandleColor: primaryCustom),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryCustom),
    //buttonTheme: ButtonThemeData(buttonColor: secondaryCustom)
    //inputDecorationTheme: darkInputTheme
  );

  static final TextTheme lightTextTheme = TextTheme(
    headline6: _titleLight,
    subtitle2: _subTitleLight,
    button: _buttonLight,
    headline4: _greetingLight,
    headline3: _searchLight,
    bodyText2: _bodyText2Light,
    bodyText1: _bodyText1Light,
  );

  static final TextTheme darkTextTheme = TextTheme(
    headline6: _titleDark,
    subtitle2: _subTitleDark,
    button: _buttonDark,
    headline4: _greetingDark,
    headline3: _searchDark,
    bodyText2: _bodyText2Dark,
    bodyText1: _bodyText1Dark,
  );

  static final InputDecorationTheme lightInputTheme = InputDecorationTheme(
      //contentPadding: EdgeInsets.all(10.0),
      fillColor: Colors.grey[300],
      border: InputBorder.none,
      filled: true,
      isDense: true);

  static final InputDecorationTheme darkInputTheme = InputDecorationTheme(
    //contentPadding: EdgeInsets.all(10.0),
    border: InputBorder.none,
    fillColor: Colors.grey[300],
    filled: true,
    isDense: true,
  );

  static final TextStyle _titleLight = TextStyle(
    color: Colors.black,
    fontSize: 3.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle _subTitleLight = TextStyle(
    color: subTitleTextColor,
    fontSize: 2 * SizeConfig.textMultiplier,
    height: 1.5,
  );

  static final TextStyle _buttonLight = TextStyle(
    color: Colors.black,
    fontSize: 2.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle _greetingLight = TextStyle(
    color: Colors.black,
    fontSize: 2.0 * SizeConfig.textMultiplier,
  );

  static final TextStyle _searchLight = TextStyle(
    color: Colors.black,
    fontSize: 2.3 * SizeConfig.textMultiplier,
  );

  static final TextStyle _bodyText1Light = TextStyle(
    color: Colors.grey[900],
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle _bodyText2Light = TextStyle(
    color: Colors.grey[900],
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle _titleDark = _titleLight.copyWith(color: Colors.white);

  static final TextStyle _subTitleDark =
      _subTitleLight.copyWith(color: Colors.white70);

  static final TextStyle _buttonDark =
      _buttonLight.copyWith(color: Colors.black);

  static final TextStyle _greetingDark =
      _greetingLight.copyWith(color: Colors.black);

  static final TextStyle _searchDark =
      _searchLight.copyWith(color: Colors.black);

  static final TextStyle _bodyText2Dark =
      _bodyText2Light.copyWith(color: Colors.white);

  static final TextStyle _bodyText1Dark =
      _bodyText1Light.copyWith(color: Colors.white70);

  static const AppBarTheme appBarThemeLight =
      AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light);
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ui/utils/utils_file.dart';

class TextBottomWidget extends StatelessWidget {
  String text;
  Color colors;
  TextBottomWidget({super.key, required this.text, required this.colors});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Text(text,
        style: SafeGoogleFont(
          'Inter',
          fontSize: 16 * ffem,
          fontWeight: FontWeight.w400,
          height: 1.2125 * ffem / fem,
          decoration: TextDecoration.underline,
          color: colors,
        ));
  }
}

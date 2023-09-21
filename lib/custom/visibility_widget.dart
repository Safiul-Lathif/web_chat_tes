// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ui/utils/utils_file.dart';

class VisibilityWidget extends StatelessWidget {
  VisibilityWidget({super.key, required this.visible, required this.role});
  String visible;
  String role;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return role == 'Parent'
        ? const SizedBox(
            height: 10,
          )
        : Container(
            margin: EdgeInsets.fromLTRB(13 * fem, 5 * fem, 13 * fem, 15 * fem),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.34,
            ),
            child: Text(
              visible,
              style: SafeGoogleFont(
                'Inter',
                fontSize: 12 * ffem,
                fontWeight: FontWeight.w400,
                // height: 0.9152272542 * ffem / fem,
                letterSpacing: 1.2 * fem,
                color: const Color(0xff000000),
              ),
            ),
          );
  }
}

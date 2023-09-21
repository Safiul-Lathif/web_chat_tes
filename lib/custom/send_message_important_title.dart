
import 'package:flutter/material.dart';
import 'package:ui/model/message_view_model.dart';

class SendMessageImportantTitle extends StatelessWidget {
  const SendMessageImportantTitle({super.key, required this.data});
  final Message data;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 5, bottom: 0),
      child: Container(
        padding: EdgeInsets.fromLTRB(11 * fem, 4 * fem, 15 * fem, 3 * fem),
        height: 23,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7 * fem),
          gradient: const LinearGradient(
              colors: [Color(0xff64a78b), Color(0xff69c767)],
              begin: Alignment.topLeft,
              end: Alignment.centerRight),
          boxShadow: [
            BoxShadow(
              color: const Color(0x3f000000),
              offset: Offset(-2 * fem, 2 * fem),
              blurRadius: 2 * fem,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data.user,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              data.designation.toString(),
              softWrap: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}

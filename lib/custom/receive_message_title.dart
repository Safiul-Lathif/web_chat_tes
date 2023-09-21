import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/model/message_view_model.dart';

class ReceiveMessageTitle extends StatelessWidget {
  const ReceiveMessageTitle(
      {super.key, required this.data, required this.asset});
  final Message data;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (asset != '')
          Image.asset(
            asset,
            height: 23,
            width: 23,
          ),
        const SizedBox(
          width: 5,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(19),
                bottomLeft: Radius.circular(19),
                bottomRight: Radius.circular(19)),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
            gradient: data.distributionType == 7
                ? LinearGradient(colors: [
                    Colors.blue.shade200,
                    Colors.blue.shade400,
                  ], begin: Alignment.topLeft, end: Alignment.centerRight)
                : LinearGradient(colors: [
                    Colors.pink.shade100,
                    Colors.pink.shade400,
                  ], begin: Alignment.topLeft, end: Alignment.centerRight),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  data.user,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  data.designation.toString(),
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                if (data.distributionType == 7)
                  Text(" (Only for you)",
                      style: GoogleFonts.aBeeZee(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        if (data.distributionType == 7)
          const Icon(
            Icons.verified,
            color: Colors.red,
          )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ui/model/message_view_model.dart';

class SendMessageTitle extends StatelessWidget {
  const SendMessageTitle({super.key, required this.data, required this.asset});
  final Message data;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 27,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(19),
                bottomLeft: Radius.circular(19),
                bottomRight: Radius.circular(19)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
            gradient: LinearGradient(
                colors: [Color(0xff64a78b), Color(0xff69c767)],
                begin: Alignment.topLeft,
                end: Alignment.centerRight),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
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
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        if (asset != '')
          Image.asset(
            asset,
            height: 23,
            width: 23,
          ),
      ],
    );
  }
}

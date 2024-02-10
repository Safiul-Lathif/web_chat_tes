import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui/pages/message_read_info_page.dart';
import 'package:ui/utils/utils_file.dart';

import '../Utils/Utility.dart';

class NewTimeWidget extends StatefulWidget {
  const NewTimeWidget(
      {super.key,
      required this.tym,
      required this.notiid,
      required this.gid,
      required this.role,
      required this.isDeleted,
      required this.redCount,
      required this.communicationType});
  final String tym;
  final int notiid;
  final String gid;
  final String role;
  final bool isDeleted;
  final int redCount;
  final String communicationType;

  @override
  State<NewTimeWidget> createState() => _NewTimeWidgetState();
}

class _NewTimeWidgetState extends State<NewTimeWidget> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 1400;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Row(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // group22AbL (7:847)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 3 * fem, 1 * fem),
              width: 10 * fem,
              height: 10 * fem,
              child: Image.asset(
                'assets/images/group-22-MXG.png',
                width: 10 * fem,
                height: 10 * fem,
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            Column(
              children: [
                Text(
                  Utility.convertTimeFormat(widget.tym.split(' ').last),
                  //widget.tym.split(' ').last,
                  style: SafeGoogleFont(
                    'Inter',
                    fontSize: 10 * ffem,
                    fontWeight: FontWeight.w300,
                    height: 0.9152273178 * ffem / fem,
                    letterSpacing: 1 * fem,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          width: 4,
        ),
        !widget.isDeleted
            ? InkWell(
                onTap: () async {
                  HapticFeedback.vibrate();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MessageReadInfoPage(
                                notiid: widget.notiid,
                                gid: widget.gid,
                                role: widget.role,
                                communicationType: widget.communicationType,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.role != "Parent"
                          ? const Icon(
                              Icons.remove_red_eye,
                              color: Colors.blue,
                              size: 16,
                            )
                          : Container(),
                      const SizedBox(
                        width: 3,
                      ),
                      widget.role != "Parent"
                          ? Text(
                              widget.redCount.toString(),
                              style: SafeGoogleFont(
                                'Inter',
                                fontSize: 10 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 0.9152273178 * ffem / fem,
                                letterSpacing: 1 * fem,
                                color: Colors.black,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

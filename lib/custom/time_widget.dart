import 'package:flutter/material.dart';
import 'package:ui/api/message_read_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/model/message_read_info_model.dart';
import 'package:ui/pages/message_read_info_page.dart';
import 'package:ui/utils/utils_file.dart';
import 'package:ui/utils/utility.dart';

class TimeWidget extends StatefulWidget {
  const TimeWidget(
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
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  Iterable<DeliveredUser>? readInfo;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 7,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.timelapse,
              color: Colors.black,
              size: 16,
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
          height: 4,
        ),
        !widget.isDeleted
            ? InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => Material(
                            type: MaterialType.transparency,
                            child: Center(
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: MessageReadInfoPage(
                                      notiid: widget.notiid,
                                      gid: widget.gid,
                                      role: widget.role,
                                      communicationType:
                                          widget.communicationType,
                                    ))),
                          ));
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

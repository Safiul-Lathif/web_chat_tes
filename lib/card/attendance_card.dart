import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/approve_deny.dart';
import 'package:ui/custom/deleted_widget.dart';
import 'package:ui/custom/info_delete.dart';
import 'package:ui/custom/receive_message_importatnt_title.dart';
import 'package:ui/custom/send_message_important_title.dart';
import 'package:ui/custom/time_widget.dart';
import 'package:ui/custom/visibility_widget.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/utils/utils_file.dart';

import '../utils/utility.dart';

class AttendanceCard extends StatefulWidget {
  const AttendanceCard({
    super.key,
    required this.data,
    required this.itemIndex,
    required this.id,
    required this.notiid,
    required this.callback,
    required this.role,
    required this.type,
    required this.redCount,
  });
  final Message data;
  final int itemIndex;
  final String id;
  final int notiid;
  final Function callback;
  final String role;
  final int type;
  final int redCount;

  @override
  State<AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return widget.data.messageStatus == 1 || widget.data.approvalStatus == 2
        ? DeletedWidget(
            redCount: widget.redCount,
            data: widget.data,
            itemIndex: widget.itemIndex,
            id: widget.id,
            notiid: widget.notiid,
            callback: widget.callback,
            role: widget.role,
            messageCategory: widget.data.messageCategory,
            type: widget.type)
        : widget.type == 2
            ? receivedMessage()
            : sendMessage();
  }

  receivedMessage() {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/chat/circular.png',
              width: 25,
              height: 25,
            ),
            const SizedBox(
              width: 6,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(5)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.orange.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    const Text(
                      'Attendance',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    if (widget.data.distributionType == 7 &&
                        widget.role.toUpperCase() == "PARENT")
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
            if (widget.data.distributionType == 7 &&
                widget.role.toUpperCase() == "PARENT")
              const Icon(
                Icons.verified,
                color: Colors.red,
              )
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            ReceiveMessageImportantTitle(data: widget.data),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            Visibility(
              visible: isVisible,
              child: InfoDeleteWidget(
                  isDeleted: false,
                  data: widget.data,
                  itemIndex: widget.itemIndex,
                  id: widget.id,
                  callback: widget.callback,
                  type: widget.type),
            ),
            InkWell(
              onLongPress: widget.role == 'Parent'
                  ? null
                  : () {
                      HapticFeedback.vibrate();
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
              child: ChatBubble(
                clipper: ChatBubbleClipper10(type: BubbleType.receiverBubble),
                backGroundColor: const Color(0xffE7E7ED),
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(bottom: 3, left: 5, right: 10),
                child: Row(
                  children: [
                    Image.asset(
                      Chat.attendanceIcon,
                      width: 50,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.15,
                      ),
                      child: ExpandableText(
                        widget.data.message.toString(),
                        expandText: 'show more',
                        collapseText: 'show less',
                        maxLines: 7,
                        onExpandedChanged: (value) {
                          setState(() {
                            if (value == true) {
                              Utility.popUpDialog(context, widget.data);
                            }
                          });
                        },
                        style: SafeGoogleFont(
                          'Inter',
                          fontSize: 15,
                          color: const Color(0xff303030),
                        ),
                        linkColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.data.approvalStatus == 0
                ? ApproveDenyWidget(
                    user: widget.role,
                    data: widget.data,
                    callback: widget.callback,
                  )
                : TimeWidget(
                    communicationType: widget.data.communicationType.toString(),
                    redCount: widget.redCount,
                    role: widget.role,
                    tym: widget.data.dateTime.toString(),
                    notiid: widget.notiid,
                    gid: widget.id,
                    isDeleted: false,
                  )
          ],
        ),
        Padding(
            padding: const EdgeInsets.only(left: 7),
            child: VisibilityWidget(
                role: widget.role, visible: widget.data.visibility.toString())),
      ],
    );
  }

  sendMessage() {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(10)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: [Colors.deepOrange, Colors.orange.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'Attendance',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Image.asset(
                "assets/chat/circular.png",
                height: 25,
                width: 25,
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SendMessageImportantTitle(data: widget.data),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            widget.data.approvalStatus == 0
                ? ApproveDenyWidget(
                    user: widget.role,
                    data: widget.data,
                    callback: widget.callback,
                  )
                : TimeWidget(
                    communicationType: widget.data.communicationType.toString(),
                    redCount: widget.redCount,
                    role: widget.role,
                    tym: widget.data.dateTime.toString(),
                    notiid: widget.notiid,
                    gid: widget.id,
                    isDeleted: false,
                  ),
            InkWell(
              onLongPress: () {
                HapticFeedback.vibrate();
                setState(() {
                  isVisible = !isVisible;
                });
              },
              child: ChatBubble(
                clipper: ChatBubbleClipper10(type: BubbleType.sendBubble),
                backGroundColor: const Color(0xffE7E7ED),
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(bottom: 3, left: 5, right: 5),
                child: Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.15,
                      ),
                      child: ExpandableText(
                        widget.data.message.toString(),
                        expandText: 'show more',
                        collapseText: 'show less',
                        maxLines: 7,
                        onExpandedChanged: (value) {
                          setState(() {
                            if (value == true) {
                              Utility.popUpDialog(context, widget.data);
                            }
                          });
                        },
                        style: SafeGoogleFont(
                          'Inter',
                          fontSize: 15,
                          color: const Color(0xff303030),
                        ),
                        linkColor: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      Chat.attendanceIcon,
                      width: 50,
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isVisible,
              child: InfoDeleteWidgetRight(
                  isDeleted: false,
                  data: widget.data,
                  itemIndex: widget.itemIndex,
                  id: widget.id,
                  callback: widget.callback,
                  type: widget.type),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.only(right: 10),
            child: VisibilityWidget(
                role: widget.role, visible: widget.data.visibility.toString())),
      ],
    );
  }
}

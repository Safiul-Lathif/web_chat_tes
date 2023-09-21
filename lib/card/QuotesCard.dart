import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/approve_deny.dart';
import 'package:ui/custom/info_delete.dart';
import 'package:ui/custom/receive_message_importatnt_title.dart';
import 'package:ui/custom/send_message_important_title.dart';
import 'package:ui/custom/time_widget.dart';
import 'package:ui/custom/visibility_widget.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/utils/utils_file.dart';

class QuoteCard extends StatefulWidget {
  const QuoteCard({
    super.key,
    required this.data,
    required this.itemIndex,
    required this.id,
    required this.notiid,
    required this.usr_Name,
    required this.callback,
    required this.role,
    required this.type,
    required this.redCount,
  });
  final Message data;
  final int itemIndex;
  final String id;
  final int notiid;
  final String usr_Name;
  final Function callback;
  final String role;
  final int type;
  final int redCount;

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return widget.type == 1
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
                            colors: [
                              Colors.yellow.shade500,
                              Colors.yellow.shade900
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.centerRight),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          'Quote',
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
                      Chat.quotesIcon,
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
                          redCount: widget.redCount,
                          communicationType:
                              widget.data.communicationType.toString(),
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
                      margin:
                          const EdgeInsets.only(bottom: 3, left: 5, right: 5),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                        ),
                        child: Text(
                          widget.data.message.toString(),
                          style: SafeGoogleFont('Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.2125,
                              color: Colors.black87
                              // color: const Color(0xff620d00),
                              ),
                        ),
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
                ],
              ),
              VisibilityWidget(
                  role: widget.role,
                  visible: widget.data.visibility.toString()),
            ],
          )
        : Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      Chat.quotesIcon,
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
                            colors: [
                              Colors.yellow.shade900,
                              Colors.yellow.shade500,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.centerRight),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            const Text(
                              'Quotes',
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
                        clipper: ChatBubbleClipper10(
                            type: BubbleType.receiverBubble),
                        backGroundColor: const Color(0xffE7E7ED),
                        alignment: Alignment.topRight,
                        margin: const EdgeInsets.only(
                            bottom: 3, left: 5, right: 10),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: Text(
                            widget.data.message.toString(),
                            style: SafeGoogleFont('Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                height: 1.2125,
                                color: Colors.black87
                                // color: const Color(0xff620d00),
                                ),
                          ),
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
                            redCount: widget.redCount,
                            role: widget.role,
                            tym: widget.data.dateTime.toString(),
                            notiid: widget.notiid,
                            gid: widget.id,
                            communicationType:
                                widget.data.communicationType.toString(),
                            isDeleted: false,
                          )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: VisibilityWidget(
                      role: widget.role,
                      visible: widget.data.visibility.toString()),
                ),
              ],
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/deleted_widget.dart';
import 'package:ui/custom/info_delete.dart';
import 'package:ui/custom/receive_message_importatnt_title.dart';
import 'package:ui/custom/send_message_important_title.dart';
import 'package:ui/custom/time_widget.dart';
import 'package:ui/model/message_view_model.dart';

import '../custom/visibility_widget.dart';

class EventsCard extends StatefulWidget {
  const EventsCard({
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
  State<EventsCard> createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> {
  bool isVisible = false;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return widget.data.messageStatus == 3
        ? DeletedWidget(
            redCount: widget.redCount,
            data: widget.data,
            itemIndex: widget.itemIndex,
            id: widget.id,
            notiid: widget.notiid,
            callback: widget.callback,
            role: widget.role,
            messageCategory: 'Events',
            type: widget.type)
        : widget.type == 2
            ? receivedMessage(context)
            : sendMessage(context);
  }

  receivedMessage(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              Chat.eventsIcon,
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
                    colors: [Colors.orange.shade300, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    const Text(
                      'Events',
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
                  data: widget.data,
                  itemIndex: widget.itemIndex,
                  isDeleted: false,
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
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  child: InkWell(
                    onTap: () {
                      // getSingleEvent(widget.data.notificationId.toString())
                      //     .then((value) {
                      //   if (value != null) {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => DetailsPageEvents(
                      //                 isPast: false, eventFeed: value)));
                      //   }
                      // });
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          padding: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.blue.withOpacity(0.3),
                                  BlendMode.dstATop),
                              image: const AssetImage(Images.bgImage),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(.5),
                                  offset: const Offset(3, 2),
                                  blurRadius: 7)
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                child: Image.network(
                                  widget.data.images![0].contains("https://")
                                      ? widget.data.images![0]
                                      : widget.data.images![0]
                                              .contains("http://")
                                          ? widget.data.images![0]
                                          //data.images.toString()
                                          : "http://${widget.data.images![0]}",
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.height * 0.18,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  widget.data.title!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Date :',
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(
                                        widget.data.eventDate!,
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Time :',
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(
                                        DateFormat.jm().format(
                                            DateFormat("hh:mm:ss").parse(widget
                                                .data.eventTime
                                                .toString())),
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ),
            TimeWidget(
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
          padding: const EdgeInsets.only(left: 6),
          child: VisibilityWidget(
              role: widget.role, visible: widget.data.visibility.toString()),
        )
      ],
    );
  }

  sendMessage(
    BuildContext context,
  ) {
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
                      colors: [Colors.orange.shade300, Colors.orange],
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'Events',
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
                Chat.eventsIcon,
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
            TimeWidget(
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
                margin: const EdgeInsets.only(
                  bottom: 3,
                  left: 5,
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.15,
                  ),
                  child: InkWell(
                    onTap: () {
                      // getSingleEvent(widget.data.notificationId.toString())
                      //     .then((value) {
                      //   if (value != null) {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => DetailsPageEvents(
                      //                 isPast: false, eventFeed: value)));
                      //   }
                      // });
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.blue.withOpacity(0.3),
                                  BlendMode.dstATop),
                              image: const AssetImage(Images.bgImage),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(.5),
                                  offset: const Offset(3, 2),
                                  blurRadius: 7)
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                child: Image.network(
                                  widget.data.images![0].contains("https://")
                                      ? widget.data.images![0]
                                      : widget.data.images![0]
                                              .contains("http://")
                                          ? widget.data.images![0]
                                          //data.images.toString()
                                          : "http://${widget.data.images![0]}",
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.height * 0.18,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  widget.data.title!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Date :',
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(
                                        widget.data.eventDate!,
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Time :',
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(
                                        DateFormat.jm().format(
                                            DateFormat("hh:mm:ss").parse(widget
                                                .data.eventTime
                                                .toString())),
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isVisible,
              child: InfoDeleteWidgetRight(
                data: widget.data,
                itemIndex: widget.itemIndex,
                id: widget.id,
                callback: widget.callback,
                type: widget.type,
                isDeleted: false,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: VisibilityWidget(
              role: widget.role, visible: widget.data.visibility.toString()),
        )
      ],
    );
  }
}

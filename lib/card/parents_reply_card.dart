import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:ui/api/approve_deney_api.dart';
import 'package:ui/api/delete_api.dart';
import 'package:ui/api/info_api.dart';
import 'package:ui/config/size_config.dart';
import 'package:ui/custom/approve_deny.dart';
import 'package:ui/custom/info_delete.dart';
import 'package:ui/custom/visibility_widget.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/utils/utils_file.dart';
import 'package:ui/utils/utility.dart';

import '../model/infomodel.dart';

class ParentsReplyCard extends StatefulWidget {
  const ParentsReplyCard({
    super.key,
    required this.data,
    required this.itemIndex,
    // required this.role,
    required this.id,
    required this.callback,
    required this.type,
    // required this.node,
    required this.role,
  });
  final Message data;
  // final String role;
  final int itemIndex;
  final String id;
  final Function callback;
  final int type;
  final String role;

  @override
  State<ParentsReplyCard> createState() => _ParentsReplyCardState();
}

class _ParentsReplyCardState extends State<ParentsReplyCard> {
  // List<MessageModel> list = getPendingList();
  bool isVisible = false;
  Info? infomessage;

  @override
  void initState() {
    super.initState();
    // initTimer();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return widget.type == 2
        ? Align(
            alignment: Alignment.centerLeft,
            child: Row(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                          ),
                          child: Container(
                            height: 27,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0),
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
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.shade300,
                                    Colors.pink.shade400,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.centerRight),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.data.user,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    widget.data.designation.toString(),
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
                        ),
                      ],
                    ),
                    widget.data.messageCategory == "Quotes"
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: SizedBox(
                              width: 120,
                              height: 32,
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/rectangle-7-oyU.png',
                                    ),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Quote",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    widget.data.messageCategory == "Document"
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: SizedBox(
                              width: 120,
                              height: 32,
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/rectangle-7-oyU.png',
                                    ),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Document",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Row(children: [
                      GestureDetector(
                        onLongPress: () {
                          HapticFeedback.vibrate();
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        ///////////////////////////////////////////////
                        child: widget.data.messageCategory == "Text"
                            ? ChatBubble(
                                clipper: ChatBubbleClipper10(
                                    type: BubbleType.receiverBubble),
                                backGroundColor: const Color(0xffE7E7ED),
                                margin:
                                    const EdgeInsets.only(bottom: 3, right: 10),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
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
                              )
                            : widget.data.messageCategory == "Images" ||
                                    widget.data.messageCategory ==
                                        "ImageWithCaption"
                                ? GestureDetector(
                                    onLongPress: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    },
                                    child: ChatBubble(
                                      clipper: ChatBubbleClipper10(
                                          type: BubbleType.receiverBubble),
                                      backGroundColor: const Color(0xffE7E7ED),
                                      margin: const EdgeInsets.only(
                                          bottom: 5, right: 10),
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              child: widget.data.images!
                                                          .length ==
                                                      1
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        // Navigator.push(context,
                                                        //     MaterialPageRoute(
                                                        //         builder: (_) {
                                                        //   return DetailScreen(
                                                        //       images: widget
                                                        //           .data.images!
                                                        //           .toList());
                                                        // }));
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                fit: BoxFit.cover,
                                                                image: NetworkImage(widget.data.images![0].contains("https://")
                                                                    ? widget.data.images![0]
                                                                    : widget.data.images![0].contains("http://")
                                                                        ? widget.data.images![0]
                                                                        //data.images.toString()
                                                                        : "http://${widget.data.images![0]}")),
                                                            borderRadius: BorderRadius.circular(7)),
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      height: 200,
                                                      child: GridView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                              maxCrossAxisExtent:
                                                                  200,
                                                              childAspectRatio:
                                                                  1.4,
                                                              crossAxisSpacing:
                                                                  5,
                                                              mainAxisSpacing:
                                                                  5),
                                                          itemCount: widget.data
                                                              .images!.length,
                                                          itemBuilder:
                                                              (BuildContext ctx,
                                                                  index) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                // Navigator.push(
                                                                //     context,
                                                                //     MaterialPageRoute(
                                                                //         builder:
                                                                //             (_) {
                                                                //   return DetailScreen(
                                                                //       images: widget
                                                                //           .data
                                                                //           .images!
                                                                //           .toList());
                                                                // }));
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        fit: BoxFit.cover,
                                                                        image: NetworkImage(widget.data.images![index].contains("https://")
                                                                            ? widget.data.images![index]
                                                                            : widget.data.images![index].contains("http://")
                                                                                ? widget.data.images![index]
                                                                                //data.images.toString()
                                                                                : "http://${widget.data.images![index]}")),
                                                                    borderRadius: BorderRadius.circular(7)),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                            ),
                                            widget.data.caption != null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Text(
                                                      widget.data.caption ?? '',
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : widget.data.messageCategory == "Quotes"
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 5,
                                            bottom: 0),
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blue),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                )),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  widget.data.message
                                                      .toString(),
                                                  //" \" He who has plans correctly and puts consistence efforts will always win!\" -- Anonymous  ",
                                                  textAlign: TextAlign.start,
                                                  style: SafeGoogleFont(
                                                    'Inter',
                                                    fontSize: 16 * ffem,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.2125 * ffem / fem,
                                                    color: Colors.black,
                                                  ),
                                                ))),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 5,
                                            bottom: 0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.pink),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15),
                                              )),
                                          child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                          backgroundColor:
                                                              Colors.pink
                                                                  .shade400,
                                                          child: const Icon(
                                                            Icons.play_arrow,
                                                            color: Colors.white,
                                                            size: 38,
                                                          )),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Image.network(
                                                        "https://cdn-icons-png.flaticon.com/512/6622/6622004.png",
                                                        height: 50,
                                                        color: Colors
                                                            .pink.shade400,
                                                      ),
                                                      Image.network(
                                                        "https://cdn-icons-png.flaticon.com/512/6622/6622004.png",
                                                        height: 50,
                                                        color: Colors
                                                            .pink.shade400,
                                                      ),
                                                      Image.network(
                                                        "https://cdn-icons-png.flaticon.com/512/6622/6622004.png",
                                                        height: 50,
                                                        color: Colors
                                                            .pink.shade400,
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .shortestSide,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: const [
                                                      Icon(
                                                        Icons.hearing,
                                                        size: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        "Linstned: 35",
                                                        style: TextStyle(
                                                            fontSize: 11),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                      ),
                      ApproveDenyWidget(
                        user: widget.role,
                        data: widget.data,
                        callback: widget.callback,
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: VisibilityWidget(
                          role: widget.role,
                          visible: widget.data.visibility.toString()),
                    ),
                    Container(
                      // group72SUS (7:816)

                      // width: 67 * fem,
                      // height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              // InkWell(
                              //   onTap: () {
                              //     showDialog(
                              //       context: context,
                              //       builder: (ctx) => AlertDialog(
                              //         title: Text(
                              //           "Aprove Confirmation",
                              //           style: TextStyle(
                              //               fontSize: 2.5 *
                              //                   SizeConfig
                              //                       .textMultiplier,
                              //               fontWeight: FontWeight.bold,
                              //               color: Colors.grey[700]),
                              //         ),
                              //         content: Text(
                              //           "Do you wants to Aprove the Message?",
                              //           style: TextStyle(
                              //               fontSize: 2.2 *
                              //                   SizeConfig
                              //                       .textMultiplier,
                              //               color: Colors.grey[700]),
                              //         ),
                              //         actions: <Widget>[
                              //           TextButton(
                              //             onPressed: () async {
                              //               Navigator.of(ctx).pop();
                              //               aprover(context,
                              //                   aproval: "1",
                              //                   notifyid: widget
                              //                       .data.notificationId
                              //                       .toString());
                              //               widget.callback(ctx);
                              //             },
                              //             child: Text("Aprove"),
                              //           ),
                              //           TextButton(
                              //             onPressed: () {
                              //               Navigator.of(ctx).pop();
                              //             },
                              //             child: Text("Cancel"),
                              //           ),
                              //         ],
                              //       ),
                              //     );
                              //   },
                              //   child: Container(
                              //     // group70qmU (7:818)
                              //     margin: EdgeInsets.fromLTRB(0 * fem,
                              //         0 * fem, 5 * fem, 0.94 * fem),
                              //     width: 13 * fem,
                              //     height: 11.06 * fem,
                              //     child: Image.asset(
                              //       'assets/images/group-70.png',
                              //       width: 13 * fem,
                              //       height: 11.06 * fem,
                              //     ),
                              //   ),
                              // ),
                              // Material(
                              //   child: InkWell(
                              //     onTap: () {
                              //       showDialog(
                              //         context: context,
                              //         builder: (ctx) => AlertDialog(
                              //           title: Text(
                              //             "Aprove Confirmation",
                              //             style: TextStyle(
                              //                 fontSize: 2.5 *
                              //                     SizeConfig
                              //                         .textMultiplier,
                              //                 fontWeight:
                              //                     FontWeight.bold,
                              //                 color: Colors.grey[700]),
                              //           ),
                              //           content: Text(
                              //             "Do you wants to Aprove the Message?",
                              //             style: TextStyle(
                              //                 fontSize: 2.2 *
                              //                     SizeConfig
                              //                         .textMultiplier,
                              //                 color: Colors.grey[700]),
                              //           ),
                              //           actions: <Widget>[
                              //             TextButton(
                              //               onPressed: () async {
                              //                 Navigator.of(ctx).pop();
                              //                 aprover(context,
                              //                     aproval: "1",
                              //                     notifyid: widget.data
                              //                         .notificationId
                              //                         .toString());
                              //                 widget.callback(ctx);
                              //               },
                              //               child: Text("Aprove"),
                              //             ),
                              //             TextButton(
                              //               onPressed: () {
                              //                 Navigator.of(ctx).pop();
                              //               },
                              //               child: Text("Cancel"),
                              //             ),
                              //           ],
                              //         ),
                              //       );
                              //     },
                              //     // onTap: () async {
                              //     //    Navigator.of(ctx).pop();
                              //     //   aprover(context,
                              //     //       aproval: "1",
                              //     //       notifyid: widget.data.notificationId
                              //     //           .toString());
                              //     //           widget.callback(ctx);
                              //     // },
                              //     child: Container(
                              //       // group7676i (7:821)
                              //       padding: EdgeInsets.fromLTRB(
                              //           2 * fem,
                              //           3 * fem,
                              //           1 * fem,
                              //           1 * fem),
                              //       height: double.infinity,
                              //       decoration: BoxDecoration(
                              //         color: const Color(0xff2c5ec0),
                              //         borderRadius:
                              //             BorderRadius.circular(
                              //                 3 * fem),
                              //         boxShadow: [
                              //           BoxShadow(
                              //             color:
                              //                 const Color(0x93000000),
                              //             offset:
                              //                 Offset(-1 * fem, 1 * fem),
                              //             blurRadius: 2 * fem,
                              //           ),
                              //         ],
                              //       ),
                              //       child: Text(
                              //         'Approve',
                              //         style: SafeGoogleFont(
                              //           'Inter',
                              //           fontSize: 10 * ffem,
                              //           fontWeight: FontWeight.w300,
                              //           height:
                              //               0.9152273178 * ffem / fem,
                              //           letterSpacing: 1 * fem,
                              //           color: const Color(0xffffffff),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          //       Container(
                          //         // group73hqc (7:824)
                          //         margin: EdgeInsets.fromLTRB(
                          //             0 * fem, 3 * fem, 6 * fem, 0 * fem),
                          //         width: double.infinity,
                          //         child: Row(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             InkWell(
                          //               onTap: () {
                          //                 showDialog(
                          //                   context: context,
                          //                   builder: (ctx) => AlertDialog(
                          //                     title: Text(
                          //                       "Deny Confirmation",
                          //                       style: TextStyle(
                          //                           fontSize: 2.5 *
                          //                               SizeConfig
                          //                                   .textMultiplier,
                          //                           fontWeight: FontWeight.bold,
                          //                           color: Colors.grey[700]),
                          //                     ),
                          //                     content: Text(
                          //                       "Do you wants to Deny the Message?",
                          //                       style: TextStyle(
                          //                           fontSize: 2.2 *
                          //                               SizeConfig
                          //                                   .textMultiplier,
                          //                           color: Colors.grey[700]),
                          //                     ),
                          //                     actions: <Widget>[
                          //                       TextButton(
                          //                         onPressed: () async {
                          //                           Navigator.of(ctx).pop();
                          //                           denied(context,
                          //                               aproval: "2",
                          //                               notifyid: widget
                          //                                   .data.notificationId
                          //                                   .toString());
                          //                           widget.callback(ctx);
                          //                         },
                          //                         child: Text("Denied"),
                          //                       ),
                          //                       TextButton(
                          //                         onPressed: () {
                          //                           Navigator.of(ctx).pop();
                          //                         },
                          //                         child: Text("Cancel"),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 );
                          //               },
                          //               child: Container(
                          //                 // group71ote (7:828)
                          //                 margin: EdgeInsets.fromLTRB(0 * fem,
                          //                     0 * fem, 8 * fem, 0 * fem),
                          //                 width: 12 * fem,
                          //                 height: 13.28 * fem,
                          //                 child: Image.asset(
                          //                   'assets/images/group-71.png',
                          //                   width: 13.1 * fem,
                          //                   height: 13.28 * fem,
                          //                 ),
                          //               ),
                          //             ),
                          //             // Material(
                          //             //   child: InkWell(
                          //             //     onTap: () {
                          //             //       showDialog(
                          //             //         context: context,
                          //             //         builder: (ctx) => AlertDialog(
                          //             //           title: Text(
                          //             //             "Deny Confirmation",
                          //             //             style: TextStyle(
                          //             //                 fontSize: 2.5 *
                          //             //                     SizeConfig
                          //             //                         .textMultiplier,
                          //             //                 fontWeight:
                          //             //                     FontWeight.bold,
                          //             //                 color: Colors.grey[700]),
                          //             //           ),
                          //             //           content: Text(
                          //             //             "Do you wants to Deny the Message?",
                          //             //             style: TextStyle(
                          //             //                 fontSize: 2.2 *
                          //             //                     SizeConfig
                          //             //                         .textMultiplier,
                          //             //                 color: Colors.grey[700]),
                          //             //           ),
                          //             //           actions: <Widget>[
                          //             //             TextButton(
                          //             //               onPressed: () async {
                          //             //                 Navigator.of(ctx).pop();
                          //             //                 denied(context,
                          //             //                     aproval: "2",
                          //             //                     notifyid: widget.data
                          //             //                         .notificationId
                          //             //                         .toString());
                          //             //                 widget.callback(ctx);
                          //             //               },
                          //             //               child: Text("Denied"),
                          //             //             ),
                          //             //             TextButton(
                          //             //               onPressed: () {
                          //             //                 Navigator.of(ctx).pop();
                          //             //               },
                          //             //               child: Text("Cancel"),
                          //             //             ),
                          //             //           ],
                          //             //         ),
                          //             //       );
                          //             //     },
                          //             //     child: Container(
                          //             //       // group77HYv (7:825)
                          //             //       width: 34 * fem,
                          //             //       height: 16 * fem,
                          //             //       decoration: BoxDecoration(
                          //             //         color: const Color(0xff2c5ec0),
                          //             //         borderRadius:
                          //             //             BorderRadius.circular(
                          //             //                 3 * fem),
                          //             //         boxShadow: [
                          //             //           BoxShadow(
                          //             //             color:
                          //             //                 const Color(0x93000000),
                          //             //             offset:
                          //             //                 Offset(-1 * fem, 1 * fem),
                          //             //             blurRadius: 2 * fem,
                          //             //           ),
                          //             //         ],
                          //             //       ),
                          //             //       child: Center(
                          //             //         child: Text(
                          //             //           'Deny',
                          //             //           style: SafeGoogleFont(
                          //             //             'Inter',
                          //             //             fontSize: 9 * ffem,
                          //             //             fontWeight: FontWeight.w300,
                          //             //             height:
                          //             //                 0.9152273178 * ffem / fem,
                          //             //             letterSpacing: 1 * fem,
                          //             //             color:
                          //             //                 const Color(0xffffffff),
                          //             //           ),
                          //             //         ),
                          //             //       ),
                          //             //     ),
                          //             //   ),
                          //             // ),
                          //           ],
                          //         ),
                          //       ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
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
                                  colors: [
                                    Color(0xff64a78b),
                                    Color(0xff69c767)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.centerRight),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.data.user,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    widget.data.designation.toString(),
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
                        ],
                      ),
                      widget.data.messageCategory == "Quotes"
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: SizedBox(
                                width: 120,
                                height: 32,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/rectangle-7-oyU.png',
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Quote",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      widget.data.messageCategory == "ManagementSpeaks"
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: SizedBox(
                                width: 120,
                                height: 32,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/rectangle-7-oyU.png',
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "ManagementSpeaks",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      widget.data.messageCategory == "Document"
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: SizedBox(
                                width: 120,
                                height: 32,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/rectangle-7-oyU.png',
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Document",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
////////////////////////////////
                      ///////////////////////////////////////////
                      Row(
                        children: [
                          ApproveDenyWidget(
                            user: widget.role,
                            data: widget.data,
                            callback: widget.callback,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onLongPress: () {
                              HapticFeedback.vibrate();
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            ///////////////////////////////////////////////
                            child: widget.data.messageCategory == "Text"
                                ? ChatBubble(
                                    clipper: ChatBubbleClipper10(
                                        type: BubbleType.sendBubble),
                                    backGroundColor: const Color(0xffE7E7ED),
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(bottom: 3),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
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
                                  )
                                : widget.data.messageCategory == "Images" ||
                                        widget.data.messageCategory ==
                                            "ImageWithCaption"
                                    ? GestureDetector(
                                        onLongPress: () {
                                          setState(() {
                                            isVisible = !isVisible;
                                          });
                                        },
                                        child: ChatBubble(
                                          clipper: ChatBubbleClipper10(
                                              type: BubbleType.sendBubble),
                                          backGroundColor:
                                              const Color(0xffE7E7ED),
                                          alignment: Alignment.topRight,
                                          margin:
                                              const EdgeInsets.only(bottom: 3),
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: widget.data.images!
                                                              .length ==
                                                          1
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            // Navigator.push(
                                                            //     context,
                                                            //     MaterialPageRoute(
                                                            //         builder:
                                                            //             (_) {
                                                            //   return DetailScreen(
                                                            //       images: widget
                                                            //           .data
                                                            //           .images!
                                                            //           .toList());
                                                            // }));
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    fit: BoxFit.cover,
                                                                    image: NetworkImage(widget.data.images![0].contains("https://")
                                                                        ? widget.data.images![0]
                                                                        : widget.data.images![0].contains("http://")
                                                                            ? widget.data.images![0]
                                                                            //data.images.toString()
                                                                            : "http://${widget.data.images![0]}")),
                                                                borderRadius: BorderRadius.circular(7)),
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          height: 200,
                                                          child:
                                                              GridView.builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis
                                                                          .horizontal,
                                                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                                      maxCrossAxisExtent:
                                                                          200,
                                                                      childAspectRatio:
                                                                          1.4,
                                                                      crossAxisSpacing:
                                                                          5,
                                                                      mainAxisSpacing:
                                                                          5),
                                                                  itemCount: widget
                                                                      .data
                                                                      .images!
                                                                      .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              ctx,
                                                                          index) {
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        // Navigator.push(context,
                                                                        //     MaterialPageRoute(builder: (_) {
                                                                        //   return DetailScreen(images: widget.data.images!.toList());
                                                                        // }));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            image: DecorationImage(
                                                                                fit: BoxFit.cover,
                                                                                image: NetworkImage(widget.data.images![index].contains("https://")
                                                                                    ? widget.data.images![index]
                                                                                    : widget.data.images![index].contains("http://")
                                                                                        ? widget.data.images![index]
                                                                                        //data.images.toString()
                                                                                        : "http://${widget.data.images![index]}")),
                                                                            borderRadius: BorderRadius.circular(7)),
                                                                      ),
                                                                    );
                                                                  }),
                                                        ),
                                                ),
                                                widget.data.caption != null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Text(
                                                          widget.data.caption ??
                                                              '',
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : widget.data.messageCategory == "Quotes"
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 5,
                                                bottom: 0),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.blue),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(15),
                                                      bottomLeft:
                                                          Radius.circular(15),
                                                      bottomRight:
                                                          Radius.circular(15),
                                                    )),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(
                                                      widget.data.message
                                                          .toString(),
                                                      //  " \" He who has plans correctly and puts consistence efforts will always win!\" -- Anonymous  ",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: SafeGoogleFont(
                                                        'Inter',
                                                        fontSize: 16 * ffem,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height:
                                                            1.2125 * ffem / fem,
                                                        color: Colors.black,
                                                      ),
                                                    ))),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 5,
                                                bottom: 0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.green),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(15),
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                    bottomRight:
                                                        Radius.circular(15),
                                                  )),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.green
                                                                      .shade400,
                                                              child: const Icon(
                                                                Icons
                                                                    .play_arrow,
                                                                color: Colors
                                                                    .white,
                                                                size: 38,
                                                              )),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Image.network(
                                                            "https://cdn-icons-png.flaticon.com/512/6622/6622004.png",
                                                            height: 50,
                                                            color: Colors
                                                                .green.shade400,
                                                          ),
                                                          Image.network(
                                                            "https://cdn-icons-png.flaticon.com/512/6622/6622004.png",
                                                            height: 50,
                                                            color: Colors
                                                                .green.shade400,
                                                          ),
                                                          Image.network(
                                                            "https://cdn-icons-png.flaticon.com/512/6622/6622004.png",
                                                            height: 50,
                                                            color: Colors
                                                                .green.shade400,
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        height: 1,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .shortestSide,
                                                        color: Colors.grey,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: const [
                                                          Icon(
                                                            Icons.hearing,
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            "Linstned: 35",
                                                            style: TextStyle(
                                                                fontSize: 11),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                          )
                        ],
                      ),
                      VisibilityWidget(
                          role: widget.role,
                          visible: widget.data.visibility.toString()),
                    ],
                  ),
                  Visibility(
                      visible: isVisible,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1000),
                        reverseDuration: const Duration(milliseconds: 500),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await getInfo(
                                        widget.id,
                                        widget.data.notificationId.toString(),
                                        widget.data.communicationType
                                            .toString())
                                    .then((value) {
                                  setState(() {
                                    infomessage = value;
                                  });
                                  ShowDialog(context, infomessage);
                                });
                              },
                              child: Image.network(
                                "https://cdn-icons-png.flaticon.com/512/3719/3719420.png",
                                width: 20,
                                height: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(
                                      "Delete Confirmation",
                                      style: TextStyle(
                                          fontSize:
                                              2.5 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700]),
                                    ),
                                    content: Text(
                                      "Do you wants to Delete the Message?",
                                      style: TextStyle(
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier,
                                          color: Colors.grey[700]),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(ctx).pop();
                                          await deleteNotify(
                                              grpid: widget.id,
                                              notifyid: widget
                                                  .data.notificationId
                                                  .toString(),
                                              context);
                                          widget.callback(ctx);
                                        },
                                        child: const Text("Yes"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text("No"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Image.network(
                                "https://cdn-icons-png.flaticon.com/128/5028/5028066.png",
                                width: 20,
                                height: 20,
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
  }
}

showDialogFunc(context, String img, String text) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Center(
                          child: Column(
                        children: [
                          Image(
                              image: NetworkImage(img),
                              fit: BoxFit.cover,
                              width: 1000.0),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            text,
                            textAlign: TextAlign.center,
                          )
                        ],
                      )),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 242,
                bottom: 230,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.cancel_outlined,
                        color: Colors.black,
                      ),
                    )),
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<void> deleteNotify(BuildContext context,
    {required String grpid, required String notifyid}) async {
  // _showLoader(context);
  await deleteNotification(grpid: grpid, notifyid: notifyid).then((value) {
    if (value["success"] == "Deleted Successfully!...") {
      // Navigator.of(context).pop();
      Utility.displaySnackBar(context, "Message Deleted");
      //     Navigator.push(
      // context,
      // MaterialPageRoute(
      //     builder: (context) => MainGroup(groups: null, name: '',
      //        )));
    } else {
      // Utility.displaySnackBar(
      //     context, "Message not Deleted");
      Navigator.of(context).pop();
      print("not delete");
    }
  });
}

Future<void> approver(BuildContext context,
    {required String notifyid, required String approval}) async {
  await aproveDeny(aproval: approval, notifyid: notifyid.toString())
      .then((value) {
    if (value != null) {
      Utility.displaySnackBar(context, value['message']);
    } else {
      Utility.displaySnackBar(context, value['message']);
      //  initState();
    }
  });
}

Future<void> denied(BuildContext context,
    {required String notifyid, required String approval}) async {
  await aproveDeny(aproval: approval, notifyid: notifyid.toString())
      .then((value) {
    if (value != null) {
      Utility.displaySnackBar(context, "Message Denied Successfully");
    } else {
      Utility.displaySnackBar(context, "Error Denying");
    }
  });
}

showMultiDialogFunc(
  context,
  List img,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                // padding: const EdgeInsets.all(15),
                child: Container(
                  // decoration: BoxDecoration(
                  //     color: Colors.blue.shade50,
                  //     borderRadius: BorderRadius.circular(10),
                  //     image: DecorationImage(
                  //       colorFilter: ColorFilter.mode(
                  //           Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                  //       image: const NetworkImage(
                  //           Images.bgImage),
                  //       fit: BoxFit.fill,
                  //     )),
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Center(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            CarouselSlider.builder(
                              itemCount: img.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  Image(
                                image: NetworkImage(
                                    img[itemIndex].contains("https://")
                                        ? img[itemIndex]
                                        : img[itemIndex].contains("http://")
                                            ? img[itemIndex]
                                            //data.images.toString()
                                            : "http://${img[itemIndex]}"),
                                height: 300,
                              ),
                              options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                                pauseAutoPlayOnTouch: true,
                              ),
                            )
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   left: 262,
              //   bottom: 190,
              //   child: IconButton(
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //       icon: const CircleAvatar(
              //         radius: 12,
              //         backgroundColor: Colors.white,
              //         child: Icon(
              //           Icons.cancel_outlined,
              //           color: Colors.black,
              //         ),
              //       )),
              // )
            ],
          ),
        ),
      );
    },
  );
}

ShowDialog(
  contex,
  Info? infomessage,
) {
  return showDialog(
      context: (contex),
      builder: ((context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.41,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 179, 204, 245),
                        border: Border.all(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.blueAccent.shade400,
                                      Colors.blueAccent.shade100,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.centerRight)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                  "https://cdn-icons-png.flaticon.com/512/1665/1665646.png",
                                  width: 30,
                                  height: 30,
                                  color: Colors.white,
                                ),
                                const Text(
                                  "Message Info",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                      letterSpacing: 2),
                                ),
                                Image.network(
                                    "https://cdn-icons-png.flaticon.com/512/3972/3972676.png",
                                    color: Colors.white,
                                    width: 40,
                                    height: 40)
                              ],
                            ),
                          ),
                          Table(
                            border: TableBorder.all(
                              color: Colors.brown.shade400,
                              //style: BorderStyle.solid,
                              width: 0.2,
                            ),
                            children: [
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Initiated by",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infomessage!.messageInfo.initiatedBy,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              /////////////////////2
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Initiated user Category",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infomessage
                                        .messageInfo.initiatedUserCategory,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Initiated on",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    Utility.convertDateFormat(
                                        infomessage.messageInfo.initiatedOn
                                            .toString(),
                                        "dd/MM/yyyy"),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Approved by",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infomessage.messageInfo.approvedBy,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Approver user Category",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infomessage
                                        .messageInfo.approverUserCategory,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Designation",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infomessage.messageInfo.area,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Approved on",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    Utility.convertDateFormat(
                                        infomessage.messageInfo.approvedAt
                                            .toString(),
                                        "dd/MM/yyyy"),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Deleted by",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infomessage.messageInfo.deletedBy,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Deleted on",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    Utility.convertDateFormat(
                                        infomessage.messageInfo.deletedOn
                                            .toString(),
                                        "dd/MM/yyyy"),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(13.0),
                            child: Text(
                              "Waiting for approval",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.87,
                  bottom: MediaQuery.of(context).size.height * 0.65,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ),
        );
      }));
}

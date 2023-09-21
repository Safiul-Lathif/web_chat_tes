// import 'dart:async';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:intl/intl.dart';
// import 'package:swipe_to/swipe_to.dart';
// import 'package:ui/api/message_read_api.dart';
// import 'package:ui/api/message_view_api.dart';
// import 'package:ui/card/QuotesCard.dart';
// import 'package:ui/card/approved_card.dart';
// import 'package:ui/card/document_card.dart';
// import 'package:ui/card/first_card.dart';
// import 'package:ui/card/parents_reply_card.dart';
// import 'package:ui/card/third_card.dart';
// import 'package:ui/card/video_card.dart';
// import 'package:ui/custom/deleted_widget.dart';
// import 'package:ui/model/message_view_model.dart';
// import 'package:ui/utils/utility.dart';
// import '../card/AudioCard.dart';
// import '../card/circular_card.dart';
// import '../card/home_work.dart';
// import '../card/management_speaks.dart';
// import '../card/material_card.dart';

// // ignore: must_be_immutable
// class ChatFeed extends StatefulWidget {
//   const ChatFeed({
//     super.key,
//     // required this.focusNode,
//     required this.role,
//     required this.id,
//     required this.classId,
//     // required this.sibling,
//   });
//   //final String? title;
//   // final FocusNode focusNode;
//   final String role;
//   final String classId;
//   final String id;
//   // final int sibling;

//   @override
//   State<ChatFeed> createState() => _ChatFeedState();
// }

// class _ChatFeedState extends State<ChatFeed> {
//   String nextUrl = "";
//   bool hasConnection = false;
//   bool isLoading = false;
//   MessageView? msgView;
//   int totalRecord = 0;
//   // MessageReadinfo? readInfo;

//   ScrollController scrollController = ScrollController();
//   final chatScrollController = ScrollController();

//   Timer? timer;

//   var colorizeColors = [
//     Colors.purple,
//     Colors.blue,
//     Colors.yellow,
//     Colors.red,
//   ];

//   var colorizeTextStyle = GoogleFonts.acme(
//     fontSize: 27,
//   );

//   @override
//   void initState() {
//     super.initState();
//     initialize();
//     initTimer();
//   }

//   void initialize() async {
//     bool result = await Utility.checkInternet();
//     setState(() {
//       hasConnection = result;
//     });
//     if (hasConnection) {
//       await getChatData(id: widget.id);
//       var notificationId = msgView!.message.last.notificationId;
//       getNotifidata(notificationId);
//       WidgetsBinding.instance.addPostFrameCallback((Duration _) {
//         if (scrollController.hasClients) {
//           scrollController.animateTo(
//             scrollController.position.maxScrollExtent,
//             curve: Curves.easeOut,
//             duration: const Duration(seconds: 1),
//           );
//           setState(() {
//             scrollController = chatScrollController;
//           });
//         }
//       });
//     }
//   }

//   msg(BuildContext ctx) async {
//     await getChatData(id: widget.id);
//   }

// // widget.callback(ctx);

//   void initTimer() {
//     const dur = Duration(seconds: 5);
//     if (timer != null && timer!.isActive) return;
//     timer = Timer.periodic(dur, (Timer timer) async {
//       await getChatData(id: widget.id);
//     });
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return msgView == null
//         ? Padding(
//             padding: const EdgeInsets.only(top: 300.0),
//             child: AnimatedTextKit(repeatForever: true, animatedTexts: [
//               ColorizeAnimatedText(
//                 "Loading ...",
//                 textStyle: colorizeTextStyle,
//                 colors: colorizeColors,
//               ),
//             ]),
//           )
//         : Stack(
//             children: [
//               MediaQuery.removePadding(
//                 context: context,
//                 removeTop: true,
//                 child: GroupedListView<Message, String>(
//                     physics: const BouncingScrollPhysics(),
//                     reverse: true,
//                     order: GroupedListOrder.DESC,
//                     elements: msgView!.message,
//                     groupBy: (element) => DateTime(element.dateTime.year,
//                             element.dateTime.month, element.dateTime.day)
//                         .toString(),
//                     useStickyGroupSeparators: true,
//                     floatingHeader: true,
//                     groupHeaderBuilder: (element) => SizedBox(
//                           height: 40,
//                           child: Center(
//                             child: Card(
//                               color: Colors.grey.shade500,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   DateFormat.yMMMd().format(element.dateTime) ==
//                                           DateFormat.yMMMd()
//                                               .format(DateTime.now())
//                                       ? 'Today'
//                                       : DateFormat.yMMMd()
//                                           .format(element.dateTime),
//                                   style: const TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                     itemBuilder: (BuildContext context, Message message) {
//                       if (message.messageCategory == 'Text') {
//                         if (message.messageStatus == 1 ||
//                             message.approvalStatus == 2) {
//                           return DeletedWidget(
//                             redCount: message.readCount,
//                             data: message,
//                             itemIndex: 0,
//                             id: widget.id,
//                             notiid: message.notificationId,
//                             callback: msg,
//                             role: widget.role,
//                             type: message.viewType,
//                             messageCategory: message.messageCategory,
//                           );
//                         } else if (message.approvalStatus == 0) {
//                           //approve,deny,info,delete
//                           return SwipeTo(
//                             onRightSwipe: () {
//                               setState(() {
//                                 //  widget.focusNode.requestFocus();
//                                 HapticFeedback.vibrate();
//                               });
//                             },
//                             child: ParentsReplyCard(
//                               type: message.viewType,
//                               callback: msg,
//                               // node: widget.focusNode,
//                               id: widget.id,
//                               //  role: widget.role,
//                               data: message,
//                               itemIndex: 0, role: widget.role,
//                             ),
//                           );
//                         } else {
//                           return SwipeTo(
//                             onLeftSwipe: () {
//                               setState(() {
//                                 //  widget.focusNode.requestFocus();
//                                 HapticFeedback.vibrate();
//                               });
//                             },
//                             child: FirstCard(
//                               redCount: message.readCount,
//                               type: message.viewType,
//                               role: widget.role,
//                               callback: msg,
//                               notiid: message.notificationId,
//                               usr_Name: msgView!.userDetails.name,
//                               data: message,
//                               itemIndex: 0,
//                               id: widget.id,
//                             ),
//                           );
//                         }
//                       }

//                       ////_______IMAGE_________////
//                       else if (message.messageCategory == "Images" ||
//                           message.messageCategory == "ImageWithCaption") {
//                         if (message.messageStatus == 1 ||
//                             message.approvalStatus == 2) {
//                           return DeletedWidget(
//                             redCount: message.readCount,
//                             data: message,
//                             itemIndex: 0,
//                             id: widget.id,
//                             notiid: message.notificationId,
//                             callback: msg,
//                             role: widget.role,
//                             type: message.viewType,
//                             messageCategory: message.messageCategory,
//                           );
//                         } else if (message.approvalStatus == 0) {
//                           //approve,deny,info,delete
//                           return SwipeTo(
//                             onRightSwipe: () {
//                               setState(() {
//                                 //  widget.focusNode.requestFocus();
//                                 HapticFeedback.vibrate();
//                               });
//                             },
//                             child: ParentsReplyCard(
//                                 role: widget.role,
//                                 type: message.viewType,
//                                 callback: msg,
//                                 // node: widget.focusNode,
//                                 id: widget.id,
//                                 //  role: widget.role,
//                                 data: message,
//                                 itemIndex: 0),
//                           );
//                         } else {
//                           return ThirdCard(
//                             redCount: message.readCount,
//                             type: message.viewType,
//                             role: widget.role,
//                             callback: msg,
//                             usr_Name: msgView!.userDetails.name,
//                             data: message,
//                             itemIndex: 0,
//                             notiid: message.notificationId,
//                             id: widget.id,
//                           );
//                         }
//                       }

//                       ///__________AUDIO__________////
//                       else if (message.messageCategory == "Audio") {
//                         if (message.messageStatus == 1 ||
//                             message.approvalStatus == 2) {
//                           return DeletedWidget(
//                             redCount: message.readCount,
//                             data: message,
//                             itemIndex: 0,
//                             id: widget.id,
//                             notiid: message.notificationId,
//                             callback: msg,
//                             role: widget.role,
//                             type: message.viewType,
//                             messageCategory: message.messageCategory,
//                           );
//                         } else {
//                           return AudioCard(
//                             watchCount: message.watched,
//                             redCount: message.readCount,
//                             type: message.viewType,
//                             role: widget.role,
//                             callback: msg,
//                             usr_Name: msgView!.userDetails.name,
//                             data: message,
//                             itemIndex: 0,
//                             notiid: message.notificationId,
//                             id: widget.id,
//                           );
//                         }
//                       } else if (message.messageCategory == "Quotes") {
//                         if (message.messageStatus == 1 ||
//                             message.approvalStatus == 2) {
//                           return DeletedWidget(
//                             redCount: message.readCount,
//                             data: message,
//                             itemIndex: 0,
//                             id: widget.id,
//                             notiid: message.notificationId,
//                             callback: msg,
//                             role: widget.role,
//                             type: message.viewType,
//                             messageCategory: message.messageCategory,
//                           );
//                         } else if (message.approvalStatus == 0) {
//                           //approve,deny,info,delete
//                           return SwipeTo(
//                             onRightSwipe: () {
//                               setState(() {
//                                 //  widget.focusNode.requestFocus();
//                                 HapticFeedback.vibrate();
//                               });
//                             },
//                             child: ParentsReplyCard(
//                                 role: widget.role,
//                                 type: message.viewType,
//                                 callback: msg,
//                                 // node: widget.focusNode,
//                                 id: widget.id,
//                                 //  role: widget.role,
//                                 data: message,
//                                 itemIndex: 0),
//                           );
//                         } else {
//                           return QuoteCard(
//                             redCount: message.readCount,
//                             type: message.viewType,
//                             role: widget.role,
//                             callback: msg,
//                             usr_Name: msgView!.userDetails.name,
//                             data: message,
//                             itemIndex: 0,
//                             notiid: message.notificationId,
//                             id: widget.id,
//                           );
//                         }
//                       } else if (message.messageCategory == 'approvedCard' &&
//                           message.approvalStatus == 1) {
//                         return ParentsApproved(
//                           redCount: message.readCount,
//                           type: message.viewType,
//                           role: widget.role,
//                           usr_Name: msgView!.userDetails.name,
//                           callback: msg,
//                           data: message,
//                           itemIndex: 0,
//                           notiid: message.notificationId,
//                           id: widget.id,
//                         );
//                       } else if (message.messageCategory == "Document") {
//                         return DocumentCard(
//                           watchCount: message.watched,
//                           redCount: message.readCount,
//                           type: message.viewType,
//                           role: widget.role,
//                           callback: msg,
//                           data: message,
//                           itemIndex: 0,
//                           notiid: message.notificationId,
//                           id: widget.id,
//                         );
//                       } else if (message.messageCategory == "StudyMaterial") {
//                         return MaterialCard(
//                           watchCount: message.watched,
//                           redCount: message.readCount,
//                           type: message.viewType,
//                           role: widget.role,
//                           callback: msg,
//                           data: message,
//                           itemIndex: 0,
//                           notiid: message.notificationId,
//                           id: widget.id,
//                         );
//                       } else if (message.messageCategory ==
//                           "ManagementSpeaks") {
//                         return ManagementSpeaks(
//                           redCount: message.readCount,
//                           type: message.viewType,
//                           role: widget.role,
//                           callback: msg,
//                           data: message,
//                           itemIndex: 0,
//                           notiid: message.notificationId,
//                           id: widget.id,
//                         );
//                       } else if (message.messageCategory == "Circular") {
//                         return CircularCard(
//                           redCount: message.readCount,
//                           type: message.viewType,
//                           role: widget.role,
//                           callback: msg,
//                           data: message,
//                           itemIndex: 0,
//                           notiid: message.notificationId,
//                           id: widget.id,
//                         );
//                       } else if (message.messageCategory == "Video") {
//                         return VideoCard(
//                           watchCount: message.watched,
//                           redCount: message.readCount,
//                           type: message.viewType,
//                           role: widget.role,
//                           callback: msg,
//                           data: message,
//                           itemIndex: 0,
//                           notiid: message.notificationId,
//                           id: widget.id,
//                         );
//                       } else if (message.messageCategory == "Homework") {
//                         return HomeWorkCard(
//                           // sibling: widget.sibling,
//                           watchCount: message.watched,
//                           // completeCount: widget.completeCount,
//                           redCount: message.readCount,
//                           clsId: widget.classId,
//                           type: message.viewType,
//                           role: widget.role,
//                           callback: msg,
//                           data: message,
//                           itemIndex: 0,
//                           notiid: message.notificationId,
//                           id: widget.id,
//                           usr_Name: '', parentCount: '',
//                         );
//                       } else {
//                         return Text(message.messageCategory);
//                       }
//                     }),
//               ),
//             ],
//           );
//   }

//   Future<void> getChatData({required String id}) async {
//     await getMsgFeed(id).then((value) {
//       if (value != null) {
//         if (mounted) {
//           setState(() {
//             msgView = value;
//           });
//         }
//       }
//     });
//   }

//   void getNotifidata(int notifiId) async {
//     await messageRead(msgStatus: '2', notifyid: notifiId.toString())
//         .then((value) {
//       // setState(() {
//       //   readInfo = value;
//       // });
//     });
//   }
// }
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:ui/card/QuotesCard.dart';
import 'package:ui/card/approved_card.dart';
import 'package:ui/card/birthday_card.dart';
import 'package:ui/card/circular_card.dart';
import 'package:ui/card/document_card.dart';
import 'package:ui/card/events_card.dart';
import 'package:ui/card/first_card.dart';
import 'package:ui/card/home_work.dart';
import 'package:ui/card/management_speaks.dart';
import 'package:ui/card/material_card.dart';
import 'package:ui/card/news_card.dart';
import 'package:ui/card/parents_reply_card.dart';
import 'package:ui/card/third_card.dart';
import 'package:ui/card/video_card.dart';
import 'package:ui/custom/deleted_widget.dart';
import 'package:ui/model/message_view_model.dart';

import '../Utils/Utility.dart';
import '../api/messageviewAPI.dart';
import '../api/msg_read_api.dart';

class NewsFeedInfo extends StatefulWidget {
  const NewsFeedInfo({
    super.key,
    required this.role,
    required this.id,
    required this.classId,
  });
  final String role;
  final String classId;
  final String id;

  @override
  State<NewsFeedInfo> createState() => _NewsFeedInfoState();
}

class _NewsFeedInfoState extends State<NewsFeedInfo> {
  String nextUrl = "";
  bool hasConnection = false;
  bool isLoading = true;
  MessageView? msgView;
  int totalRecord = 0;

  ScrollController scrollController = ScrollController();
  final chatScrollController = ScrollController();

  Timer? timer;

  var colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  var colorizeTextStyle = GoogleFonts.acme(
    fontSize: 27,
  );

  @override
  void initState() {
    super.initState();
    initialize();
    initTimer();
  }

  void initialize() async {
    bool result = await Utility.checkInternet();
    setState(() {
      hasConnection = result;
    });
    if (hasConnection) {
      await getChatData(id: widget.id);
      var notificationId = msgView!.message.last.notificationId.toString();
      var communicationType =
          msgView!.message.last.communicationType.toString();
      getNotificationData(notificationId, communicationType);
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(seconds: 1),
          );
          setState(() {
            scrollController = chatScrollController;
          });
        }
      });
    }
  }

  msg(BuildContext ctx) async {
    await getChatData(id: widget.id);
  }

  void initTimer() {
    const dur = Duration(seconds: 5);
    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(dur, (Timer timer) async {
      await getChatData(id: widget.id);
    });
  }

  Future<void> getChatData({required String id}) async {
    await getMsgFeed(id).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            msgView = value;
          });
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.only(top: 300.0),
            child: AnimatedTextKit(repeatForever: true, animatedTexts: [
              ColorizeAnimatedText(
                "Loading ...",
                textStyle: colorizeTextStyle,
                colors: colorizeColors,
              ),
            ]),
          )
        : Stack(
            children: [
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GroupedListView<Message, String>(
                    reverse: true,
                    order: GroupedListOrder.DESC,
                    elements: msgView!.message.where((element) {
                      return true;
                    }).toList(),
                    groupBy: (element) => DateTime(
                          element.dateTime.year,
                          element.dateTime.month,
                          element.dateTime.day,
                        ).toString(),
                    useStickyGroupSeparators: true,
                    floatingHeader: true,
                    itemComparator: (element1, element2) =>
                        element1.dateTime.compareTo(element2.dateTime),
                    groupHeaderBuilder: (element) => SizedBox(
                          height: 40,
                          child: Center(
                            child: Card(
                              color: Colors.grey.shade600,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  DateFormat.yMMMd().format(element.dateTime) ==
                                          DateFormat.yMMMd()
                                              .format(DateTime.now())
                                      ? 'Today'
                                      : DateFormat.yMMMd()
                                          .format(element.dateTime),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                    itemBuilder: (BuildContext context, Message message) {
                      if (message.messageCategory == 'Text' &&
                          message.communicationType != 4) {
                        if (message.messageStatus == 1 ||
                            message.approvalStatus == 2) {
                          return DeletedWidget(
                            redCount: message.readCount,
                            data: message,
                            itemIndex: 0,
                            id: widget.id,
                            notiid: message.notificationId,
                            callback: msg,
                            role: widget.role,
                            type: message.viewType,
                            messageCategory: message.messageCategory,
                          );
                        } else if (message.approvalStatus == 0) {
                          return SwipeTo(
                            onRightSwipe: () {
                              setState(() {
                                HapticFeedback.vibrate();
                              });
                            },
                            child: ParentsReplyCard(
                              type: message.viewType,
                              callback: msg,
                              id: widget.id,
                              data: message,
                              itemIndex: 0,
                              role: widget.role,
                            ),
                          );
                        } else {
                          return SwipeTo(
                            onLeftSwipe: () {
                              setState(() {
                                HapticFeedback.vibrate();
                              });
                            },
                            child: FirstCard(
                              redCount: message.readCount,
                              type: message.viewType,
                              role: widget.role,
                              callback: msg,
                              notiid: message.notificationId,
                              usr_Name: msgView!.userDetails.name,
                              data: message,
                              itemIndex: 0,
                              id: widget.id,
                            ),
                          );
                        }
                      }

                      ////_______IMAGE_________////
                      else if (message.messageCategory == "Images" ||
                          message.messageCategory == "ImageWithCaption") {
                        if (message.messageStatus == 1 ||
                            message.approvalStatus == 2) {
                          return DeletedWidget(
                            redCount: message.readCount,
                            data: message,
                            itemIndex: 0,
                            id: widget.id,
                            notiid: message.notificationId,
                            callback: msg,
                            role: widget.role,
                            type: message.viewType,
                            messageCategory: message.messageCategory,
                          );
                        } else if (message.approvalStatus == 0) {
                          return SwipeTo(
                            onRightSwipe: () {
                              setState(() {
                                HapticFeedback.vibrate();
                              });
                            },
                            child: ParentsReplyCard(
                                role: widget.role,
                                type: message.viewType,
                                callback: msg,
                                id: widget.id,
                                data: message,
                                itemIndex: 0),
                          );
                        } else {
                          return ThirdCard(
                            redCount: message.readCount,
                            type: message.viewType,
                            role: widget.role,
                            callback: msg,
                            usr_Name: msgView!.userDetails.name,
                            data: message,
                            itemIndex: 0,
                            notiid: message.notificationId,
                            id: widget.id,
                          );
                        }
                      } else if (message.messageCategory == "Quotes") {
                        if (message.messageStatus == 1 ||
                            message.approvalStatus == 2) {
                          return DeletedWidget(
                            redCount: message.readCount,
                            data: message,
                            itemIndex: 0,
                            id: widget.id,
                            notiid: message.notificationId,
                            callback: msg,
                            role: widget.role,
                            type: message.viewType,
                            messageCategory: message.messageCategory,
                          );
                        } else if (message.approvalStatus == 0) {
                          return SwipeTo(
                            onRightSwipe: () {
                              setState(() {
                                HapticFeedback.vibrate();
                              });
                            },
                            child: ParentsReplyCard(
                                role: widget.role,
                                type: message.viewType,
                                callback: msg,
                                id: widget.id,
                                data: message,
                                itemIndex: 0),
                          );
                        } else {
                          return QuoteCard(
                            redCount: message.readCount,
                            type: message.viewType,
                            role: widget.role,
                            callback: msg,
                            usr_Name: msgView!.userDetails.name,
                            data: message,
                            itemIndex: 0,
                            notiid: message.notificationId,
                            id: widget.id,
                          );
                        }
                      } else if (message.messageCategory == 'approvedCard' &&
                          message.approvalStatus == 1) {
                        return ParentsApproved(
                          redCount: message.readCount,
                          type: message.viewType,
                          role: widget.role,
                          usr_Name: msgView!.userDetails.name,
                          callback: msg,
                          data: message,
                          itemIndex: 0,
                          notiid: message.notificationId,
                          id: widget.id,
                        );
                      } else if (message.messageCategory == "Document") {
                        return DocumentCard(
                          watchCount: message.watched,
                          redCount: message.readCount,
                          type: message.viewType,
                          role: widget.role,
                          callback: msg,
                          data: message,
                          itemIndex: 0,
                          notiid: message.notificationId,
                          id: widget.id,
                        );
                      } else if (message.messageCategory == "StudyMaterial") {
                        return MaterialCard(
                          watchCount: message.watched,
                          redCount: message.readCount,
                          type: message.viewType,
                          role: widget.role,
                          callback: msg,
                          data: message,
                          itemIndex: 0,
                          notiid: message.notificationId,
                          id: widget.id,
                        );
                      } else if (message.messageCategory ==
                          "ManagementSpeaks") {
                        return ManagementSpeaks(
                          redCount: message.readCount,
                          type: message.viewType,
                          role: widget.role,
                          callback: msg,
                          data: message,
                          itemIndex: 0,
                          notiid: message.notificationId,
                          id: widget.id,
                        );
                      } else if (message.messageCategory == "Circular") {
                        return CircularCard(
                          redCount: message.readCount,
                          type: message.viewType,
                          role: widget.role,
                          callback: msg,
                          data: message,
                          itemIndex: 0,
                          notiid: message.notificationId,
                          id: widget.id,
                        );
                      } else if (message.messageCategory == "Video") {
                        return VideoCard(
                          watchCount: message.watched,
                          redCount: message.readCount,
                          type: message.viewType,
                          role: widget.role,
                          callback: msg,
                          data: message,
                          itemIndex: 0,
                          notiid: message.notificationId,
                          id: widget.id,
                        );
                      } else if (message.messageCategory == "Homework") {
                        return HomeWorkCard(
                          watchCount: message.watched,
                          redCount: message.readCount,
                          clsId: widget.classId,
                          type: message.viewType,
                          role: widget.role,
                          callback: msg,
                          data: message,
                          itemIndex: 0,
                          notiid: message.notificationId,
                          id: widget.id,
                          usr_Name: '',
                          parentCount: '',
                        );
                      } else if (message.messageCategory == 'News & Events' &&
                          message.moduleType == 1) {
                        return NewsCards(
                          redCount: message.readCount,
                          type: message.viewType,
                          role: widget.role,
                          callback: msg,
                          data: message,
                          itemIndex: 0,
                          notiid: message.notificationId,
                          id: widget.id,
                        );
                      } else if (message.messageCategory == 'News & Events' &&
                          message.moduleType == 2) {
                        return EventsCard(
                          redCount: message.readCount,
                          type: message.viewType,
                          role: widget.role,
                          callback: msg,
                          data: message,
                          itemIndex: 0,
                          notiid: message.notificationId,
                          id: widget.id,
                        );
                      } else if (message.communicationType == 4) {
                        return BirthdayCard(
                          redCount: message.readCount,
                          type: message.viewType,
                          role: widget.role,
                          callback: msg,
                          data: message,
                          itemIndex: 0,
                          notiid: message.notificationId,
                          id: widget.id,
                        );
                      } else {
                        return Text(message.messageCategory);
                      }
                    }),
              ),
            ],
          );
  }

  void getNotificationData(
      String notificationId, String communicationType) async {
    await messageRead(
      msgStatus: '2',
      notifyid: notificationId,
    ).then((value) {});
  }
}

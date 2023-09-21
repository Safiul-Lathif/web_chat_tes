// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:ui/api/delete_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/deleted_widget.dart';
import 'package:ui/custom/info_delete.dart';
import 'package:ui/custom/time_widget.dart';
import 'package:ui/custom/visibility_widget.dart';
import 'package:ui/model/home_work_parent_model.dart';
import 'package:ui/model/info_model.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/utils/utility.dart';

class HomeWorkCard extends StatefulWidget {
  const HomeWorkCard({
    super.key,
    required this.data,
    required this.itemIndex,
    required this.id,
    required this.notiid,
    // ignore: non_constant_identifier_names
    required this.usr_Name,
    required this.callback,
    required this.role,
    required this.type,
    required this.clsId,
    required this.redCount,
    required this.parentCount,
    required this.watchCount,
  });
//  final int completeCount;
  final Message data;
  final int itemIndex;
  final String id;
  final int notiid;
  // ignore: non_constant_identifier_names
  final String usr_Name;
  final Function callback;
  final String role;
  final int type;
  final String clsId;
  final int redCount;
  final int watchCount;
  final String parentCount;

  @override
  State<HomeWorkCard> createState() => _HomeWorkCardState();
}

class _HomeWorkCardState extends State<HomeWorkCard> {
  bool isVisible = false;
  Info? infomessage;
  List<HomeworkParent>? homeParent;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
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
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        Chat.homeWorkIcon,
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
                                Colors.orange.shade300,
                                Colors.deepOrange
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.centerRight),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: const [
                              Text(
                                'Home Work ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                          onTap: () async {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => HomeWorkScreen(
                            //         classId: widget.clsId,
                            //         role: widget.role,
                            //         isHomeWork: true,
                            //         selectedDate: widget.data.dateTime,
                            //       ),
                            //     ));
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
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.15,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    Images.homeWork,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Subject : ",
                                        style: TextStyle(
                                            color: Colors.brown,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.data.subjectName,
                                        style: const TextStyle(
                                            color: Colors.brown),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "H/W Date : ",
                                        style: TextStyle(
                                            color: Colors.brown,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.data.designation.replaceAll(
                                            'Home Work of the day', ''),
                                        style: const TextStyle(
                                            color: Colors.brown),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                      TimeWidget(
                        redCount: widget.redCount,
                        communicationType:
                            widget.data.communicationType.toString(),
                        role: widget.role,
                        tym: widget.data.dateTime.toString(),
                        notiid: widget.notiid,
                        gid: widget.id,
                        isDeleted: false,
                      ),
                    ],
                  ),
                  VisibilityWidget(
                      role: widget.role,
                      visible: widget.data.visibility.toString()),
                ],
              )
            : Column(
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
                                  Colors.orange.shade300,
                                  Colors.deepOrange
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.centerRight),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              'Home Work',
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
                          Chat.homeWorkIcon,
                          height: 25,
                          width: 25,
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TimeWidget(
                        redCount: widget.redCount,
                        role: widget.role,
                        tym: widget.data.dateTime.toString(),
                        communicationType:
                            widget.data.communicationType.toString(),
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
                        onTap: () async {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => HomeWorkScreen(
                          //         // sibling: widget.sibling,
                          //         classId: widget.clsId,
                          //         role: widget.role,
                          //         isHomeWork: true,
                          //         selectedDate: widget.data.dateTime,
                          //       ),
                          //     ));

                          // await messageRead(
                          //         msgStatus: '3',
                          //         notifyid: '')
                          //     .then((value) {});
                        },
                        child: ChatBubble(
                          clipper:
                              ChatBubbleClipper10(type: BubbleType.sendBubble),
                          backGroundColor: const Color(0xffE7E7ED),
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.only(
                              bottom: 3, right: 6, left: 7),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(Images.homeWork),
                                Row(
                                  children: [
                                    const Text(
                                      "Subject : ",
                                      style: TextStyle(
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.data.subjectName,
                                      style:
                                          const TextStyle(color: Colors.brown),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "H/W Date : ",
                                      style: TextStyle(
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.data.designation.replaceAll(
                                          'Home Work of the day', ''),
                                      style:
                                          const TextStyle(color: Colors.brown),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Viewed : ",
                                      style: TextStyle(
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.watchCount.toString(),
                                      style:
                                          const TextStyle(color: Colors.brown),
                                    )
                                  ],
                                ),
                              ],
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                        image: const NetworkImage(
                            "https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg"),
                        fit: BoxFit.fill,
                      )),
                  padding: const EdgeInsets.all(15),
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.7,
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
              ),
              Positioned(
                left: 242,
                bottom: 310,
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

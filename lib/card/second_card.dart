import 'package:flutter/material.dart';
import 'package:ui/api/delete_api.dart';
import 'package:ui/api/info_api.dart';
import 'package:ui/config/size_config.dart';
import 'package:ui/custom/time_widget.dart';
import 'package:ui/custom/visibility_widget.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/utils/utility.dart';

import '../model/infomodel.dart';

class SecondCard extends StatefulWidget {
  const SecondCard({
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
  State<SecondCard> createState() => _SecondCardState();
}

class _SecondCardState extends State<SecondCard> {
  Info? infoMessage;

  @override
  void initState() {
    super.initState();
    // initTimer();
  }

  // Timer? timer;

  // void initTimer() {
  //   if (timer != null && timer!.isActive) return;

  //   timer = Timer.periodic(const Duration(seconds: 5), (timer) {
  //     //job
  //     setState(() {});
  //   });
  // }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return widget.type == 2
        ? Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
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
                                    infoMessage = value;
                                  });
                                  ShowDialog(context, infoMessage, widget.data);
                                  // initTimer();
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
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
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, top: 5, bottom: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.pink),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(20),
                                    )),
                                child: widget.data.messageCategory ==
                                            "Images" ||
                                        widget.data.messageCategory ==
                                            "ImageWithCaption"
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 16,
                                            top: 2,
                                            bottom: 2),
                                        child: Row(
                                          children: const [
                                            Image(
                                                height: 30,
                                                width: 30,
                                                image: NetworkImage(
                                                    "https://cdn-icons-png.flaticon.com/512/7734/7734301.png")),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Image",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            )
                                          ],
                                        ))
                                    : widget.data.messageCategory == "Text"
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5,
                                                right: 16,
                                                top: 2,
                                                bottom: 2),
                                            child: Row(
                                              children: const [
                                                Image(
                                                    height: 30,
                                                    width: 30,
                                                    image: NetworkImage(
                                                        "https://cdn-icons-png.flaticon.com/512/4698/4698646.png")),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Text",
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                )
                                              ],
                                            ))
                                        : widget.data.messageCategory ==
                                                "Quotes"
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5,
                                                    right: 16,
                                                    top: 2,
                                                    bottom: 2),
                                                child: Row(
                                                  children: const [
                                                    Image(
                                                        height: 30,
                                                        width: 30,
                                                        image: NetworkImage(
                                                            "https://cdn-icons-png.flaticon.com/512/4698/4698646.png")),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Quote",
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    )
                                                  ],
                                                ))
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5,
                                                    right: 16,
                                                    top: 2,
                                                    bottom: 2),
                                                child: Row(
                                                  children: const [
                                                    Image(
                                                        height: 30,
                                                        width: 30,
                                                        image: NetworkImage(
                                                            "https://cdn-icons-png.flaticon.com/512/7313/7313692.png")),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Audio",
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    )
                                                  ],
                                                )),
                              ),
                            ),
                          ),
                          TimeWidget(
                            redCount: widget.redCount,
                            role: widget.role,
                            tym: widget.data.dateTime.toString(),
                            notiid: widget.notiid,
                            gid: widget.id,
                            communicationType:
                                widget.data.communicationType.toString(),
                            isDeleted: true,
                          )
                        ],
                      ),
                      VisibilityWidget(
                          role: widget.role,
                          visible: widget.data.visibility.toString()),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Align(
              alignment: Alignment.centerRight,
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
                      Row(
                        children: [
                          TimeWidget(
                            redCount: widget.redCount,
                            role: widget.role,
                            tym: widget.data.dateTime.toString(),
                            notiid: widget.notiid,
                            gid: widget.id,
                            isDeleted: true,
                            communicationType:
                                widget.data.communicationType.toString(),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                top: 5,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(0),
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    )),
                                child: widget.data.messageCategory ==
                                            "Images" ||
                                        widget.data.messageCategory ==
                                            "ImageWithCaption"
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            right: 7,
                                            left: 16,
                                            top: 2,
                                            bottom: 2),
                                        child: Row(
                                          children: const [
                                            Image(
                                                height: 30,
                                                width: 30,
                                                image: NetworkImage(
                                                    "https://cdn-icons-png.flaticon.com/512/7734/7734301.png")),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Image",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            )
                                          ],
                                        ))
                                    : widget.data.messageCategory == "Text"
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 7,
                                                left: 16,
                                                top: 2,
                                                bottom: 2),
                                            child: Row(
                                              children: const [
                                                Image(
                                                    height: 30,
                                                    width: 30,
                                                    image: NetworkImage(
                                                        "https://cdn-icons-png.flaticon.com/512/4698/4698646.png")),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Text",
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                )
                                              ],
                                            ))
                                        : widget.data.messageCategory ==
                                                "Quotes"
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5,
                                                    right: 16,
                                                    top: 2,
                                                    bottom: 2),
                                                child: Row(
                                                  children: const [
                                                    Image(
                                                        height: 30,
                                                        width: 30,
                                                        image: NetworkImage(
                                                            "https://cdn-icons-png.flaticon.com/512/4698/4698646.png")),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Quote",
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    )
                                                  ],
                                                ))
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5,
                                                    right: 16,
                                                    top: 2,
                                                    bottom: 2),
                                                child: Row(
                                                  children: const [
                                                    Image(
                                                        height: 30,
                                                        width: 30,
                                                        image: NetworkImage(
                                                            "https://cdn-icons-png.flaticon.com/512/7313/7313692.png")),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Audio",
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    )
                                                  ],
                                                )),
                              ),
                            ),
                          ),
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
                                    infoMessage = value;
                                  });
                                  ShowDialog(context, infoMessage, widget.data);
                                  //   initTimer();
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

ShowDialog(
  contex,
  Info? infoMessage,
  Message data,
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
                                    infoMessage!.messageInfo.initiatedBy,
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
                                    infoMessage
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
                                        infoMessage.messageInfo.initiatedOn
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
                                    infoMessage.messageInfo.approvedBy,
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
                                    infoMessage
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
                                    "designation",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infoMessage.messageInfo.area,
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
                                        infoMessage.messageInfo.approvedAt
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
                                    infoMessage.messageInfo.deletedBy,
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
                                        infoMessage.messageInfo.deletedOn
                                            .toString(),
                                        "dd/MM/yyyy"),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                            ],
                          ),
                          data.approvalStatus == 0
                              ? const Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Text(
                                    "Waiting for approval",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 16),
                                  ),
                                )
                              : Container()
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

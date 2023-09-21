import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui/config/size_config.dart';
import 'package:ui/model/message_view_model.dart';
import '../api/info_api.dart';
import '../card/approved_card.dart';
import '../model/infomodel.dart';

class InfoDeleteWidget extends StatefulWidget {
  const InfoDeleteWidget(
      {super.key,
      required this.data,
      required this.itemIndex,
      // required this.role,
      required this.id,
      required this.callback,
      required this.type,
      required this.isDeleted
      // required this.node,
      });
  final Message data;
  // final String role;
  final int itemIndex;
  final String id;
  final Function callback;
  final int type;
  final bool isDeleted;

  @override
  State<InfoDeleteWidget> createState() => _InfoDeleteWidgetState();
}

class _InfoDeleteWidgetState extends State<InfoDeleteWidget> {
  Info? infoMessage;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 5,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                await getInfo(widget.id, widget.data.notificationId.toString(),
                        widget.data.communicationType.toString())
                    .then((value) {
                  setState(() {
                    infoMessage = value;
                  });
                  showInfoMessage(
                    context,
                    infoMessage,
                  );
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
            widget.isDeleted == false
                ? GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            "Delete Confirmation",
                            style: TextStyle(
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                          content: Text(
                            "Do you wants to Delete the Message?",
                            style: TextStyle(
                                fontSize: 2.2 * SizeConfig.textMultiplier,
                                color: Colors.grey[700]),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                Navigator.of(ctx).pop();
                                await deleteNotify(
                                    grpid: widget.id,
                                    notifyid:
                                        widget.data.notificationId.toString(),
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
                : Container()
          ],
        ),
      ),
    );
  }
}

class InfoDeleteWidgetRight extends StatefulWidget {
  const InfoDeleteWidgetRight(
      {super.key,
      required this.data,
      required this.itemIndex,
      // required this.role,
      required this.id,
      required this.callback,
      required this.type,
      required this.isDeleted
      // required this.node,
      });
  final Message data;
  // final String role;
  final int itemIndex;
  final String id;
  final Function callback;
  final int type;
  final bool isDeleted;

  @override
  State<InfoDeleteWidgetRight> createState() => _InfoDeleteWidgetRightState();
}

class _InfoDeleteWidgetRightState extends State<InfoDeleteWidgetRight> {
  Info? infoMessage;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.only(
          right: 10,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                await getInfo(widget.id, widget.data.notificationId.toString(),
                        widget.data.communicationType.toString())
                    .then((value) {
                  setState(() {
                    infoMessage = value;
                  });
                  showInfoMessage(
                    context,
                    infoMessage,
                  );
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
            widget.isDeleted == false
                ? GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            "Delete Confirmation",
                            style: TextStyle(
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                          content: Text(
                            "Do you wants to Delete the Message?",
                            style: TextStyle(
                                fontSize: 2.2 * SizeConfig.textMultiplier,
                                color: Colors.grey[700]),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                Navigator.of(ctx).pop();
                                await deleteNotify(
                                    grpid: widget.id,
                                    notifyid:
                                        widget.data.notificationId.toString(),
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
                : Container()
          ],
        ),
      ),
    );
  }
}

showInfoMessage(
  context,
  Info? infoMessage,
) {
  DateTime now = infoMessage!.messageInfo.initiatedOn;

  return showDialog(
      context: (context),
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
                      height: MediaQuery.of(context).size.height * 0.37,
                      width: MediaQuery.of(context).size.width * 0.35,
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
                                    infoMessage.messageInfo.initiatedBy,
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
                                    DateFormat('dd-MM-yyyy hh:mm a')
                                        .format(now)
                                        .toString(),
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
                                    infoMessage.messageInfo.approvedBy == ''
                                        ? 'NA'
                                        : infoMessage.messageInfo.approvedBy,
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
                                    infoMessage.messageInfo
                                                .approverUserCategory ==
                                            ''
                                        ? 'NA'
                                        : infoMessage
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
                                    infoMessage.messageInfo.approvedAt == ''
                                        ? 'NA'
                                        : DateFormat('dd-MM-yyyy hh:mm a')
                                            .format(DateTime.parse(infoMessage
                                                .messageInfo.approvedAt))
                                            .toString(),
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
                                    infoMessage.messageInfo.deletedBy == ''
                                        ? 'NA'
                                        : infoMessage.messageInfo.deletedBy,
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
                                    infoMessage.messageInfo.deletedOn == ''
                                        ? 'NA'
                                        : DateFormat('dd-MM-yyyy hh:mm a')
                                            .format(DateTime.parse(infoMessage
                                                .messageInfo.deletedOn))
                                            .toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: MediaQuery.of(context).size.width * 0.31,
                  bottom: MediaQuery.of(context).size.height * 0.64,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/api/delete_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/info_delete.dart';
import 'package:ui/custom/receive_message_importatnt_title.dart';
import 'package:ui/custom/send_message_important_title.dart';
import 'package:ui/custom/time_widget.dart';
import 'package:ui/custom/visibility_widget.dart';
import 'package:ui/model/info_model.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/utils/utils_file.dart';
import 'package:ui/utils/utility.dart';

class FirstCard extends StatefulWidget {
  const FirstCard({
    super.key,
    required this.data,
    required this.itemIndex,
    required this.id,
    required this.usr_Name,
    required this.notiid,
    required this.callback,
    required this.role,
    required this.type,
    required this.redCount,
  });
  final Message data;
  final int itemIndex;
  final String id;
  final String usr_Name;
  final int notiid;
  final Function callback;
  final String role;
  final int type;
  final int redCount;

  @override
  State<FirstCard> createState() => _FirstCardState();
}

class _FirstCardState extends State<FirstCard> {
  bool isVisible = false;
  Info? infoMessage;

  @override
  Widget build(BuildContext context) {
    return widget.type == 1
        ? Padding(
            padding: const EdgeInsets.only(right: 7.0),
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
                                    Colors.blue.shade300,
                                    Colors.blueAccent
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.centerRight),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                'Text',
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
                            Chat.chatIcon,
                            height: 25,
                            width: 25,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SendMessageImportantTitle(data: widget.data),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          TimeWidget(
                            redCount: widget.redCount,
                            role: widget.role,
                            tym: widget.data.dateTime.toString(),
                            notiid: widget.notiid,
                            communicationType:
                                widget.data.communicationType.toString(),
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
                              clipper: ChatBubbleClipper10(
                                  type: BubbleType.sendBubble),
                              backGroundColor: const Color(0xffE7E7ED),
                              alignment: Alignment.topRight,
                              margin: const EdgeInsets.only(bottom: 3, left: 5),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.34,
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
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: VisibilityWidget(
                            role: widget.role,
                            visible: widget.data.visibility.toString()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 7),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            Chat.chatIcon,
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
                                    Colors.blue.shade300,
                                    Colors.blueAccent
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.centerRight),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  const Text(
                                    'Text',
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
                              margin: const EdgeInsets.only(bottom: 3),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.34,
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
                          const SizedBox(
                            width: 10,
                          ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: VisibilityWidget(
                          visible: widget.data.visibility.toString(),
                          role: widget.role,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

Future<void> deleteNotify(BuildContext context,
    {required String grpid,
    required String notifyid,
    required String communicationType}) async {
  // _showLoader(context);
  await deleteNotification(
    grpid: grpid,
    notifyid: notifyid,
  ).then((value) {
    if (value["success"] == "Deleted Successfully!...") {
      Utility.displaySnackBar(context, "Message Deleted");
    } else {
      Navigator.of(context).pop();
      print("not delete");
    }
  });
}

showDialogFunction(
  context,
  Info? infoMessage,
) {
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
                              const TableRow(children: [
                                Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Initiated on",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    '',
                                    style: TextStyle(fontSize: 12),
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
                              const TableRow(children: [
                                Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Approved on",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    '',
                                    style: TextStyle(fontSize: 12),
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
                              const TableRow(children: [
                                Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Deleted on",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    '',
                                    style: TextStyle(fontSize: 12),
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
                  bottom: MediaQuery.of(context).size.height * 0.15,
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

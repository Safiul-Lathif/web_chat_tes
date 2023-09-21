// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:ui/api/delete_api.dart';
import 'package:ui/api/info_api.dart';
import 'package:ui/config/size_config.dart';
import 'package:ui/custom/time_widget.dart';
import 'package:ui/custom/visibility_widget.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/utils/utility.dart';

import '../model/infomodel.dart';

class ParentsApproved extends StatefulWidget {
  const ParentsApproved({
    super.key,
    required this.data,
    required this.itemIndex,
    required this.id,
    required this.notiid,
    required this.callback,
    required this.role,
    required this.usr_Name,
    required this.type,
    required this.redCount,
  });
  final Message data;
  final int itemIndex;
  final String id;
  final int notiid;
  final Function callback;
  final String role;
  final String usr_Name;
  final int type;
  final int redCount;

  @override
  State<ParentsApproved> createState() => _ParentsApprovedState();
}

class _ParentsApprovedState extends State<ParentsApproved> {
  bool isVisible = false;
  Info? infomessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: widget.type == 1
          ? Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(9),
                                  bottomLeft: Radius.circular(9),
                                  bottomRight: Radius.circular(9)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.green.shade300,
                              ),
                              gradient: const LinearGradient(
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
                          Visibility(
                              visible: isVisible,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 1000),
                                reverseDuration:
                                    const Duration(milliseconds: 500),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await getInfo(
                                                widget.id,
                                                widget.data.notificationId
                                                    .toString(),
                                                widget.data.communicationType
                                                    .toString())
                                            .then((value) {
                                          setState(() {
                                            infomessage = value;
                                          });
                                          ShowDialog(context, infomessage!);
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
                                                  fontSize: 2.5 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700]),
                                            ),
                                            content: Text(
                                              "Do you wants to Delete the Message?",
                                              style: TextStyle(
                                                  fontSize: 2.2 *
                                                      SizeConfig.textMultiplier,
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
                      Row(
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    widget.data.message.toString(),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      VisibilityWidget(
                          role: widget.role,
                          visible: widget.data.visibility.toString())
                    ],
                  ),
                ],
              ),
            )
          : Align(
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
                                    infomessage = value;
                                  });
                                  ShowDialog(context, infomessage!);
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
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(9),
                                  bottomLeft: Radius.circular(9),
                                  bottomRight: Radius.circular(9)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.pink.shade300,
                              ),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.shade400,
                                    Colors.pink.shade200
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.centerRight),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
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
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.pink),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    widget.data.message.toString(),
                                    style: const TextStyle(color: Colors.brown),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TimeWidget(
                            redCount: widget.redCount,
                            role: widget.role,
                            communicationType:
                                widget.data.communicationType.toString(),
                            tym: widget.data.dateTime.toString(),
                            notiid: widget.notiid,
                            gid: widget.id,
                            isDeleted: false,
                          )
                        ],
                      ),
                      VisibilityWidget(
                          role: widget.role,
                          visible: widget.data.visibility.toString())
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

DeleteContent(BuildContext context,
    {required String id, required String datas}) {
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Dialog(
            child: SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Are you sure you want to delete?",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          // foregroundColor: Colors.white,
                          backgroundColor: Colors.red.shade400,
                          minimumSize: const Size(30, 40),
                          textStyle: const TextStyle(fontSize: 14),
                          side:
                              BorderSide(width: 1, color: Colors.red.shade400)),
                      onPressed: () async {
                        await deleteNotification(grpid: id, notifyid: datas)
                            .then((value) {
                          if (value == "Deleted Successfully!...") {
                            Navigator.pop(context);
                            Utility.displaySnackBar(
                                context, "Message Deleted Successfully");
                          } else {
                            Utility.displaySnackBar(
                                context, "Message not Deleted");
                            Navigator.pop(context);
                            print("not delete");
                          }
                        });
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.delete,
                            size: 17,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          // foregroundColor: Colors.white,
                          backgroundColor: Colors.green.shade400,
                          minimumSize: const Size(30, 40),
                          textStyle: const TextStyle(fontSize: 14),
                          side:
                              const BorderSide(width: 1, color: Colors.green)),
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.clear,
                            size: 17,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Cancel', style: TextStyle(color: Colors.white)),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ));
      });
    },
  );
}

ShowDialog(
  context,
  Info? infomessage,
) {
  return showDialog(
      context: (context),
      builder: ((context) {
        return infomessage == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                          infomessage.messageInfo.initiatedBy,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ))
                                    ]),
                                    /////////////////////2
                                    const TableRow(children: [
                                      Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          "Initiated user Category",
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
                                    const TableRow(children: [
                                      Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          "Approved by",
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
                                    const TableRow(children: [
                                      Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          "Approver user Category",
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
                                    const TableRow(children: [
                                      Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          "Designation",
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
                                    const TableRow(children: [
                                      Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          "Deleted by",
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
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 16),
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

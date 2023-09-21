import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ui/config/images.dart';
import 'package:ui/config/strings.dart';
import 'package:ui/custom/approve_deny.dart';
import 'package:ui/custom/deleted_widget.dart';
import 'package:ui/custom/info_delete.dart';
import 'package:ui/custom/receive_message_importatnt_title.dart';
import 'package:ui/custom/send_message_important_title.dart';
import 'package:ui/custom/text.dart';
import 'package:ui/custom/time_widget.dart';
import 'package:ui/custom/visibility_widget.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/utils/utils_file.dart';

class MaterialCard extends StatefulWidget {
  const MaterialCard({
    super.key,
    required this.data,
    required this.itemIndex,
    required this.id,
    required this.notiid,
    required this.callback,
    required this.role,
    required this.type,
    required this.redCount,
    required this.watchCount,
  });
  final Message data;
  final int itemIndex;
  final String id;
  final int notiid;
  final Function callback;
  final String role;
  final int type;
  final int redCount;
  final int watchCount;

  @override
  State<MaterialCard> createState() => _MaterialCardState();
}

class _MaterialCardState extends State<MaterialCard> {
  bool isDownloading = false;
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        Chat.materialIcon,
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
                                Colors.deepOrange.shade300,
                                Colors.orangeAccent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.centerRight),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              const Text(
                                'Study Material',
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
                          clipper: ChatBubbleClipper10(
                              type: BubbleType.receiverBubble),
                          backGroundColor: const Color(0xffE7E7ED),
                          padding: const EdgeInsets.only(
                              top: 15, left: 15, right: 5),
                          margin: const EdgeInsets.only(bottom: 3, right: 10),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.15,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.data.caption != '')
                                      Container(
                                        constraints:
                                            const BoxConstraints(maxHeight: 90),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Text(
                                            widget.data.caption.toString(),
                                            textAlign: TextAlign.start,
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 17 * ffem,
                                              fontWeight: FontWeight.w500,
                                              height: 1.2125 * ffem / fem,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (widget.data.caption != '')
                                      const SizedBox(
                                        height: 5,
                                      ),

                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context)
                                          .size
                                          .shortestSide,
                                      color: Colors.grey,
                                    ),
                                    if (widget.data.caption != null)
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    InkWell(
                                      onTap: () {
                                        openFile(
                                            url: widget.data.images![0],
                                            fileName: //Ticket No 45 (removed unnecessary .pdf)
                                                widget.data.images![0]
                                                    .split('/')
                                                    .last);
                                        isDownloading = true;
                                      },
                                      child: Row(
                                        children: [
                                          !isDownloading
                                              ? TextBottomWidget(
                                                  text: 'Download',
                                                  colors: Colors.pink.shade300,
                                                )
                                              : TextBottomWidget(
                                                  text: 'Downloading',
                                                  colors: Colors.pink.shade300,
                                                ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          !isDownloading
                                              ? Icon(
                                                  Icons.download,
                                                  size: 20,
                                                  color: Colors.pink.shade300,
                                                )
                                              : SizedBox(
                                                  height: 10.0,
                                                  width: 10.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                    color: Colors.pink.shade300,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    if (widget.role != 'Parent')
                                      const SizedBox(
                                        height: 3,
                                      ),
                                    // if (widget.role != 'Parent')
                                    //   Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.end,
                                    //     children: [
                                    //       const Icon(
                                    //         Icons.remove_red_eye_sharp,
                                    //         size: 15,
                                    //       ),
                                    //       const SizedBox(
                                    //         width: 3,
                                    //       ),
                                    //       Text(
                                    //         "Watched: ${widget.watchCount != null ? widget.watchCount : '0'}",
                                    //         style:
                                    //             const TextStyle(fontSize: 11),
                                    //       )
                                    //     ],
                                    //   ),
                                  ],
                                )),
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
                              isDeleted: false,
                              communicationType:
                                  widget.data.communicationType.toString(),
                            )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: VisibilityWidget(
                        role: widget.role,
                        visible: widget.data.visibility.toString()),
                  )
                ],
              )
            : Column(
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
                                  Colors.orangeAccent,
                                  Colors.deepOrange.shade300,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.centerRight),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              'Study Material',
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
                          Chat.materialIcon,
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
                              role: widget.role,
                              tym: widget.data.dateTime.toString(),
                              notiid: widget.notiid,
                              gid: widget.id,
                              communicationType:
                                  widget.data.communicationType.toString(),
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
                          clipper:
                              ChatBubbleClipper10(type: BubbleType.sendBubble),
                          backGroundColor: const Color(0xffE7E7ED),
                          padding: const EdgeInsets.only(
                              top: 15, left: 15, right: 5),
                          margin: const EdgeInsets.only(
                              bottom: 3, right: 5, left: 10),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.15,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.data.caption == ''
                                        ? Container()
                                        : Text(
                                            widget.data.caption.toString(),
                                            textAlign: TextAlign.start,
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 17 * ffem,
                                              fontWeight: FontWeight.w500,
                                              height: 1.2125 * ffem / fem,
                                              color: Colors.black,
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context)
                                          .size
                                          .shortestSide,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        //
                                        openFile(
                                            url: widget.data.images![0],
                                            fileName: //Ticket No 45 (removed unnecessary .pdf)
                                                widget.data.images![0]
                                                    .split('/')
                                                    .last);
                                        isDownloading = true;
                                      },
                                      child: Row(
                                        children: [
                                          !isDownloading
                                              ? TextBottomWidget(
                                                  text: 'Download',
                                                  colors: Colors.pink.shade300,
                                                )
                                              : TextBottomWidget(
                                                  text: 'Downloading',
                                                  colors: Colors.pink.shade300,
                                                ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          !isDownloading
                                              ? Icon(
                                                  Icons.download,
                                                  size: 20,
                                                  color: Colors.pink.shade300,
                                                )
                                              : SizedBox(
                                                  height: 10.0,
                                                  width: 10.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                    color: Colors.pink.shade300,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.remove_red_eye_sharp,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          "Watched: ${widget.watchCount}",
                                          style: const TextStyle(fontSize: 11),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
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
                    padding: const EdgeInsets.only(left: 6),
                    child: VisibilityWidget(
                        role: widget.role,
                        visible: widget.data.visibility.toString()),
                  )
                ],
              );
  }

  Future openFile({required String url, required String fileName}) async {
    final file = await downloadFile(url, fileName);
    if (file == null) return;
    setState(() {
      isDownloading = false;
    });
    if (file.path.isEmpty) return;
    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getExternalStorageDirectory();
    final file = File('${appStorage!.path}/$name');
    try {
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
          ));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }
}

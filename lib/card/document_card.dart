// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ui/Utils/Utility.dart';
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
import 'package:ui/model/info_model.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/utils/utils_file.dart';

class DocumentCard extends StatefulWidget {
  const DocumentCard({
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
  State<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  Info? infomessage;
  bool isDownloading = false;
  List toggled = [];

  @override
  void initState() {
    super.initState();
    initTimer();
  }

  Timer? timer;

  void initTimer() {
    if (timer != null && timer!.isActive) return;

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      //job
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    double baseWidth = 1344;
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
            type: widget.type,
            messageCategory: widget.data.messageCategory,
          )
        : widget.type == 2
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        Chat.docIcon,
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
                              colors: [Colors.blue.shade300, Colors.blueAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.centerRight),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              const Text(
                                'Document',
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
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
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
                            margin: const EdgeInsets.only(bottom: 3, right: 10),
                            child: widget.data.images!.length <= 1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "images/doc_image.png",
                                            width: 80,
                                          ),
                                          if (widget.data.caption != null)
                                            Container(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 150),
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(
                                                widget.data.caption.toString(),
                                              ),
                                            )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          openFile(
                                              index: 0,
                                              url: widget.data.images![0],
                                              fileName: //Ticket No 45 (removed unnecessary .pdf)
                                                  widget.data.images![0]
                                                      .split('/')
                                                      .last
                                              // .replaceAll(
                                              //     '${Strings.baseURL}uploads/',
                                              //     '')
                                              );
                                          isDownloading = true;
                                        },
                                        child: Row(
                                          children: [
                                            !isDownloading
                                                ? TextBottomWidget(
                                                    text: 'Download',
                                                    colors: Colors.green,
                                                  )
                                                : TextBottomWidget(
                                                    text: 'Downloading',
                                                    colors: Colors.green,
                                                  ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            !isDownloading
                                                ? const Icon(
                                                    Icons.download,
                                                    size: 20,
                                                    color: Colors.green,
                                                  )
                                                : const SizedBox(
                                                    height: 10.0,
                                                    width: 10.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 1,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      if (widget.role != 'Parent')
                                        const SizedBox(
                                          height: 5,
                                        ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 113,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Scrollbar(
                                          thumbVisibility:
                                              true, //always show scrollbar
                                          thickness: 5, //width of scrollbar
                                          radius: const Radius.circular(
                                              20), //corner radius of scrollbar
                                          scrollbarOrientation:
                                              ScrollbarOrientation.bottom,
                                          child: GridView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                                    maxCrossAxisExtent: 150,
                                                    childAspectRatio: 1.0,
                                                    crossAxisSpacing: 5,
                                                    mainAxisSpacing: 5),
                                            itemCount:
                                                widget.data.images!.length,
                                            itemBuilder:
                                                (BuildContext ctx, index) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/doc_image.png",
                                                        width: 80,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      openFile(
                                                          url: widget.data
                                                              .images![index],
                                                          fileName: //Ticket No 45 (removed unnecessary .pdf)
                                                              widget.data
                                                                  .images![0]
                                                                  .split('/')
                                                                  .last,
                                                          index: index);
                                                      toggled.add(index);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        !toggled.contains(index)
                                                            ? TextBottomWidget(
                                                                text:
                                                                    'Download',
                                                                colors: Colors
                                                                    .green,
                                                              )
                                                            : TextBottomWidget(
                                                                text:
                                                                    'Downloading',
                                                                colors: Colors
                                                                    .green,
                                                              ),
                                                        !toggled.contains(index)
                                                            ? const Icon(
                                                                Icons.download,
                                                                size: 20,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : const SizedBox(
                                                                height: 10.0,
                                                                width: 10.0,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      1,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      if (widget.data.caption != null)
                                        Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 200, maxHeight: 70),
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
                                    ],
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
                                communicationType:
                                    widget.data.communicationType.toString(),
                                redCount: widget.redCount,
                                role: widget.role,
                                tym: widget.data.dateTime.toString(),
                                notiid: widget.notiid,
                                gid: widget.id,
                                isDeleted: false,
                              )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: VisibilityWidget(
                          role: widget.role,
                          visible: widget.data.visibility.toString())),
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
                                  Colors.blue.shade300,
                                  Colors.blueAccent
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.centerRight),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              'Document',
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
                          Chat.docIcon,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        widget.data.approvalStatus == 0
                            ? ApproveDenyWidget(
                                user: widget.role,
                                data: widget.data,
                                callback: widget.callback,
                              )
                            : TimeWidget(
                                communicationType:
                                    widget.data.communicationType.toString(),
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
                            clipper: ChatBubbleClipper10(
                                type: BubbleType.sendBubble),
                            backGroundColor: const Color(0xffE7E7ED),
                            alignment: Alignment.topRight,
                            margin: const EdgeInsets.only(
                                bottom: 3, right: 6, left: 7),
                            child: widget.data.images!.length <= 1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "assets/images/doc_image.png",
                                            width: 80,
                                          ),
                                          if (widget.data.caption != null)
                                            Container(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              constraints: const BoxConstraints(
                                                  maxWidth: 150),
                                              child: Text(
                                                widget.data.caption.toString(),
                                              ),
                                            )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print(widget.data.images![0]);
                                          openFile(
                                              url: widget.data.images![0],
                                              index: 0,
                                              fileName: //Ticket No 45 (removed unnecessary .pdf)
                                                  widget.data.images![0]
                                                      .split('/')
                                                      .last
                                              // .replaceAll(
                                              //     '${Strings.baseURL}uploads/',
                                              //     '')
                                              );
                                          isDownloading = true;
                                          print(
                                              "file:-${widget.data.images![0].split('/').last}");
                                        },
                                        child: Row(
                                          children: [
                                            !isDownloading
                                                ? Text(
                                                    "Download",
                                                    style: SafeGoogleFont(
                                                      'Inter',
                                                      fontSize: 16 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height:
                                                          1.2125 * ffem / fem,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.green,
                                                    ),
                                                  )
                                                : Text(
                                                    "Downloading",
                                                    style: SafeGoogleFont(
                                                      'Inter',
                                                      fontSize: 16 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height:
                                                          1.2125 * ffem / fem,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                            !isDownloading
                                                ? const Icon(
                                                    Icons.download,
                                                    size: 20,
                                                    color: Colors.green,
                                                  )
                                                : const SizedBox(
                                                    height: 10.0,
                                                    width: 10.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 1,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
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
                                            "Downloaded: ${widget.watchCount != null ? widget.watchCount : '0'}",
                                            style:
                                                const TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 113,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Scrollbar(
                                          thumbVisibility:
                                              true, //always show scrollbar
                                          thickness: 5, //width of scrollbar
                                          radius: const Radius.circular(
                                              20), //corner radius of scrollbar
                                          scrollbarOrientation:
                                              ScrollbarOrientation.bottom,
                                          child: GridView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                                    maxCrossAxisExtent: 150,
                                                    childAspectRatio: 1.2,
                                                    crossAxisSpacing: 5,
                                                    mainAxisSpacing: 5),
                                            itemCount:
                                                widget.data.images!.length,
                                            itemBuilder:
                                                (BuildContext ctx, index) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    "images/doc_image.png",
                                                    width: 80,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      openFile(
                                                          url: widget.data
                                                              .images![index],
                                                          fileName: //Ticket No 45 (removed unnecessary .pdf)
                                                              widget
                                                                  .data
                                                                  .images![
                                                                      index]
                                                                  .split('/')
                                                                  .last,
                                                          index: index);
                                                      toggled.add(index);

                                                      print(
                                                          "file:-${widget.data.images![0].split('/').last}");
                                                    },
                                                    child: Row(
                                                      children: [
                                                        !toggled.contains(index)
                                                            ? Text(
                                                                "Download",
                                                                style:
                                                                    SafeGoogleFont(
                                                                  'Inter',
                                                                  fontSize:
                                                                      16 * ffem,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height:
                                                                      1.2125 *
                                                                          ffem /
                                                                          fem,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              )
                                                            : Text(
                                                                "Downloading",
                                                                style:
                                                                    SafeGoogleFont(
                                                                  'Inter',
                                                                  fontSize:
                                                                      14 * ffem,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height:
                                                                      1.2125 *
                                                                          ffem /
                                                                          fem,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              ),
                                                        !toggled.contains(index)
                                                            ? const Icon(
                                                                Icons.download,
                                                                size: 20,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : const SizedBox(
                                                                height: 10.0,
                                                                width: 10.0,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      1,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      if (widget.data.caption != null)
                                        Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 200, maxHeight: 70),
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.remove_red_eye_sharp,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            "Downloaded: ${widget.watchCount != null ? widget.watchCount : '0'}",
                                            style:
                                                const TextStyle(fontSize: 11),
                                          ),
                                          const SizedBox(
                                            width: 120,
                                          )
                                        ],
                                      ),
                                    ],
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
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: VisibilityWidget(
                          role: widget.role,
                          visible: widget.data.visibility.toString())),
                ],
              );
  }

  Future openFile(
      {required String url,
      required String fileName,
      required int index}) async {
    final file = await downloadFile(url, fileName);
    setState(() {
      toggled = [];
      //ticket no:- unknown issue
      isDownloading = false;
    });
    if (file == null) {
      return Utility.displaySnackBar(context, 'Unable to open Document');
    }
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

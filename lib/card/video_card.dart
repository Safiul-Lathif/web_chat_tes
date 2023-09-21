import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:ui/api/message_read_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/approve_deny.dart';
import 'package:ui/custom/deleted_widget.dart';
import 'package:ui/custom/send_message_important_title.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/custom/info_delete.dart';
import 'package:ui/custom/receive_message_importatnt_title.dart';
import 'package:ui/custom/time_widget.dart';
import 'package:ui/custom/visibility_widget.dart';
import 'package:ui/utils/utils_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoCard extends StatefulWidget {
  const VideoCard(
      {super.key,
      required this.data,
      required this.itemIndex,
      required this.id,
      required this.notiid,
      required this.callback,
      required this.role,
      required this.type,
      required this.redCount,
      required this.watchCount});
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
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  ScrollController scrollController = ScrollController();

  bool isVisible = false;
  bool playVideo = false;
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
            ? receivedMessage(fem, context, ffem)
            : sendMessage(fem, context, ffem);
  }

  sendMessage(double fem, BuildContext context, double ffem) {
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
                      colors: [Colors.orange.shade300, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'Video',
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
                Chat.videoIcon,
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
                    data: widget.data,
                    callback: widget.callback,
                    user: widget.role,
                  )
                : TimeWidget(
                    redCount: widget.redCount,
                    role: widget.role,
                    tym: widget.data.dateTime.toString(),
                    notiid: widget.notiid,
                    gid: widget.id,
                    isDeleted: false,
                    communicationType: widget.data.communicationType.toString(),
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
                      maxWidth: MediaQuery.of(context).size.width * 0.2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ClipRRect(
                        //   borderRadius:
                        //       const BorderRadius.all(Radius.circular(20)),
                        //   child: InkWell(
                        //     onTap: () {
                        //       setState(() {
                        //         playVideo = !playVideo;
                        //       });
                        //     },
                        //     child: playVideo
                        //         ? Column(
                        //             children: [
                        //               YoutubePlayer(
                        //                 controller: YoutubePlayerController(
                        //                   initialVideoId:
                        //                       "${YoutubePlayer.convertUrlToId(widget.data.images![0])}",
                        //                   flags: const YoutubePlayerFlags(
                        //                     enableCaption: true,
                        //                     captionLanguage: 'en',
                        //                   ),
                        //                 ),
                        //                 liveUIColor: Colors.amber,
                        //                 showVideoProgressIndicator: true,
                        //                 bottomActions: [
                        //                   CurrentPosition(),
                        //                   ProgressBar(
                        //                     isExpanded: true,
                        //                   ),
                        //                   const PlaybackSpeedButton()
                        //                 ],
                        //               ),
                        //             ],
                        //           )
                        //         : Container(
                        //             height: MediaQuery.of(context).size.height *
                        //                 0.2,
                        //             width: double.infinity,
                        //             decoration: BoxDecoration(
                        //               color: Colors.white,
                        //               image: DecorationImage(
                        //                   image: NetworkImage(
                        //                       'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(widget.data.images![0])}/0.jpg'),
                        //                   fit: BoxFit.cover),
                        //             ),
                        //             child: const Icon(
                        //               Icons.play_circle_filled,
                        //               color: Colors.white,
                        //               size: 60.0,
                        //             )),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: InkWell(
                              onTap: () {
                                launchUrl(Uri.parse(widget.data.images![0]),
                                    mode: LaunchMode.externalApplication);
                              },
                              child: const Text(
                                "Click to play the video on YouTube",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        if (widget.data.caption != '')
                          const SizedBox(
                            height: 5,
                          ),
                        if (widget.data.caption != '')
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.34,
                                child: Text(
                                  widget.data.caption ?? "",
                                  textAlign: TextAlign.start,
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 14 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.shortestSide,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.remove_red_eye_sharp,
                              size: 15,
                            ),
                            Text(
                              "Watched: ${widget.watchCount != null ? widget.watchCount : '0'}",
                              style: const TextStyle(fontSize: 11),
                            ),
                            widget.data.images!.length > 2
                                ? const SizedBox(
                                    width: 56,
                                  )
                                : Container(),
                            widget.data.images!.length > 2
                                ? Text(
                                    "File Count: ${widget.data.images!.length.toString()}",
                                    style: const TextStyle(fontSize: 11),
                                  )
                                : Container(),
                            widget.data.images!.length > 2
                                ? IconButton(
                                    onPressed: () {
                                      scrollController.animateTo(
                                          scrollController
                                              .position.maxScrollExtent,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeOut);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_circle_down_outlined,
                                      size: 20,
                                    ))
                                : Container()
                          ],
                        ),
                      ],
                    )),
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

  receivedMessage(double fem, BuildContext context, double ffem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 3,
            ),
            Image.asset(
              Chat.videoIcon,
              height: 24,
              width: 24,
            ),
            const SizedBox(
              width: 4,
            ),
            ReceiveMessageImportantTitle(data: widget.data)
          ],
        ),
        const SizedBox(
          height: 5,
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
                      maxWidth: MediaQuery.of(context).size.width * 0.15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(
                            Icons.link,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: InkWell(
                                onTap: () {
                                  launchUrl(Uri.parse(widget.data.images![0]),
                                      mode: LaunchMode.externalApplication);
                                },
                                child: const Text(
                                  "Click to play the video on YouTube",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                )),
                          )
                        ]),
                        const SizedBox(
                          height: 5,
                        ),
                        if (widget.data.caption != '')
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.34,
                                child: Text(
                                  widget.data.caption ?? "",
                                  textAlign: TextAlign.start,
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 14 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        if (widget.role != 'Parent')
                          const SizedBox(
                            height: 5,
                          ),
                        if (widget.role != 'Parent')
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.shortestSide,
                            color: Colors.grey,
                          ),
                        if (widget.role != 'Parent')
                          const SizedBox(
                            height: 5,
                          ),
                        if (widget.role != 'Parent')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.remove_red_eye_sharp,
                                size: 15,
                              ),
                              Text(
                                "Watched: ${widget.watchCount != null ? widget.watchCount : '0'}",
                                style: TextStyle(fontSize: 11),
                              )
                            ],
                          ),
                      ],
                    )),
              ),
            ),
            widget.data.approvalStatus == 0
                ? ApproveDenyWidget(
                    user: widget.role,
                    data: widget.data,
                    callback: widget.callback,
                  )
                : TimeWidget(
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
}

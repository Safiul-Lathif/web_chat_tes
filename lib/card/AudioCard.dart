import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:ui/api/message_read_api.dart';
import 'package:ui/custom/approve_deny.dart';
import 'package:ui/custom/info_delete.dart';
import 'package:ui/custom/time_widget.dart';
import 'package:ui/custom/visibility_widget.dart';
import 'package:ui/model/message_view_model.dart';

class AudioCard extends StatefulWidget {
  const AudioCard({
    super.key,
    required this.data,
    required this.itemIndex,
    required this.id,
    required this.notiid,
    required this.usr_Name,
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
  final String usr_Name;
  final Function callback;
  final String role;
  final int type;
  final int redCount;
  final int watchCount;

  @override
  State<AudioCard> createState() => _AudioCardState();
}

class _AudioCardState extends State<AudioCard> {
  // late final Duration duration = const Duration();
  // late final Duration position = const Duration();

  // bool downloading = false;

  // int currentstate = 2;

  AudioPlayer audioPlayer = AudioPlayer();
  // PlayerState audioPlayerState = PlayerState.PAUSED;

  // late AudioCache _audioCache;
  // String isType = "download";
  // late int loadFile;
  // late String path;

  Duration duration = const Duration();
  Duration position = const Duration();
  late bool playing;

  // ReceivePort port = ReceivePort();
  bool isVisible = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      playing = false;
    });
    // _audioCache = AudioCache(fixedPlayer: audioPlayer);
    // audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
    //   setState(() {
    //     audioPlayerState = s;
    //   });
    // });

    //   audioPlayer.onDurationChanged.listen((d) => setState(() => _duration = d));

    //   audioPlayer.onAudioPositionChanged
    //       .listen((p) => setState(() => _position = p));
  }

  // @override
  // void dispose() {
  //   IsolateNameServer.removePortNameMapping('downloader_send_port');
  //   super.dispose();
  //   audioPlayer.release();
  //   audioPlayer.dispose();
  //   _audioCache.clearAll();
  // }

  // pauseMusic() async {
  //   await audioPlayer.pause();
  // }

  // playLocal(String path) async {}

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return widget.type == 1
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
                          colors: [Color(0xff64a78b), Color(0xff69c767)],
                          begin: Alignment.topLeft,
                          end: Alignment.centerRight),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.pink.shade300,
                    child: Image.asset(
                      'assets/images/image-79-RTQ.png',
                      height: 15,
                      width: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
              /////___________AUDIO____________////
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
                      clipper: ChatBubbleClipper10(type: BubbleType.sendBubble),
                      backGroundColor: const Color(0xffE7E7ED),
                      margin:
                          const EdgeInsets.only(left: 5, right: 5, bottom: 4),
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      var url =
                                          // "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
                                          widget.data.images![0]
                                                  .contains("https://")
                                              ? widget.data.images![0]
                                              : widget.data.images![0]
                                                      .contains("http://")
                                                  ? widget.data.images![0]
                                                  : "https://${widget.data.images![0]}";

                                      setState(() {
                                        playing = !playing;
                                      });
                                      if (playing) {
                                        var res = await audioPlayer.play(url);
                                        if (res == 1) {
                                          setState(() {
                                            playing = true;
                                          });
                                        }
                                        await messageRead(
                                                msgStatus: '3',
                                                notifyid:
                                                    widget.notiid.toString())
                                            .then((value) {});
                                      } else {
                                        var res = await audioPlayer.pause();
                                        if (res == 1) {
                                          setState(() {
                                            playing = false;
                                          });
                                        }
                                      }
                                      audioPlayer.onDurationChanged
                                          .listen((Duration dd) {
                                        setState(() {
                                          duration = dd;
                                        });
                                      });
                                      audioPlayer.onAudioPositionChanged
                                          .listen((Duration dd) {
                                        setState(() {
                                          position = dd;
                                        });
                                      });
                                    },
                                    icon: Icon(
                                        // audioPlayerState == PlayerState.PLAYING
                                        playing == true
                                            ? Icons.pause
                                            : Icons.play_arrow),
                                  ),
                                  slider(),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 1,
                                width:
                                    MediaQuery.of(context).size.shortestSide *
                                        0.25,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.hearing,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "Listened: ${widget.watchCount != null ? widget.redCount : "0"}",
                                    style: const TextStyle(fontSize: 11),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: VisibilityWidget(
                      role: widget.role,
                      visible: widget.data.visibility.toString())),
            ],
          )
        : Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.pink.shade300,
                      child: Image.asset(
                        'assets/images/image-79-RTQ.png',
                        height: 15,
                        width: 15,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 5),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            5 * fem, 0 * fem, 100 * fem, 0 * fem),
                        padding: EdgeInsets.fromLTRB(
                            5 * fem, 4 * fem, 15 * fem, 3 * fem),
                        height: 23,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7 * fem),
                          gradient: LinearGradient(
                              colors: [
                                Colors.pink.shade300,
                                Colors.pink.shade400,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.centerRight),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x3f000000),
                              offset: Offset(-2 * fem, 2 * fem),
                              blurRadius: 2 * fem,
                            ),
                          ],
                        ),
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
                /////___________AUDIO____________////
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
                        margin: const EdgeInsets.only(left: 5, right: 10),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.height * 0.35),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        var url =
                                            // "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
                                            widget.data.images![0]
                                                    .contains("https://")
                                                ? widget.data.images![0]
                                                : widget.data.images![0]
                                                        .contains("http://")
                                                    ? widget.data.images![0]
                                                    : "https://${widget.data.images![0]}";

                                        setState(() {
                                          playing = !playing;
                                        });
                                        if (playing) {
                                          var res = await audioPlayer.play(url);

                                          if (res == 1) {
                                            setState(() {
                                              playing = true;
                                            });
                                          }
                                          await messageRead(
                                                  msgStatus: '3',
                                                  notifyid:
                                                      widget.notiid.toString())
                                              .then((value) {});
                                        } else {
                                          var res = await audioPlayer.pause();
                                          if (res == 1) {
                                            setState(() {
                                              playing = false;
                                            });
                                          }
                                        }
                                        audioPlayer.onDurationChanged
                                            .listen((Duration dd) {
                                          setState(() {
                                            duration = dd;
                                          });
                                        });
                                        audioPlayer.onAudioPositionChanged
                                            .listen((Duration dd) {
                                          setState(() {
                                            position = dd;
                                          });
                                        });
                                      },
                                      icon: Icon(
                                          // audioPlayerState == PlayerState.PLAYING
                                          playing == true
                                              ? Icons.pause
                                              : Icons.play_arrow),
                                    ),
                                    slider(),
                                  ],
                                ),
                                if (widget.role != 'Parent')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(
                                        Icons.hearing,
                                        size: 15,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "Listened: ${widget.watchCount != null ? widget.watchCount : '0'}",
                                        style: const TextStyle(fontSize: 11),
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          ),
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
                          ),
                  ],
                ),
                VisibilityWidget(
                    role: widget.role,
                    visible: widget.data.visibility.toString()),
              ],
            ),
          );
  }

  Widget slider() => Slider.adaptive(
      thumbColor: Colors.blue.shade900,
      activeColor: Colors.blue,
      min: 0.0,
      value: position.inSeconds.toDouble(),
      max: duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          audioPlayer.seek(Duration(seconds: value.toInt()));
        });
      });

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    audioPlayer.seek(newDuration);
  }
}

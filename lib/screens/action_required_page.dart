// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:html';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ui/api/action_required_api.dart';
import 'package:ui/card/parents_reply_card.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/detail_page_image.dart';
import 'package:ui/model/action_required_model.dart';
import 'package:ui/utils/utils_file.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/Utility.dart';
import '../api/approve_deney_api.dart';

class ActionRequiredPage extends StatefulWidget {
  const ActionRequiredPage({super.key});

  @override
  State<ActionRequiredPage> createState() => _ActionRequiredPageState();
}

class _ActionRequiredPageState extends State<ActionRequiredPage> {
  List<ActionRequiredModel> actionRequired = [];

  @override
  void initState() {
    super.initState();
    getActionRequired();
    initTimer();
  }

  Timer? timer;
  void getActionRequired() async {
    await getActionRequiredList().then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            actionRequired = value;
          });
        }
      }
    });
  }

  void initTimer() {
    const dur = Duration(seconds: 5);
    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(dur, (Timer timer) async {
      await getActionRequiredList().then((value) {
        if (value != null) {
          if (mounted) {
            setState(() {
              actionRequired = value;
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ActionRequired(actionRequired: actionRequired);
  }
}

class ActionRequired extends StatefulWidget {
  ActionRequired({super.key, required this.actionRequired});
  List<ActionRequiredModel> actionRequired;
  @override
  State<ActionRequired> createState() => _ActionRequiredState();

  static fromJson(json) {}
}

class _ActionRequiredState extends State<ActionRequired> {
  AudioPlayer audioPlayer = AudioPlayer();

  Duration duration = const Duration();
  Duration position = const Duration();
  bool playing = false;

  bool isVisible = false;

  bool isDownloading = false;
  @override
  Widget build(BuildContext context) {
    double baseWidth = 1414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.blue.withOpacity(0.2), BlendMode.dstATop),
              image: const AssetImage(Images.bgImage),
              repeat: ImageRepeat.repeat),
        ),
        child: widget.actionRequired.isEmpty
            ? Center(
                child: Text(
                  "All the messages are Accepted",
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${widget.actionRequired.length} NEW MESSAGE REQUESTS",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 500,
                                  childAspectRatio: 1.4,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemCount: widget.actionRequired.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 15, right: 15),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                padding:
                                    const EdgeInsets.only(right: 10, bottom: 5),
                                width: 300,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 55,
                                            child: ListTile(
                                              leading: const CircleAvatar(
                                                radius: 23,
                                                backgroundColor: Colors.white,
                                                backgroundImage: NetworkImage(
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNL_ZnOTpXSvhf1UaK7beHey2BX42U6solRA&usqp=CAU",
                                                ),
                                              ),
                                              title: Text(
                                                widget
                                                    .actionRequired[index].user,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(widget
                                                  .actionRequired[index]
                                                  .designation),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              // group22AbL (7:847)
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem,
                                                  0 * fem,
                                                  3 * fem,
                                                  1 * fem),
                                              width: 10 * fem,
                                              height: 10 * fem,
                                              child: Image.asset(
                                                'assets/images/group-22-MXG.png',
                                                width: 10 * fem,
                                                height: 10 * fem,
                                              ),
                                            ),
                                            Container(
                                              // amouC (7:846)
                                              margin: EdgeInsets.fromLTRB(
                                                  0 * fem,
                                                  1 * fem,
                                                  0 * fem,
                                                  0 * fem),
                                              child: Text(
                                                Utility.convertTimeFormat(widget
                                                    .actionRequired[index]
                                                    .dateTime
                                                    .toString()
                                                    .split(' ')
                                                    .last),
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 10 * ffem,
                                                  fontWeight: FontWeight.w300,
                                                  height:
                                                      0.9152273178 * ffem / fem,
                                                  letterSpacing: 1 * fem,
                                                  color:
                                                      const Color(0xff717171),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            visualDensity: const VisualDensity(
                                                horizontal: 0, vertical: -4),
                                            title: const Text(
                                              "Class",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              widget.actionRequired[index]
                                                  .groupName
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            visualDensity: const VisualDensity(
                                                horizontal: 0, vertical: -4),
                                            title: const Text(
                                              "Message Category",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              widget.actionRequired[index]
                                                  .messageCategory,
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 8),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius: const BorderRadius
                                                    .only(
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15),
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15))),
                                        child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                if (widget.actionRequired[index]
                                                            .messageCategory ==
                                                        'ImageWithCaption' ||
                                                    widget.actionRequired[index]
                                                            .messageCategory ==
                                                        'Images')
                                                  widget.actionRequired[index]
                                                              .images.length ==
                                                          1
                                                      ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (_) {
                                                              return DetailScreen(
                                                                  dateTime: widget
                                                                      .actionRequired[
                                                                          index]
                                                                      .dateTime,
                                                                  title: widget
                                                                      .actionRequired[
                                                                          index]
                                                                      .staffName!,
                                                                  index: index,
                                                                  images: widget
                                                                      .actionRequired[
                                                                          index]
                                                                      .images
                                                                      .toList());
                                                            }));
                                                          },
                                                          child: Container(
                                                            height: 90,
                                                            decoration:
                                                                BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: NetworkImage(widget
                                                                              .actionRequired[index]
                                                                              .images[0]
                                                                              .contains("https://")
                                                                          ? widget.actionRequired[index].images[0]
                                                                          : widget.actionRequired[index].images[0].contains("http://")
                                                                              ? widget.actionRequired[index].images[0]
                                                                              //data.images.toString()
                                                                              : "http://${widget.actionRequired[index].images[0]}"),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            7)),
                                                          ),
                                                          //  Image(
                                                          //   image: NetworkImage(widget
                                                          //           .actionRequired[
                                                          //               index]
                                                          //           .images[0]
                                                          //           .contains(
                                                          //               "https://")
                                                          //       ? widget
                                                          //           .actionRequired[
                                                          //               index]
                                                          //           .images[0]
                                                          //       : widget
                                                          //               .actionRequired[
                                                          //                   index]
                                                          //               .images[0]
                                                          //               .contains(
                                                          //                   "http://")
                                                          //           ? widget
                                                          //               .actionRequired[
                                                          //                   index]
                                                          //               .images[0]
                                                          //           //data.images.toString()
                                                          //           : "http://${widget.actionRequired[index].images[0]}"),
                                                          // ),
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            SizedBox(
                                                              height: 90,
                                                              child: GridView
                                                                  .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                                          maxCrossAxisExtent:
                                                                              200,
                                                                          childAspectRatio:
                                                                              1.4,
                                                                          crossAxisSpacing:
                                                                              5,
                                                                          mainAxisSpacing:
                                                                              5),
                                                                      itemCount: widget
                                                                          .actionRequired[
                                                                              index]
                                                                          .images
                                                                          .length,
                                                                      itemBuilder:
                                                                          (BuildContext ctx,
                                                                              imgIndex) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(context,
                                                                                MaterialPageRoute(builder: (_) {
                                                                              return DetailScreen(dateTime: widget.actionRequired[index].dateTime, title: widget.actionRequired[index].staffName!, index: index, images: widget.actionRequired[index].images.toList());
                                                                            }));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration: BoxDecoration(
                                                                                image: DecorationImage(
                                                                                    fit: BoxFit.cover,
                                                                                    image: NetworkImage(widget.actionRequired[index].images[imgIndex].contains("https://")
                                                                                        ? widget.actionRequired[index].images[imgIndex]
                                                                                        : widget.actionRequired[index].images[imgIndex].contains("http://")
                                                                                            ? widget.actionRequired[index].images[imgIndex]
                                                                                            //data.images.toString()
                                                                                            : "http://${widget.actionRequired[index].images[imgIndex]}")),
                                                                                borderRadius: BorderRadius.circular(7)),
                                                                          ),
                                                                        );
                                                                      }),
                                                            ),
                                                            widget.actionRequired[index]
                                                                        .caption ==
                                                                    ''
                                                                ? Container()
                                                                : Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                    child: Text(
                                                                      widget.actionRequired[index]
                                                                              .caption ??
                                                                          '',
                                                                      style:
                                                                          SafeGoogleFont(
                                                                        'Inter',
                                                                        fontSize:
                                                                            16 *
                                                                                ffem,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        height: 1.2125 *
                                                                            ffem /
                                                                            fem,
                                                                        color: const Color(
                                                                            0xff620d00),
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                if (widget.actionRequired[index]
                                                        .messageCategory ==
                                                    'Text')
                                                  Text(
                                                    widget.actionRequired[index]
                                                        .message,
                                                    style: SafeGoogleFont(
                                                      'Inter',
                                                      fontSize: 16 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height:
                                                          1.2125 * ffem / fem,
                                                      color: const Color(
                                                          0xff620d00),
                                                    ),
                                                  ),
                                                if (widget.actionRequired[index]
                                                        .messageCategory ==
                                                    'Video')
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          HapticFeedback
                                                              .vibrate();
                                                          launchUrl(
                                                              Uri.parse(widget
                                                                  .actionRequired[
                                                                      index]
                                                                  .message),
                                                              mode: LaunchMode
                                                                  .externalApplication);
                                                        },
                                                        child: Text(
                                                          widget
                                                              .actionRequired[
                                                                  index]
                                                              .message,
                                                          style: SafeGoogleFont(
                                                            'Inter',
                                                            fontSize: 16 * ffem,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.2125 *
                                                                ffem /
                                                                fem,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      widget.actionRequired[index]
                                                                  .caption ==
                                                              ''
                                                          ? Container()
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 5),
                                                              child: Text(
                                                                widget
                                                                        .actionRequired[
                                                                            index]
                                                                        .caption ??
                                                                    '',
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
                                                                  color: const Color(
                                                                      0xff620d00),
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                if (widget.actionRequired[index]
                                                            .messageCategory ==
                                                        'Document' ||
                                                    widget.actionRequired[index]
                                                            .messageCategory ==
                                                        'StudyMaterial')
                                                  widget.actionRequired[index]
                                                              .images.length ==
                                                          1
                                                      ? Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Image.network(
                                                                  "https://cdn-icons-png.flaticon.com/128/1548/1548204.png",
                                                                  width: 60,
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    openFile(
                                                                        url: widget
                                                                            .actionRequired[index]
                                                                            .images[0],
                                                                        fileName: '${widget.actionRequired[index].images[0].replaceAll('http://uatliteapi.timetoschool.com/uploads/', '')}.pdf');
                                                                    isDownloading =
                                                                        true;
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      !isDownloading
                                                                          ? Text(
                                                                              "Download",
                                                                              style: SafeGoogleFont(
                                                                                'Inter',
                                                                                fontSize: 14 * ffem,
                                                                                fontWeight: FontWeight.w400,
                                                                                height: 1.2125 * ffem / fem,
                                                                                decoration: TextDecoration.underline,
                                                                                color: Colors.green,
                                                                              ),
                                                                            )
                                                                          : Text(
                                                                              "Downloading",
                                                                              style: SafeGoogleFont(
                                                                                'Inter',
                                                                                fontSize: 14 * ffem,
                                                                                fontWeight: FontWeight.w400,
                                                                                height: 1.2125 * ffem / fem,
                                                                                decoration: TextDecoration.underline,
                                                                                color: Colors.green,
                                                                              ),
                                                                            ),
                                                                      !isDownloading
                                                                          ? const Icon(
                                                                              Icons.download,
                                                                              size: 15,
                                                                              color: Colors.green,
                                                                            )
                                                                          : const SizedBox(
                                                                              height: 10.0,
                                                                              width: 10.0,
                                                                              child: CircularProgressIndicator(
                                                                                strokeWidth: 1,
                                                                                color: Colors.green,
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            widget.actionRequired[index]
                                                                        .caption ==
                                                                    ''
                                                                ? Container()
                                                                : Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                    child: Text(
                                                                      widget.actionRequired[index]
                                                                              .caption ??
                                                                          '',
                                                                      style:
                                                                          SafeGoogleFont(
                                                                        'Inter',
                                                                        fontSize:
                                                                            16 *
                                                                                ffem,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        height: 1.2125 *
                                                                            ffem /
                                                                            fem,
                                                                        color: const Color(
                                                                            0xff620d00),
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ],
                                                        )
                                                      : Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  height: 90,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.12,
                                                                  child: GridView
                                                                      .builder(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    shrinkWrap:
                                                                        true,
                                                                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                                        maxCrossAxisExtent:
                                                                            150,
                                                                        childAspectRatio:
                                                                            1.0,
                                                                        crossAxisSpacing:
                                                                            5,
                                                                        mainAxisSpacing:
                                                                            5),
                                                                    itemCount: widget
                                                                        .actionRequired[
                                                                            index]
                                                                        .images
                                                                        .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                ctx,
                                                                            index) {
                                                                      return Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Image
                                                                              .network(
                                                                            "https://cdn-icons-png.flaticon.com/128/1548/1548204.png",
                                                                            width:
                                                                                60,
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              openFile(url: widget.actionRequired[index].images[index], fileName: '${widget.actionRequired[index].images[index].replaceAll('http://uatliteapi.timetoschool.com/uploads/', '')}.pdf');
                                                                              isDownloading = true;
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                !isDownloading
                                                                                    ? Text(
                                                                                        "Download",
                                                                                        style: SafeGoogleFont(
                                                                                          'Inter',
                                                                                          fontSize: 14 * ffem,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          height: 1.2125 * ffem / fem,
                                                                                          decoration: TextDecoration.underline,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                      )
                                                                                    : Text(
                                                                                        "Downloading",
                                                                                        style: SafeGoogleFont(
                                                                                          'Inter',
                                                                                          fontSize: 14 * ffem,
                                                                                          fontWeight: FontWeight.w400,
                                                                                          height: 1.2125 * ffem / fem,
                                                                                          decoration: TextDecoration.underline,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                      ),
                                                                                !isDownloading
                                                                                    ? const Icon(
                                                                                        Icons.download,
                                                                                        size: 15,
                                                                                        color: Colors.green,
                                                                                      )
                                                                                    : const SizedBox(
                                                                                        height: 10.0,
                                                                                        width: 10.0,
                                                                                        child: CircularProgressIndicator(
                                                                                          strokeWidth: 1,
                                                                                          color: Colors.green,
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
                                                                widget.actionRequired[index]
                                                                            .caption ==
                                                                        ''
                                                                    ? Container()
                                                                    : Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 5),
                                                                        child:
                                                                            Text(
                                                                          widget.actionRequired[index].caption ??
                                                                              '',
                                                                          style:
                                                                              SafeGoogleFont(
                                                                            'Inter',
                                                                            fontSize:
                                                                                16 * ffem,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height: 1.2125 *
                                                                                ffem /
                                                                                fem,
                                                                            color:
                                                                                const Color(0xff620d00),
                                                                          ),
                                                                        ),
                                                                      ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                if (widget.actionRequired[index]
                                                        .messageCategory ==
                                                    'Audio')
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () async {
                                                          var url =
                                                              // "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
                                                              widget
                                                                      .actionRequired[
                                                                          index]
                                                                      .images[0]
                                                                      .contains(
                                                                          "https://")
                                                                  ? widget
                                                                      .actionRequired[
                                                                          index]
                                                                      .images[0]
                                                                  : widget
                                                                          .actionRequired[
                                                                              index]
                                                                          .images[
                                                                              0]
                                                                          .contains(
                                                                              "http://")
                                                                      ? widget
                                                                          .actionRequired[
                                                                              index]
                                                                          .images[0]
                                                                      : "https://${widget.actionRequired[index].images[0]}";
                                                          print(url);
                                                          setState(() {
                                                            playing = !playing;
                                                          });
                                                          if (playing) {
                                                            // var res = await audioPlayer.pause();
                                                            // if (res == 1) {
                                                            //   setState(() {
                                                            //     playing = false;
                                                            //   });
                                                            // }
                                                            var res =
                                                                await audioPlayer
                                                                    .play(url);
                                                            if (res == 1) {
                                                              setState(() {
                                                                playing = true;
                                                              });
                                                            }
                                                          } else {
                                                            // var res = await audioPlayer.play(url);
                                                            // if (res == 1) {
                                                            //   setState(() {
                                                            //     playing = true;
                                                            //   });
                                                            // }
                                                            var res =
                                                                await audioPlayer
                                                                    .pause();
                                                            if (res == 1) {
                                                              setState(() {
                                                                playing = false;
                                                              });
                                                            }
                                                          }
                                                          audioPlayer
                                                              .onDurationChanged
                                                              .listen((Duration
                                                                  dd) {
                                                            setState(() {
                                                              duration = dd;
                                                            });
                                                          });
                                                          audioPlayer
                                                              .onAudioPositionChanged
                                                              .listen((Duration
                                                                  dd) {
                                                            setState(() {
                                                              position = dd;
                                                            });
                                                          });
                                                          // getAudio();
                                                          // String filePath =
                                                          //     "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
                                                          // widget.data.images
                                                          //     .toString()
                                                          //     .split('/')
                                                          //     .last;
                                                          //audioPlayerState == PlayerState.PLAYING
                                                          // playing == false
                                                          //     ? pauseMusic()
                                                          //     : playLocal(filePath);
                                                        },
                                                        icon: Icon(
                                                            // audioPlayerState == PlayerState.PLAYING
                                                            playing == true
                                                                ? Icons.pause
                                                                : Icons
                                                                    .play_arrow),
                                                      ),
                                                      slider(),
                                                      // Slider(
                                                      //     activeColor: const Color(0xfffab51a),
                                                      //     inactiveColor: Colors.black,
                                                      //     value: _position.inSeconds.toDouble(),
                                                      //     min: 0.0,
                                                      //     max: _duration.inSeconds.toDouble(),
                                                      //     onChanged: (double value) {
                                                      //       setState(() {
                                                      //         seekToSecond(value.toInt());
                                                      //         value = value;
                                                      //       });
                                                      //     }),
                                                    ],
                                                  ),
                                              ],
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 5),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 40,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .red)),
                                                    onPressed: () async {
                                                      await aproveDeny(
                                                              aproval: '2',
                                                              notifyid: widget
                                                                  .actionRequired[
                                                                      index]
                                                                  .notificationId
                                                                  .toString())
                                                          .then((value) {
                                                        if (value != null) {
                                                          Utility.displaySnackBar(
                                                              context,
                                                              "Message Denied Successfully");
                                                        } else {
                                                          Utility.displaySnackBar(
                                                              context,
                                                              "Error Denying");
                                                        }
                                                      });
                                                      await getActionRequiredList()
                                                          .then((value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            widget.actionRequired =
                                                                value;
                                                          });
                                                        }
                                                      });
                                                    },
                                                    child: const Text(
                                                      "Decline",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    )),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                height: 40,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .green)),
                                                    onPressed: () async {
                                                      await aproveDeny(
                                                              aproval: '1',
                                                              notifyid: widget
                                                                  .actionRequired[
                                                                      index]
                                                                  .notificationId
                                                                  .toString())
                                                          .then((value) {
                                                        if (value != null) {
                                                          Utility.displaySnackBar(
                                                              context,
                                                              "Message Approved Successfully");
                                                        } else {
                                                          Utility.displaySnackBar(
                                                              context,
                                                              "Error Denying");
                                                        }
                                                      });
                                                      await getActionRequiredList()
                                                          .then((value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            widget.actionRequired =
                                                                value;
                                                          });
                                                        }
                                                      });
                                                    },
                                                    child: const Text(
                                                      "Accept",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    )),
                                              ),
                                            )
                                          ]),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget slider() => Slider.adaptive(
      min: 0.0,
      value: position.inSeconds.toDouble(),
      max: duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          audioPlayer.seek(Duration(seconds: value.toInt()));
        });
      });

  Future openFile({required String url, required String fileName}) async {
    AnchorElement anchorElement = AnchorElement(href: url);
    anchorElement.download = fileName;
    anchorElement.click();
    // final file = await downloadFile(url, fileName);
    // if (file == null) return;
    // setState(() {
    //   isDownloading = false;
    // });
    // OpenFile.open(file.path);
  }

  // Future<File?> downloadFile(String url, String name) async {
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final file = File('${appStorage.path}/$name');
  //   try {
  //     final response = await Dio().get(url,
  //         options: Options(
  //           responseType: ResponseType.bytes,
  //         ));
  //     final raf = file.openSync(mode: FileMode.write);
  //     raf.writeFromSync(response.data);
  //     await raf.close();
  //     return file;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error: $e');
  //     }
  //     return null;
  //   }
  // }
}

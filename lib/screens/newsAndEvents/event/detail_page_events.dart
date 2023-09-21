// ignore_for_file: must_be_immutable, deprecated_member_use
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:ui/api/news&events/event_accept_decline_api.dart';
import 'package:ui/api/news&events/single_news_event.dart';
import 'package:ui/custom/detail_page_image.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../Utils/utility.dart';
import '../../../model/news&events/events_feed_model.dart';

class DetailsPageEvents extends StatefulWidget {
  DetailsPageEvents({super.key, required this.eventFeed, required this.isPast});
  UpcomingEvent eventFeed;
  bool isPast;

  @override
  State<DetailsPageEvents> createState() => _DetailsPageEventsState();
}

class _DetailsPageEventsState extends State<DetailsPageEvents> {
  bool isAccepted = false;
  bool isDeclined = false;
  bool isLoading = false;

  void getIndividualEvent() async {
    isLoading = true;
    await getSingleEvent(widget.eventFeed.id.toString()).then((value) {
      setState(() {
        widget.eventFeed = value!;
        switch (widget.eventFeed.acceptStatus) {
          case 1:
            {
              isAccepted = true;
              isDeclined = false;
            }
            break;
          case 2:
            {
              isDeclined = true;
              isAccepted = false;
            }
            break;
          case 0:
            {
              isAccepted = false;
              isDeclined = false;
            }
        }
      });
    });
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    getIndividualEvent();
  }

  bool playVideo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? LoadingAnimator()
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                      image: const AssetImage("assets/images/bg_image_tes.jpg"),
                      fit: BoxFit.fill,
                    )),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        height: 350,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.eventFeed.images[0]),
                                fit: BoxFit.cover)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50, left: 10),
                          child: CircleAvatar(
                            backgroundColor: Colors.white70,
                            child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.eventFeed.title,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              widget.isPast
                                                  ? Colors.red.shade100
                                                  : Colors.red),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ))),
                                  onPressed: widget.isPast
                                      ? () {
                                          Utility.displaySnackBar(context,
                                              "Can't Decline the event after the event end");
                                        }
                                      : () {
                                          eventAcceptDecline(
                                                  id: widget.eventFeed.id
                                                      .toString(),
                                                  status: '2')
                                              .then((value) {
                                            getIndividualEvent();
                                            !isDeclined
                                                ? Utility.displaySnackBar(
                                                    context,
                                                    "Event Declined Successfully")
                                                : null;
                                          });
                                        },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isDeclined
                                          ? const Icon(
                                              Icons.thumb_down_alt,
                                              size: 20,
                                              color: Colors.white,
                                            )
                                          : const Icon(
                                              Icons.thumb_down_alt_outlined,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        widget.eventFeed.declined == 0
                                            ? "Declined"
                                            : "Declined (${widget.eventFeed.declined.toString()})",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              widget.isPast
                                                  ? Colors.green.shade100
                                                  : Colors.green),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ))),
                                  onPressed: widget.isPast
                                      ? () {
                                          Utility.displaySnackBar(context,
                                              "Can't Accept the event after the event end");
                                        }
                                      : () {
                                          eventAcceptDecline(
                                                  id: widget.eventFeed.id
                                                      .toString(),
                                                  status: '1')
                                              .then((value) {
                                            getIndividualEvent();
                                          });
                                          isAccepted
                                              ? null
                                              : Utility.displaySnackBar(context,
                                                  "Event Accepted Successfully");
                                        },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isAccepted
                                          ? const Icon(
                                              Icons.thumb_up_alt,
                                              size: 20,
                                              color: Colors.white,
                                            )
                                          : const Icon(
                                              Icons.thumb_up_alt_outlined,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        widget.eventFeed.accepted == 0
                                            ? "Accepted"
                                            : "Accepted(${widget.eventFeed.accepted.toString()})",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // IconButton(
                            //     padding: const EdgeInsets.all(5),
                            //     constraints: const BoxConstraints(),
                            //     onPressed: () async {
                            //       List<String> paths = [];
                            //       var path = '';
                            //       HapticFeedback.vibrate();
                            //       for (int i = 0;
                            //           i < widget.eventFeed.images.length;
                            //           i++) {
                            //         final url =
                            //             Uri.parse(widget.eventFeed.images[i]);
                            //         final response = await http.get(url);
                            //         final bytes = response.bodyBytes;
                            //         final temp = await getTemporaryDirectory();
                            //         path = '${temp.path}/Image$i.jpg';
                            //         paths.add(path);
                            //         File(paths[i]).writeAsBytes(bytes);
                            //       }
                            //       await Share.shareFiles(paths,
                            //           text: widget.eventFeed.description == ''
                            //               ? "Title: ${widget.eventFeed.title}"
                            //               : "Title: ${widget.eventFeed.title} \nDescription:${widget.eventFeed.description}");
                            //     },
                            //     icon: const Icon(
                            //       Icons.share,
                            //     )),
                            PopupMenuButton<int>(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 5, right: 10, bottom: 5),
                              icon: const Icon(
                                Icons.share,
                                size: 27,
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () async {
                                    List<String> paths = [];
                                    var path = '';
                                    setState(() {
                                      path = '';
                                      paths.clear();
                                    });
                                    HapticFeedback.vibrate();
                                    for (int i = 0;
                                        i < widget.eventFeed.images.length;
                                        i++) {
                                      final url =
                                          Uri.parse(widget.eventFeed.images[i]);
                                      final response = await http.get(url);
                                      final bytes = response.bodyBytes;
                                      final temp =
                                          await getTemporaryDirectory();
                                      path = '${temp.path}/Image$i.jpg';
                                      paths.add(path);
                                      File(paths[i]).writeAsBytes(bytes);
                                    }
                                    await Share.shareFiles(
                                      paths,
                                    );
                                  },
                                  value: 1,
                                  child: const Text("Send All Image"),
                                ),
                                PopupMenuItem(
                                  onTap: () async {
                                    List<String> paths = [];
                                    var path = '';
                                    setState(() {
                                      path = '';
                                      paths.clear();
                                    });
                                    HapticFeedback.vibrate();
                                    final url =
                                        Uri.parse(widget.eventFeed.images[0]);
                                    final response = await http.get(url);
                                    final bytes = response.bodyBytes;
                                    final temp = await getTemporaryDirectory();
                                    path = '${temp.path}/Image.jpg';
                                    paths.add(path);
                                    File(path).writeAsBytes(bytes);

                                    await Share.shareFiles(paths,
                                        text: widget.eventFeed.description == ''
                                            ? "Title: ${widget.eventFeed.title}"
                                            : "Title: ${widget.eventFeed.title} \nDescription:${widget.eventFeed.description}");
                                  },
                                  value: 2,
                                  child: const Text("Send Content"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (widget.eventFeed.description != '')
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            widget.eventFeed.description.toString(),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      widget.eventFeed.images.length >= 2
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: CarouselSlider.builder(
                                  itemCount: widget.eventFeed.images.length,
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    viewportFraction: 0.8,
                                    // enableInfiniteScroll: false,
                                    aspectRatio: 2.0,
                                  ),
                                  itemBuilder: (BuildContext context,
                                          int itemIndex, int pageViewIndex) =>
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailScreen(
                                                          index: itemIndex,
                                                          images: widget
                                                              .eventFeed
                                                              .images)));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(widget
                                                    .eventFeed
                                                    .images[itemIndex])),
                                          ),
                                        ),
                                      )),
                            )
                          : Container(),
                      if (widget.eventFeed.youtubeLink != '')
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 10, right: 10),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return YoutubePlayer(
                                          controller: YoutubePlayerController(
                                            initialVideoId:
                                                "${YoutubePlayer.convertUrlToId(widget.eventFeed.youtubeLink)}",
                                            flags: const YoutubePlayerFlags(
                                              enableCaption: true,
                                              captionLanguage: 'en',
                                            ),
                                          ),
                                          liveUIColor: Colors.amber,
                                          showVideoProgressIndicator: true,
                                          bottomActions: [
                                            CurrentPosition(),
                                            ProgressBar(
                                              isExpanded: true,
                                            ),
                                            const PlaybackSpeedButton()
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(widget.eventFeed.youtubeLink)}/0.jpg'),
                                            fit: BoxFit.cover),
                                      ),
                                      child: const Icon(
                                        Icons.play_circle_filled,
                                        color: Colors.white,
                                        size: 60.0,
                                      )),
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  launchUrl(
                                      Uri.parse(widget.eventFeed.youtubeLink),
                                      mode: LaunchMode.externalApplication);
                                },
                                child: const Text(
                                    "Click to play the video on YouTube"))
                          ],
                        )
                    ],
                  ),
                ),
              ));
  }
}

// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:ui/Utils/Utility.dart';
import 'package:ui/api/news&events/like_dislike_api.dart';
import 'package:ui/api/news&events/single_news_event.dart';
import 'package:ui/custom/detail_page_image.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/news&events/news_feed_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailsPageNews extends StatefulWidget {
  DetailsPageNews({super.key, required this.newsFeed});
  Latest newsFeed;

  @override
  State<DetailsPageNews> createState() => _DetailsPageNewsState();
}

class _DetailsPageNewsState extends State<DetailsPageNews> {
  bool isFav = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getNewsIndividual();
  }

  void getNewsIndividual() async {
    isLoading = true;
    await getSingleNews(widget.newsFeed.id.toString()).then((value) {
      setState(() {
        widget.newsFeed = value!;
        isFav = widget.newsFeed.like;
      });
    });
    isLoading = false;
  }

  void getIndividualNews() async {
    await getSingleNews(widget.newsFeed.id.toString()).then((value) {
      setState(() {
        widget.newsFeed = value!;
        isFav = widget.newsFeed.like;
      });
    });
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
                              image: NetworkImage(
                                widget.newsFeed.images[0],
                              ),
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
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        widget.newsFeed.title,
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: Container()),
                          Row(
                            children: [
                              IconButton(
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 5, right: 10, bottom: 5),
                                  constraints: const BoxConstraints(),
                                  onPressed: isFav
                                      ? () {
                                          HapticFeedback.vibrate();
                                          likeDislikeNews(
                                                  id: widget.newsFeed.id
                                                      .toString(),
                                                  status: '2')
                                              .then(
                                            (value) {
                                              getIndividualNews();
                                              setState(() {
                                                isFav = !isFav;
                                              });
                                            },
                                          );
                                          Utility.displaySnackBar(context,
                                              "News Disliked Successfully");
                                        }
                                      : () {
                                          HapticFeedback.vibrate();
                                          likeDislikeNews(
                                                  id: widget.newsFeed.id
                                                      .toString(),
                                                  status: '1')
                                              .then(
                                            (value) {
                                              getIndividualNews();
                                              setState(() {
                                                isFav = !isFav;
                                              });
                                            },
                                          );
                                          Utility.displaySnackBar(context,
                                              "Like added Successfully for News");
                                        },
                                  icon: isFav
                                      ? const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 30,
                                        )
                                      : const Icon(
                                          Icons.favorite_border,
                                          size: 30,
                                        )),
                              if (widget.newsFeed.totalLike != 0)
                                Text(
                                  " ${widget.newsFeed.totalLike.toString()} ${widget.newsFeed.totalLike == 1 ? 'like' : "likes"}",
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        height: 1.6),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            children: [
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
                                          i < widget.newsFeed.images.length;
                                          i++) {
                                        final url = Uri.parse(
                                            widget.newsFeed.images[i]);
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
                                          Uri.parse(widget.newsFeed.images[0]);
                                      final response = await http.get(url);
                                      final bytes = response.bodyBytes;
                                      final temp =
                                          await getTemporaryDirectory();
                                      path = '${temp.path}/Image.jpg';
                                      paths.add(path);
                                      File(path).writeAsBytes(bytes);

                                      await Share.shareFiles(paths,
                                          text: widget.newsFeed.description ==
                                                  ''
                                              ? "Title: ${widget.newsFeed.title}"
                                              : "Title: ${widget.newsFeed.title} \nDescription:${widget.newsFeed.description}");
                                    },
                                    value: 2,
                                    child: const Text("Send Content"),
                                  ),
                                ],
                              ),
                              Text(
                                "Share",
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      height: 1.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.newsFeed.description != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Text(
                          widget.newsFeed.description.toString(),
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    widget.newsFeed.newsEventsCategory == 4 ||
                            widget.newsFeed.newsEventsCategory == 5
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width,
                            child: CarouselSlider.builder(
                                itemCount: widget.newsFeed.images.length,
                                options: CarouselOptions(
                                  autoPlay: true,
                                  viewportFraction: 0.8,
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
                                                            .newsFeed.images)));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(widget
                                                  .newsFeed.images[itemIndex])),
                                        ),
                                      ),
                                    )),
                          )
                        : Container(),
                    if (widget.newsFeed.addonDescription != null)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.newsFeed.addonDescription.toString(),
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    if (widget.newsFeed.youtubeLink != '')
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
                                  // setState(() {
                                  //   playVideo = !playVideo;
                                  // });
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return YoutubePlayer(
                                        controller: YoutubePlayerController(
                                          initialVideoId:
                                              "${YoutubePlayer.convertUrlToId(widget.newsFeed.youtubeLink)}",
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
                                              'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(widget.newsFeed.youtubeLink)}/0.jpg'),
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
                                    Uri.parse(widget.newsFeed.youtubeLink),
                                    mode: LaunchMode.externalApplication);
                              },
                              child: const Text(
                                  "Click to play the video on YouTube"))
                        ],
                      )
                  ],
                ),
              ),
            ),
    );
  }
}

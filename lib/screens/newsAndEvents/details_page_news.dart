// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/Utils/Utility.dart';
import 'package:ui/api/news&events/like_dislike_api.dart';
import 'package:ui/custom/detail_page_image.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/news&events/news_data_model.dart';
import 'package:ui/model/news&events/single_news_events_model.dart';
import 'package:ui/screens/newsAndEvents/news/add_news_form.dart';
import 'package:ui/utils/session_management.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/news&events/single_news_event.dart';

class DetailsPageNews extends StatefulWidget {
  DetailsPageNews(
      {super.key,
      required this.newsId,
      required this.accessiblePerson,
      required this.callBack});
  String newsId;
  bool accessiblePerson;
  Function callBack;

  @override
  State<DetailsPageNews> createState() => _DetailsPageNewsState();
}

class _DetailsPageNewsState extends State<DetailsPageNews> {
  bool isFav = false;
  bool isLoading = false;
  late SingleNewsEvents newsFeed;
  List<String> images = [];
  @override
  void initState() {
    super.initState();
    getNewsIndividual();
    getRole();
  }

  String userRole = '';

  Future getRole() async {
    var role = await SessionManager().getRole();
    setState(() {
      userRole = role.toUpperCase();
      if (userRole == 'MANAGEMENT' || userRole == 'ADMIN') {
        widget.accessiblePerson = true;
      }
    });
  }

  void getNewsIndividual() async {
    isLoading = true;
    await getSingleNews(widget.newsId).then((value) {
      setState(() {
        images.clear();
        newsFeed = value!;
        isFav = newsFeed.like;
        for (int i = 0; i < value.images.length; i++) {
          images.add(value.images[i].image);
        }
      });
    });
    isLoading = false;
  }

  String getUrlYt(url) {
    var videoId = '';
    const String regex =
        r"(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([^#&?]*).*";
    final match = RegExp(regex).firstMatch(url);
    if (match != null) {
      videoId = match.group(1)!;
    } else {
      print("Invalid YouTube URL");
    }
    return videoId;
  }

  void getIndividualNews() async {
    await getSingleNews(newsFeed.id.toString()).then((value) {
      setState(() {
        newsFeed = value!;
        isFav = newsFeed.like;
      });
    });
  }

  bool playVideo = false;

  Future<bool> goBack() async {
    Navigator.pop(context, true);
    return true;
  }

  int itemIndex = 0;

  Future<bool> editNews() async {
    return await showDialog(
            context: context,
            builder: (context) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: AddNewsForm(
                        callback: getNewsIndividual,
                        newsEventsData: NewsEventsData(
                            newsFeed.title,
                            newsFeed.description,
                            newsFeed.youtubeLink,
                            newsFeed.images,
                            newsFeed.visibility,
                            newsFeed.id.toString()),
                      ),
                    ),
                  ),
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                image: const AssetImage("assets/images/bg_image_tes.jpg"),
                repeat: ImageRepeat.repeatX)),
        child: isLoading
            ? Center(child: LoadingAnimator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                newsFeed.images[0].image,
                              ),
                              fit: BoxFit.cover)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: IconButton(
                              onPressed: () {
                                widget.callBack();
                              },
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
                        newsFeed.title,
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
                                  onPressed: () => editNews(),
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 5, right: 10, bottom: 5),
                                  constraints: const BoxConstraints(),
                                  onPressed: isFav
                                      ? () {
                                          HapticFeedback.vibrate();
                                          likeDislikeNews(
                                                  id: newsFeed.id.toString(),
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
                                                  id: newsFeed.id.toString(),
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
                              if (newsFeed.totalLike != 0)
                                Text(
                                  " ${newsFeed.totalLike.toString()} ${newsFeed.totalLike == 1 ? 'like' : "likes"}",
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        height: 1.6),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                    if (newsFeed.description != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Text(
                          newsFeed.description.toString(),
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    newsFeed.newsEventsCategory == 4 ||
                            newsFeed.newsEventsCategory == 5
                        ? Stack(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                                  index: itemIndex,
                                                  images: images,
                                                  dateTime: newsFeed.dateTime,
                                                  title: newsFeed.user,
                                                )));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                              NetworkImage(images[itemIndex])),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.15,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white70,
                                  child: IconButton(
                                      onPressed: itemIndex >=
                                              newsFeed.images.length - 1
                                          ? null
                                          : () {
                                              setState(() {
                                                itemIndex++;
                                              });
                                            },
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: MediaQuery.of(context).size.height * 0.17,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white70,
                                  child: IconButton(
                                      onPressed: itemIndex == 0
                                          ? null
                                          : () {
                                              setState(() {
                                                itemIndex--;
                                              });
                                            },
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new,
                                        color: Colors.black,
                                      )),
                                ),
                              )
                            ],
                          )
                        : Container(),
                    if (newsFeed.addonDescription != null)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          newsFeed.addonDescription.toString(),
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    if (newsFeed.youtubeLink != '')
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
                                  launchUrl(Uri.parse(newsFeed.youtubeLink),
                                      mode: LaunchMode.externalApplication);
                                },
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://img.youtube.com/vi/${getUrlYt(newsFeed.youtubeLink)}/0.jpg"),
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
                                launchUrl(Uri.parse(newsFeed.youtubeLink),
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

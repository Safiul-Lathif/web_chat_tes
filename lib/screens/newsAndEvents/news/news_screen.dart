// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'dart:async';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/Utils/Utility.dart';
import 'package:ui/api/news&events/delete_news_api.dart';
import 'package:ui/api/news&events/news_feed_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/news&events/news_feed_model.dart';
import 'package:ui/screens/newsAndEvents/news/add_news_form.dart';
import '../details_page_news.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen(
      {super.key, required this.accessiblePerson, required this.studentId});
  bool accessiblePerson;
  String studentId;

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final ScrollController newsController = ScrollController();

  NewsFeedMain? newsFeed;

  List<Latest> oldNews = [];
  List<Latest> newsList = [];

  bool isLoading = true;
  bool isDetailScreen = false;
  int pageNumber = 1;
  int totalCount = 0;
  String newsIds = '';
  String url = 'data';
  int? selectedIndex;
  bool isPageSelected = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    newsController.addListener(() {
      if (newsController.position.pixels ==
          newsController.position.maxScrollExtent) {
        if (url != '') {
          if (pageNumber != 0) {
            _loadNextPage();
          }
        }
      }
    });
    await getNewsFeed(studentId: widget.studentId, pageNumber: pageNumber)
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            if (pageNumber == 1) {
              newsFeed = value;
            }
            newsList.addAll(value.old.data);
            oldNews = newsList;
            totalCount = value.old.total;
            url = value.old.nextPageUrl;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void updateLatestNews() {
    setState(() {
      pageNumber = 1;
      newsList.clear();
      initialize();
    });
  }

  void _loadNextPage() {
    setState(() {
      isLoading = true;
      pageNumber++;
    });
    initialize();
  }

  void navigateToDetailsPage(
      {required String newsId,
      required bool accessiblePerson,
      required int index}) {
    setState(() {
      isPageSelected = false;
      newsIds = newsId;
      isDetailScreen = true;
      selectedIndex = index;
    });
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        isPageSelected = true;
      });
    });
  }

  void onBackDetailsPage() {
    setState(() {
      isDetailScreen = false;
    });
  }

  Future<bool> createNewsForm() async {
    return await showDialog(
            context: context,
            builder: (context) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: AddNewsForm(
                        callback: updateLatestNews,
                      ),
                    ),
                  ),
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return isDetailScreen
        ? Row(
            children: [
              Expanded(
                  child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.blue.withOpacity(0.4), BlendMode.dstATop),
                      image: const AssetImage(Images.bgImage),
                      fit: BoxFit.cover,
                    )),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  controller: newsController,
                  itemCount: 1,
                  itemExtent: 200,
                  itemBuilder: (context, index) {
                    if (selectedIndex == -1) {
                      return Container(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onLongPress: widget.accessiblePerson
                              ? () {
                                  deleteNewsAlert(
                                      newsFeed!.latest.id.toString());
                                }
                              : null,
                          onTap: () => navigateToDetailsPage(
                              index: index,
                              newsId: newsFeed!.latest.id.toString(),
                              accessiblePerson: widget.accessiblePerson),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    image: DecorationImage(
                                      colorFilter: ColorFilter.mode(
                                          Colors.blue.withOpacity(0.3),
                                          BlendMode.dstATop),
                                      image: const AssetImage(
                                          "assets/images/bg_image_tes.jpg"),
                                      fit: BoxFit.fill,
                                    )),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  child: Column(
                                    children: [
                                      newsFeed!.latest.images.isEmpty
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                newsFeed!.latest.title
                                                    .capitalize(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        fontSize: 19,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            )
                                          : Image.network(
                                              newsFeed!.latest.images[0]
                                                      .contains("https://")
                                                  ? newsFeed!.latest.images[0]
                                                  : newsFeed!.latest.images[0]
                                                          .contains("http://")
                                                      ? newsFeed!
                                                          .latest.images[0]
                                                      : "http://${newsFeed!.latest.images[0]}",
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.19,
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                      newsFeed!.latest.images.isEmpty
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                newsFeed!.latest.description
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                newsFeed!.latest.title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 10,
                                  right: 15,
                                  child: Container(
                                    height: 17,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(7),
                                          topRight: Radius.circular(7)),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green.shade900,
                                          Colors.green.shade600,
                                          Colors.green.shade500
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text("Latest",
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8,
                                                  color: Colors.white))),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    }
                    switch (oldNews[selectedIndex!].newsEventsCategory) {
                      case 1:
                        {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: textWidget(selectedIndex!),
                          );
                        }
                      case 2:
                        {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: imageWidget(selectedIndex!),
                          );
                        }
                      case 3:
                        {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: imageWithCaptionWidget(selectedIndex!, 0.2),
                          );
                        }
                      case 4:
                        {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: multiImageWithTitle(selectedIndex!),
                          );
                        }
                      case 5:
                        {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: multiImageWithCaptionWidget(
                                selectedIndex!, 0.2),
                          );
                        }
                    }
                    return Text(
                      oldNews[selectedIndex!].newsEventsCategory.toString(),
                    );
                  },
                ),
              )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: isPageSelected
                    ? DetailsPageNews(
                        accessiblePerson: widget.accessiblePerson,
                        newsId: newsIds,
                        callBack: onBackDetailsPage)
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                    Colors.blue.withOpacity(0.2),
                                    BlendMode.dstATop),
                                image: const AssetImage(Images.bgImage),
                                repeat: ImageRepeat.repeatX)),
                        child: Center(child: LoadingAnimator())),
              )
            ],
          )
        : Scaffold(
            body: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.blue.withOpacity(0.2), BlendMode.dstATop),
                      image: const AssetImage(Images.bgImage),
                      repeat: ImageRepeat.repeatX)),
              child: SingleChildScrollView(
                controller: newsController,
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "News List",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                          ),
                          widget.accessiblePerson
                              ? InkWell(
                                  onTap: () => createNewsForm(),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black45),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Add News Here",
                                            style: TextStyle(
                                                color: Colors.grey.shade800),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.newspaper,
                                              color: Colors.grey.shade800)
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ]),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: oldNews.isEmpty
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Center(child: LoadingAnimator()))
                            : Container(
                                padding: const EdgeInsets.all(10.0),
                                child: MediaQuery.removePadding(
                                  removeTop: true,
                                  context: context,
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount: oldNews.length + 1,
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 350,
                                            childAspectRatio: 0.8,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20),
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return InkWell(
                                          onLongPress: widget.accessiblePerson
                                              ? () {
                                                  deleteNewsAlert(newsFeed!
                                                      .latest.id
                                                      .toString());
                                                }
                                              : null,
                                          onTap: () => navigateToDetailsPage(
                                              index: -1,
                                              newsId: newsFeed!.latest.id
                                                  .toString(),
                                              accessiblePerson:
                                                  widget.accessiblePerson),
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    image: DecorationImage(
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                              Colors.blue
                                                                  .withOpacity(
                                                                      0.3),
                                                              BlendMode
                                                                  .dstATop),
                                                      image: const AssetImage(
                                                          "assets/images/bg_image_tes.jpg"),
                                                      fit: BoxFit.fill,
                                                    )),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(15)),
                                                  child: Column(
                                                    children: [
                                                      newsFeed!.latest.images
                                                              .isEmpty
                                                          ? Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                newsFeed!.latest
                                                                    .title
                                                                    .capitalize(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: GoogleFonts.lato(
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            19,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                            )
                                                          : Image.network(
                                                              newsFeed!.latest
                                                                      .images[0]
                                                                      .contains(
                                                                          "https://")
                                                                  ? newsFeed!
                                                                      .latest
                                                                      .images[0]
                                                                  : newsFeed!
                                                                          .latest
                                                                          .images[
                                                                              0]
                                                                          .contains(
                                                                              "http://")
                                                                      ? newsFeed!
                                                                          .latest
                                                                          .images[0]
                                                                      : "http://${newsFeed!.latest.images[0]}",
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.4,
                                                              fit: BoxFit.cover,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                            ),
                                                      newsFeed!.latest.images
                                                              .isEmpty
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Text(
                                                                newsFeed!.latest
                                                                    .description
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 3,
                                                                style: GoogleFonts.lato(
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white)),
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Text(
                                                                newsFeed!.latest
                                                                    .title,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 3,
                                                                style: GoogleFonts.lato(
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white)),
                                                              ),
                                                            )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  top: 10,
                                                  right: 15,
                                                  child: Container(
                                                    height: 17,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          7),
                                                              topRight: Radius
                                                                  .circular(7)),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.green.shade900,
                                                          Colors.green.shade600,
                                                          Colors.green.shade500
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text("Latest",
                                                          style: GoogleFonts.lato(
                                                              textStyle: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 8,
                                                                  color: Colors
                                                                      .white))),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        );
                                      }

                                      switch (oldNews[index - 1]
                                          .newsEventsCategory) {
                                        case 1:
                                          {
                                            return textWidget(index - 1);
                                          }
                                        case 2:
                                          {
                                            return imageWidget(index - 1);
                                          }
                                        case 3:
                                          {
                                            return imageWithCaptionWidget(
                                                index - 1, 0.4);
                                          }
                                        case 4:
                                          {
                                            return multiImageWithTitle(
                                                index - 1);
                                          }
                                        case 5:
                                          {
                                            return multiImageWithCaptionWidget(
                                                index - 1, 0.4);
                                          }
                                      }
                                      return Text(
                                        oldNews[index - 1]
                                            .newsEventsCategory
                                            .toString(),
                                      );
                                    },
                                  ),
                                ),
                              )),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> deleteNewsAlert(String id) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete News'),
        content: const Text('Do you want to delete this news?'),
        actions: [
          ElevatedButton(
            style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                backgroundColor: MaterialStatePropertyAll(Colors.purple)),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                backgroundColor: MaterialStatePropertyAll(Colors.purple)),
            onPressed: () async {
              await deleteNews(id: id);
              initialize();
              navigation('News Deleted Successfully');
              Navigator.of(context).pop(false);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void navigation(String message) {
    Utility.displaySnackBar(context, message);
  }

  InkWell imageWithCaptionWidget(int index, double height) {
    return InkWell(
      onLongPress: widget.accessiblePerson
          ? () {
              deleteNewsAlert(oldNews[index].id.toString());
            }
          : null,
      onTap: () => navigateToDetailsPage(
          index: index,
          newsId: oldNews[index].id.toString(),
          accessiblePerson: widget.accessiblePerson),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                image: const AssetImage("assets/images/bg_image_tes.jpg"),
                fit: BoxFit.fill,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    offset: const Offset(3, 2),
                    blurRadius: 7)
              ],
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.network(
                    oldNews[index].images[0],
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    oldNews[index].title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          if (oldNews[index].visibility != '')
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          titlePadding: const EdgeInsets.all(8.0),
                          title: Center(child: Text(oldNews[index].visibility)),
                        );
                      });
                },
                child: Image.asset(
                  'assets/images/class_room.png',
                  height: 30.0,
                ),
              ),
            )
        ],
      ),
    );
  }

  InkWell multiImageWithCaptionWidget(int index, double height) {
    return InkWell(
      onLongPress: widget.accessiblePerson
          ? () {
              deleteNewsAlert(oldNews[index].id.toString());
            }
          : null,
      onTap: () => navigateToDetailsPage(
          index: index,
          newsId: oldNews[index].id.toString(),
          accessiblePerson: widget.accessiblePerson),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                image: const AssetImage("assets/images/bg_image_tes.jpg"),
                fit: BoxFit.fill,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    offset: const Offset(3, 2),
                    blurRadius: 7)
              ],
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.network(
                    oldNews[index].images[0],
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    oldNews[index].title.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          if (oldNews[index].visibility != '')
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          titlePadding: const EdgeInsets.all(8.0),
                          title: Center(child: Text(oldNews[index].visibility)),
                        );
                      });
                },
                child: Image.asset(
                  'assets/images/class_room.png',
                  height: 30.0,
                ),
              ),
            )
        ],
      ),
    );
  }

  InkWell multiImageWithTitle(int index) {
    return InkWell(
      onLongPress: widget.accessiblePerson
          ? () {
              deleteNewsAlert(oldNews[index].id.toString());
            }
          : null,
      onTap: () => navigateToDetailsPage(
          index: index,
          newsId: oldNews[index].id.toString(),
          accessiblePerson: widget.accessiblePerson),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                image: const AssetImage("assets/images/bg_image_tes.jpg"),
                fit: BoxFit.fill,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    offset: const Offset(3, 2),
                    blurRadius: 7)
              ],
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Image.network(
                oldNews[index].images[0],
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          if (oldNews[index].visibility != '')
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          titlePadding: const EdgeInsets.all(8.0),
                          title: Center(child: Text(oldNews[index].visibility)),
                        );
                      });
                },
                child: Image.asset(
                  'assets/images/class_room.png',
                  height: 30.0,
                ),
              ),
            )
        ],
      ),
    );
  }

  InkWell imageWidget(int index) {
    return InkWell(
      onLongPress: widget.accessiblePerson
          ? () {
              deleteNewsAlert(oldNews[index].id.toString());
            }
          : null,
      onTap: () => navigateToDetailsPage(
          index: index,
          newsId: oldNews[index].id.toString(),
          accessiblePerson: widget.accessiblePerson),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                image: const AssetImage("assets/images/bg_image_tes.jpg"),
                fit: BoxFit.fill,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    offset: const Offset(3, 2),
                    blurRadius: 7)
              ],
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Image.network(
                oldNews[index].images[0],
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          if (oldNews[index].visibility != '')
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          titlePadding: const EdgeInsets.all(8.0),
                          title: Center(child: Text(oldNews[index].visibility)),
                        );
                      });
                },
                child: Image.asset(
                  'assets/images/class_room.png',
                  height: 30.0,
                ),
              ),
            )
        ],
      ),
    );
  }

  InkWell textWidget(
    int index,
  ) {
    return InkWell(
      onLongPress: widget.accessiblePerson
          ? () {
              deleteNewsAlert(oldNews[index].id.toString());
            }
          : null,
      onTap: () => navigateToDetailsPage(
          index: index,
          newsId: oldNews[index].id.toString(),
          accessiblePerson: widget.accessiblePerson),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                image: const AssetImage("assets/images/bg_image_tes.jpg"),
                fit: BoxFit.fill,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    offset: const Offset(3, 2),
                    blurRadius: 7)
              ],
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  oldNews[index].title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      DateFormat('d MMMM, yyyy')
                          .format(oldNews[index].dateTime),
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  oldNews[index].description.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                    fontSize: 13,
                  )),
                ),
              ],
            ),
          ),
          if (oldNews[index].visibility != '')
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                            titlePadding: const EdgeInsets.all(4.0),
                            title:
                                Chip(label: Text(oldNews[index].visibility)));
                      });
                },
                child: Image.asset(
                  'assets/images/class_room.png',
                  height: 30.0,
                ),
              ),
            )
        ],
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/Utils/Utility.dart';
import 'package:ui/api/news&events/delete_news_api.dart';
import 'package:ui/api/news&events/news_feed_api.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/custom/no_data_widget.dart';
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
  NewsFeedMain? newsFeed;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await getNewsFeed(studentId: widget.studentId).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            newsFeed = value;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.blue.withOpacity(0.3), BlendMode.dstATop),
              image: const AssetImage("assets/images/bg_image_tes.jpg"),
              fit: BoxFit.cover,
            )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              widget.accessiblePerson
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                              builder: (context) => const AddNewsForm(),
                            ))
                            .then((value) => value ? initialize() : null);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin:
                            const EdgeInsets.only(top: 10, left: 15, right: 15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Add News Here",
                                style: TextStyle(color: Colors.grey.shade800),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.newspaper, color: Colors.grey.shade800)
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: isLoading
                      ? LoadingAnimator()
                      : newsFeed == null
                          ? const NoData()
                          : Column(
                              children: [
                                InkWell(
                                  onLongPress: widget.accessiblePerson
                                      ? () {
                                          deleteNewsAlert(
                                              newsFeed!.latest.id.toString());
                                        }
                                      : null,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsPageNews(
                                            newsFeed: newsFeed!.latest,
                                          ),
                                        ));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 10,
                                            left: 15,
                                            right: 15,
                                            bottom: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        newsFeed!.latest.title
                                                            .capitalize(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: GoogleFonts.lato(
                                                            textStyle: const TextStyle(
                                                                fontSize: 19,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    )
                                                  : Image.network(
                                                      newsFeed!.latest.images[0]
                                                              .contains(
                                                                  "https://")
                                                          ? newsFeed!
                                                              .latest.images[0]
                                                          : newsFeed!.latest
                                                                  .images[0]
                                                                  .contains(
                                                                      "http://")
                                                              ? newsFeed!.latest
                                                                  .images[0]
                                                              : "http://${newsFeed!.latest.images[0]}",
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.25,
                                                      fit: BoxFit.cover,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                    ),
                                              newsFeed!.latest.images.isEmpty
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        newsFeed!
                                                            .latest.description
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                        style: GoogleFonts.lato(
                                                            textStyle:
                                                                const TextStyle(
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
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        newsFeed!.latest.title,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                        style: GoogleFonts.lato(
                                                            textStyle:
                                                                const TextStyle(
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
                                                  const BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(7),
                                                      topRight:
                                                          Radius.circular(7)),
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
                                                      textStyle:
                                                          const TextStyle(
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
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: MediaQuery.removePadding(
                                    removeTop: true,
                                    context: context,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: newsFeed!.old.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 400,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20),
                                      itemBuilder: (context, index) {
                                        switch (newsFeed!
                                            .old[index].newsEventsCategory) {
                                          case 1:
                                            {
                                              return textWidget(index);
                                            }
                                          case 2:
                                            {
                                              return imageWidget(index);
                                            }
                                          case 3:
                                            {
                                              return imageWithCaptionWidget(
                                                  index);
                                            }
                                          case 4:
                                            {
                                              return multiImageWithTitle(index);
                                            }
                                          case 5:
                                            {
                                              return multiImageWithCaptionWidget(
                                                  index);
                                            }
                                        }
                                        return Text(
                                          newsFeed!
                                              .old[index].newsEventsCategory
                                              .toString(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
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
              await getNewsFeed(studentId: widget.studentId).then((value) {
                if (value != null) {
                  if (mounted) {
                    setState(() {
                      newsFeed = value;
                    });
                  }
                }
              });
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

  InkWell imageWithCaptionWidget(int index) {
    return InkWell(
      onLongPress: widget.accessiblePerson
          ? () {
              deleteNewsAlert(newsFeed!.old[index].id.toString());
            }
          : null,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPageNews(
                newsFeed: newsFeed!.old[index],
              ),
            ));
      },
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
                    newsFeed!.old[index].images[0],
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    newsFeed!.old[index].title,
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
          if (newsFeed!.old[index].visibility != '' && widget.accessiblePerson)
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
                          title: Center(
                              child: Text(newsFeed!.old[index].visibility)),
                        );
                      });
                },
                child: Lottie.asset(
                  'assets/lottie/class1.json',
                  height: 30.0,
                  repeat: true,
                  reverse: true,
                  animate: true,
                ),
              ),
            )
        ],
      ),
    );
  }

  InkWell multiImageWithCaptionWidget(int index) {
    return InkWell(
      onLongPress: widget.accessiblePerson
          ? () {
              deleteNewsAlert(newsFeed!.old[index].id.toString());
            }
          : null,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPageNews(
                newsFeed: newsFeed!.old[index],
              ),
            ));
      },
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
                    newsFeed!.old[index].images[0],
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    newsFeed!.old[index].title.toString(),
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
          if (newsFeed!.old[index].visibility != '' && widget.accessiblePerson)
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
                          title: Center(
                              child: Text(newsFeed!.old[index].visibility)),
                        );
                      });
                },
                child: Lottie.asset(
                  'assets/lottie/class1.json',
                  height: 30.0,
                  repeat: true,
                  reverse: true,
                  animate: true,
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
              deleteNewsAlert(newsFeed!.old[index].id.toString());
            }
          : null,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPageNews(
                newsFeed: newsFeed!.old[index],
              ),
            ));
      },
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
                newsFeed!.old[index].images[0],
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          if (newsFeed!.old[index].visibility != '' && widget.accessiblePerson)
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
                          title: Center(
                              child: Text(newsFeed!.old[index].visibility)),
                        );
                      });
                },
                child: Lottie.asset(
                  'assets/lottie/class1.json',
                  height: 30.0,
                  repeat: true,
                  reverse: true,
                  animate: true,
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
              deleteNewsAlert(newsFeed!.old[index].id.toString());
            }
          : null,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPageNews(
                newsFeed: newsFeed!.old[index],
              ),
            ));
      },
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
                newsFeed!.old[index].images[0],
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          if (newsFeed!.old[index].visibility != '' && widget.accessiblePerson)
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
                          title: Center(
                              child: Text(newsFeed!.old[index].visibility)),
                        );
                      });
                },
                child: Lottie.asset(
                  'assets/lottie/class1.json',
                  height: 30.0,
                  repeat: true,
                  reverse: true,
                  animate: true,
                ),
              ),
            )
        ],
      ),
    );
  }

  InkWell textWidget(int index) {
    return InkWell(
      onLongPress: widget.accessiblePerson
          ? () {
              deleteNewsAlert(newsFeed!.old[index].id.toString());
            }
          : null,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPageNews(
                newsFeed: newsFeed!.old[index],
              ),
            ));
      },
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
                  newsFeed!.old[index].title,
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
                          .format(newsFeed!.old[index].dateTime),
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
                  newsFeed!.old[index].description.toString(),
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
          if (newsFeed!.old[index].visibility != '' && widget.accessiblePerson)
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
                            title: Chip(
                                label: Text(newsFeed!.old[index].visibility)));
                      });
                },
                child: Lottie.asset(
                  'assets/lottie/class1.json',
                  height: 30.0,
                  repeat: true,
                  reverse: true,
                  animate: true,
                ),
              ),
            )
        ],
      ),
    );
  }
}

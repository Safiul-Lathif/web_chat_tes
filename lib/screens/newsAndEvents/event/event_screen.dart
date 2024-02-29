// ignore_for_file: must_be_immutable
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ui/Utils/Utility.dart';
import 'package:ui/api/news&events/delete_news_api.dart';
import 'package:ui/api/news&events/events_feed_api.dart';
import 'package:ui/config/const.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/news&events/events_feed_model.dart';
import 'package:ui/screens/newsAndEvents/event/add_event_form.dart';
import 'package:ui/screens/newsAndEvents/event/detail_page_events.dart';

class EventScreen extends StatefulWidget {
  EventScreen(
      {super.key, required this.accessiblePerson, required this.studentId});
  bool accessiblePerson;
  String studentId;

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  int _index = 0;
  EventsFeedList? eventsFeedList;
  bool isLoading = true;
  int pageNumber = 1;
  List<EventFeed> upcomingEvents = [];
  List<EventFeed> completedEvents = [];
  List<EventFeed> upcomingList = [];
  List<EventFeed> completedList = [];

  final ScrollController upcomingController = ScrollController();
  final ScrollController completedController = ScrollController();

  bool isPageSelected = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    upcomingController.addListener(() {
      if (upcomingController.position.pixels ==
          upcomingController.position.maxScrollExtent) {
        if (pageNumber != 0) {
          _loadNextPage();
        }
      }
    });
    completedController.addListener(() {
      if (completedController.position.pixels ==
          completedController.position.maxScrollExtent) {
        if (pageNumber != 0) {
          _loadNextPage();
        }
      }
    });
    await getEventsFeed(studentId: widget.studentId, pageNumber: pageNumber)
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            eventsFeedList = value;
            completedList.addAll(value.completedEvents.data);
            completedEvents = completedList;
            upcomingList.addAll(value.upcomingEvents.data);
            upcomingEvents = upcomingList;
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

  void updateLatestEvents() {
    setState(() {
      pageNumber = 1;
      upcomingEvents.clear();
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

  void deleteEvents(id) async {
    await deleteNews(id: id);
    await getEventsFeed(studentId: widget.studentId, pageNumber: pageNumber)
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            eventsFeedList = value;
          });
        }
      }
    });
  }

  Future<void> deleteNewsAlert(String id) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Do you want to delete this Event?'),
        actions: [
          ElevatedButton(
            style: buttonStyle,
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: buttonStyle,
            onPressed: () async {
              deleteEvents(id);
              navigation('Events Deleted Successfully');
              Navigator.of(context).pop(false);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  int selectedIndex = 0;
  void navigation(String message) {
    Utility.displaySnackBar(context, message);
  }

  final PageController _pageController =
      PageController(viewportFraction: 0.4, initialPage: 0);

  String eventsId = '';
  bool isPastEvent = false;
  bool isAccessiblePerson = false;
  void navigateToDetailsPage(
      {required String eventId,
      required bool accessiblePerson,
      required int index,
      required bool isPast}) {
    setState(() {
      isPageSelected = false;
      eventsId = eventId;
      isPastEvent = isPast;
      isAccessiblePerson = accessiblePerson;
      isDetailScreen = true;
      selectedIndex = index;
      pageNumber = index;
    });
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        isPageSelected = true;
      });
    });
  }

  Future<bool> createEventsForm() async {
    return await showDialog(
            context: context,
            builder: (context) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: AddEventForm(
                        callback: updateLatestEvents,
                      ),
                    ),
                  ),
                )) ??
        false;
  }

  bool isDetailScreen = false;

  void onBackDetailsPage() {
    setState(() {
      isDetailScreen = false;
    });
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
                                Colors.blue.withOpacity(0.4),
                                BlendMode.dstATop),
                            image: const AssetImage(Images.bgImage),
                            fit: BoxFit.cover,
                          )),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          itemCount: 1,
                          itemExtent: 200,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: imageWithCaptionWidget(
                                  index,
                                  0.2,
                                  isPastEvent
                                      ? completedEvents[index]
                                      : upcomingEvents[index]),
                            );
                          }))),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: isPageSelected
                    ? DetailsPageEvents(
                        callBack: onBackDetailsPage,
                        accessiblePerson: isAccessiblePerson,
                        isPast: isPastEvent,
                        eventId: eventsId)
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
              ),
            ],
          )
        : Scaffold(
            body: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                      image: const AssetImage("assets/images/bg_image_tes.jpg"),
                      repeat: ImageRepeat.repeat)),
              child: SingleChildScrollView(
                controller: completedController,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Events List",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                        ),
                        widget.accessiblePerson
                            ? InkWell(
                                onTap: () => createEventsForm(),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black45),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Add Events Here",
                                          style: TextStyle(
                                              color: Colors.grey.shade800),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(Icons.event,
                                            color: Colors.grey.shade800)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    completedEvents.isEmpty && upcomingEvents.isEmpty
                        ? LoadingAnimator()
                        : Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 10, bottom: 5),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Upcoming events",
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ),
                              upcomingEvents.isEmpty
                                  ? Center(
                                      child: Text(
                                        "Oops!! There is no upcoming events",
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (_index != 0)
                                          CircleAvatar(
                                            backgroundColor: Colors.white70,
                                            child: IconButton(
                                                onPressed: _index == 0
                                                    ? null
                                                    : () {
                                                        setState(() {
                                                          _index--;
                                                          _pageController.animateToPage(
                                                              _index,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          10),
                                                              curve: Curves
                                                                  .easeInOut);
                                                        });
                                                      },
                                                icon: const Icon(
                                                  Icons.arrow_back_ios_new,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        Expanded(
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            child: PageView.builder(
                                              itemCount: upcomingEvents.length,
                                              physics: const ScrollPhysics(),
                                              controller: _pageController,
                                              onPageChanged: (int index) =>
                                                  setState(
                                                      () => _index = index),
                                              itemBuilder: (_, i) {
                                                return InkWell(
                                                  onLongPress: widget
                                                          .accessiblePerson
                                                      ? () {
                                                          deleteNewsAlert(
                                                              upcomingEvents[i]
                                                                  .id
                                                                  .toString());
                                                        }
                                                      : null,
                                                  onTap: () =>
                                                      navigateToDetailsPage(
                                                          index: i,
                                                          eventId:
                                                              upcomingEvents[i]
                                                                  .id
                                                                  .toString(),
                                                          accessiblePerson: widget
                                                              .accessiblePerson,
                                                          isPast: false),
                                                  child: Transform.scale(
                                                    scale:
                                                        i == _index ? 1 : 0.8,
                                                    child: Card(
                                                        elevation: 6,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .blue.shade50,
                                                            image:
                                                                DecorationImage(
                                                              colorFilter: ColorFilter.mode(
                                                                  Colors.blue
                                                                      .withOpacity(
                                                                          0.3),
                                                                  BlendMode
                                                                      .dstATop),
                                                              image: const AssetImage(
                                                                  "assets/images/bg_image_tes.jpg"),
                                                              fit: BoxFit.cover,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          .5),
                                                                  offset:
                                                                      const Offset(
                                                                          3, 2),
                                                                  blurRadius: 7)
                                                            ],
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            15)),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: const BorderRadius
                                                                        .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            15),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            15)),
                                                                child: Image
                                                                    .network(
                                                                  upcomingEvents[
                                                                          i]
                                                                      .images[0],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.3,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: Text(
                                                                  upcomingEvents[
                                                                          i]
                                                                      .title,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                  style: GoogleFonts.lato(
                                                                      textStyle: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        'Date :',
                                                                        style: GoogleFonts.lato(
                                                                            textStyle:
                                                                                const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                                                      ),
                                                                      Text(
                                                                        DateFormat('d MMMM, yyyy')
                                                                            .format(upcomingEvents[i].eventDate),
                                                                        style: GoogleFonts.lato(
                                                                            textStyle:
                                                                                const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        'Time :',
                                                                        style: GoogleFonts.lato(
                                                                            textStyle:
                                                                                const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                                                      ),
                                                                      Text(
                                                                        DateFormat.jm().format(DateFormat("hh:mm:ss").parse(upcomingEvents[i]
                                                                            .eventTime
                                                                            .toString())),
                                                                        style: GoogleFonts.lato(
                                                                            textStyle:
                                                                                const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        _index >= upcomingEvents.length - 1
                                            ? Container()
                                            : CircleAvatar(
                                                backgroundColor: Colors.white70,
                                                child: IconButton(
                                                    onPressed: _index >=
                                                            upcomingEvents
                                                                    .length -
                                                                1
                                                        ? null
                                                        : () {
                                                            setState(() {
                                                              _index++;
                                                              _pageController.animateToPage(
                                                                  _index,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          10),
                                                                  curve: Curves
                                                                      .easeInOut);
                                                            });
                                                          },
                                                    icon: const Icon(
                                                      Icons
                                                          .arrow_forward_ios_sharp,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                      ],
                                    ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 10, bottom: 5),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Past events",
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ),
                              SizedBox(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: completedEvents.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 500,
                                          childAspectRatio: 2,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  physics: const ScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        InkWell(
                                          onTap: () => navigateToDetailsPage(
                                              index: index,
                                              eventId: completedEvents[index]
                                                  .id
                                                  .toString(),
                                              accessiblePerson:
                                                  widget.accessiblePerson,
                                              isPast: true),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blue.shade50,
                                                image: DecorationImage(
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.blue
                                                          .withOpacity(0.3),
                                                      BlendMode.dstATop),
                                                  image: const AssetImage(
                                                      "assets/images/bg_image_tes.jpg"),
                                                  fit: BoxFit.cover,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(.5),
                                                      offset:
                                                          const Offset(3, 2),
                                                      blurRadius: 7)
                                                ],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10))),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10)),
                                                  child: Image.network(
                                                    completedEvents[index]
                                                        .images[0],
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.13,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Text(
                                                          completedEvents[index]
                                                              .title,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 3,
                                                          style: GoogleFonts.lato(
                                                              textStyle: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            'Date :',
                                                            style: GoogleFonts.lato(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                                    'd MMMM, yyyy')
                                                                .format(DateTime.parse(
                                                                    completedEvents[
                                                                            index]
                                                                        .eventDate
                                                                        .toString())),
                                                            style: GoogleFonts.lato(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
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
                                                          Text(
                                                            'Accepted:',
                                                            style: GoogleFonts.lato(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                          Text(
                                                            completedEvents[
                                                                    index]
                                                                .accepted
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
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
                                                          Text(
                                                            'Declined:',
                                                            style: GoogleFonts.lato(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                          Text(
                                                            completedEvents[
                                                                    index]
                                                                .declined
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        completedEvents[index].visibility !=
                                                    '' &&
                                                widget.accessiblePerson
                                            ? Positioned(
                                                bottom: 5,
                                                right: 10,
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return SimpleDialog(
                                                              titlePadding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              title: Chip(
                                                                  label: Text(completedEvents[
                                                                          index]
                                                                      .visibility)));
                                                        });
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/class_room.png',
                                                    height: 30.0,
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
  }

  InkWell imageWithCaptionWidget(
      int index, double height, EventFeed eventFeed) {
    return InkWell(
      onLongPress: widget.accessiblePerson
          ? () {
              deleteNewsAlert(eventFeed.id.toString());
            }
          : null,
      onTap: () => navigateToDetailsPage(
          index: index,
          eventId: eventFeed.id.toString(),
          accessiblePerson: widget.accessiblePerson,
          isPast: isPastEvent),
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
                    eventFeed.images[0],
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    eventFeed.title,
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
          if (eventFeed.visibility != '' && widget.accessiblePerson)
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
                          title: Center(child: Text(eventFeed.visibility)),
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
}

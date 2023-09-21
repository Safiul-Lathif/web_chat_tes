// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/Utils/Utility.dart';
import 'package:ui/api/news&events/delete_news_api.dart';
import 'package:ui/api/news&events/events_feed_api.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/custom/no_data_widget.dart';
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
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await getEventsFeed(studentId: widget.studentId).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            eventsFeedList = value;
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

  void deleteEvents(id) async {
    await deleteNews(id: id);
    await getEventsFeed(studentId: widget.studentId).then((value) {
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

  void navigation(String message) {
    Utility.displaySnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              widget.accessiblePerson
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                              builder: (context) => const AddEventForm(),
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
                                "Add Events Here",
                                style: TextStyle(color: Colors.grey.shade800),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.event, color: Colors.grey.shade800)
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              isLoading
                  ? LoadingAnimator()
                  : eventsFeedList == null
                      ? const NoData()
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
                            eventsFeedList!.upcomingEvents.isEmpty
                                ? Center(
                                    child: Text(
                                      "Oops!! There is no upcoming events",
                                      style: GoogleFonts.lato(
                                          textStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  )
                                : SizedBox(
                                    height: 218,
                                    child: PageView.builder(
                                      itemCount:
                                          eventsFeedList!.upcomingEvents.length,
                                      physics: const ScrollPhysics(),
                                      controller:
                                          PageController(viewportFraction: 0.7),
                                      onPageChanged: (int index) =>
                                          setState(() => _index = index),
                                      itemBuilder: (_, i) {
                                        return InkWell(
                                          onLongPress: widget.accessiblePerson
                                              ? () {
                                                  deleteNewsAlert(
                                                      eventsFeedList!
                                                          .upcomingEvents[i].id
                                                          .toString());
                                                }
                                              : null,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailsPageEvents(
                                                            isPast: false,
                                                            eventFeed:
                                                                eventsFeedList!
                                                                        .upcomingEvents[
                                                                    i])));
                                          },
                                          child: Transform.scale(
                                            scale: i == _index ? 1 : 0.8,
                                            child: Card(
                                                elevation: 6,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue.shade50,
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
                                                      fit: BoxFit.cover,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(.5),
                                                          offset: const Offset(
                                                              3, 2),
                                                          blurRadius: 7)
                                                    ],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                topRight: Radius
                                                                    .circular(
                                                                        15)),
                                                        child: Image.network(
                                                          eventsFeedList!
                                                              .upcomingEvents[i]
                                                              .images[0],
                                                          fit: BoxFit.cover,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.18,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: Text(
                                                          eventsFeedList!
                                                              .upcomingEvents[i]
                                                              .title,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: GoogleFonts.lato(
                                                              textStyle: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
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
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                'Date :',
                                                                style: GoogleFonts.lato(
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                              Text(
                                                                DateFormat(
                                                                        'd MMMM, yyyy')
                                                                    .format(eventsFeedList!
                                                                        .upcomingEvents[
                                                                            i]
                                                                        .eventDate),
                                                                style: GoogleFonts.lato(
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Time :',
                                                                style: GoogleFonts.lato(
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                              Text(
                                                                DateFormat.jm().format(DateFormat(
                                                                        "hh:mm:ss")
                                                                    .parse(eventsFeedList!
                                                                        .upcomingEvents[
                                                                            i]
                                                                        .eventTime
                                                                        .toString())),
                                                                style: GoogleFonts.lato(
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
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
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: ListView.builder(
                                itemCount:
                                    eventsFeedList!.completedEvents.length,
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsPageEvents(
                                                          isPast: true,
                                                          eventFeed: eventsFeedList!
                                                                  .completedEvents[
                                                              index])));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          height: 120,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
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
                                                    offset: const Offset(3, 2),
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
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                10)),
                                                child: Image.network(
                                                  eventsFeedList!
                                                      .completedEvents[index]
                                                      .images[0],
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                    child: Text(
                                                      eventsFeedList!
                                                          .completedEvents[
                                                              index]
                                                          .title,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
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
                                                            textStyle:
                                                                const TextStyle(
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
                                                                eventsFeedList!
                                                                    .completedEvents[
                                                                        index]
                                                                    .eventDate
                                                                    .toString())),
                                                        style: GoogleFonts.lato(
                                                            textStyle:
                                                                const TextStyle(
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
                                                            textStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                      ),
                                                      Text(
                                                        eventsFeedList!
                                                            .completedEvents[
                                                                index]
                                                            .accepted
                                                            .toString(),
                                                        style: GoogleFonts.lato(
                                                            textStyle:
                                                                const TextStyle(
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
                                                            textStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                      ),
                                                      Text(
                                                        eventsFeedList!
                                                            .completedEvents[
                                                                index]
                                                            .declined
                                                            .toString(),
                                                        style: GoogleFonts.lato(
                                                            textStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      eventsFeedList!.completedEvents[index]
                                                      .visibility !=
                                                  '' &&
                                              widget.accessiblePerson
                                          ? Positioned(
                                              top: 10,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
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
                                                                label: Text(eventsFeedList!
                                                                    .completedEvents[
                                                                        index]
                                                                    .visibility)));
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
}

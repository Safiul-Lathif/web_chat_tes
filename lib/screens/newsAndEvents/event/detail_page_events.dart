// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/api/news&events/event_accept_decline_api.dart';
import 'package:ui/api/news&events/single_news_event.dart';
import 'package:ui/config/const.dart';
import 'package:ui/custom/detail_page_image.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/news&events/single_news_events_model.dart';
import 'package:ui/screens/newsAndEvents/event/add_event_form.dart';
import 'package:ui/utils/session_management.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Utils/utility.dart';

class DetailsPageEvents extends StatefulWidget {
  DetailsPageEvents(
      {super.key,
      required this.isPast,
      required this.eventId,
      required this.accessiblePerson,
      required this.callBack});
  bool isPast;
  String eventId;
  bool accessiblePerson;
  Function callBack;
  @override
  State<DetailsPageEvents> createState() => _DetailsPageEventsState();
}

class _DetailsPageEventsState extends State<DetailsPageEvents> {
  bool isAccepted = false;
  bool isDeclined = false;
  bool isLoading = false;
  late SingleEvent eventFeed;
  List<String> images = [];

  void getIndividualEvent() async {
    isLoading = true;
    await getSingleEvent(widget.eventId).then((value) {
      setState(() {
        images.clear();
        eventFeed = value!;
        for (int i = 0; i < value.images.length; i++) {
          images.add(value.images[i].image);
        }
        switch (eventFeed.acceptStatus) {
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
        isLoading = false;
      });
    });
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

  @override
  void initState() {
    super.initState();
    getIndividualEvent();
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

  bool playVideo = false;

  Future<bool> goBack() async {
    Navigator.pop(context, true);
    return true;
  }

  Future<bool> editEvents() async {
    return await showDialog(
            context: context,
            builder: (context) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: AddEventForm(
                        callback: getIndividualEvent,
                        eventFeed: eventFeed,
                      ),
                    ),
                  ),
                )) ??
        false;
  }

  int itemIndex = 0;

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
            fit: BoxFit.fill,
          )),
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
                            image: NetworkImage(eventFeed.images[0].image),
                            fit: BoxFit.cover)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, left: 10),
                      child: CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: IconButton(
                            onPressed: () => widget.callBack(),
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
                      eventFeed.title,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    widget.isPast
                                        ? Colors.red.shade100
                                        : Colors.red),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            onPressed: widget.isPast
                                ? () {
                                    Utility.displaySnackBar(context,
                                        "Can't Decline the event after the event end");
                                  }
                                : () {
                                    eventAcceptDecline(
                                            id: eventFeed.id.toString(),
                                            status: '2')
                                        .then((value) {
                                      getIndividualEvent();
                                      !isDeclined
                                          ? Utility.displaySnackBar(context,
                                              "Event Declined Successfully")
                                          : null;
                                    });
                                  },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
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
                                    eventFeed.declined == 0
                                        ? "Declined"
                                        : "Declined (${eventFeed.declined.toString()})",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    widget.isPast
                                        ? Colors.green.shade100
                                        : Colors.green),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            onPressed: widget.isPast
                                ? () {
                                    Utility.displaySnackBar(context,
                                        "Can't Accept the event after the event end");
                                  }
                                : () {
                                    eventAcceptDecline(
                                            id: eventFeed.id.toString(),
                                            status: '1')
                                        .then((value) {
                                      getIndividualEvent();
                                    });
                                    isAccepted
                                        ? null
                                        : Utility.displaySnackBar(context,
                                            "Event Accepted Successfully");
                                  },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
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
                                    eventFeed.accepted == 0
                                        ? "Accepted"
                                        : "Accepted(${eventFeed.accepted.toString()})",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        widget.isPast || !widget.accessiblePerson
                            ? Container()
                            : READ_ACCESS
                                ? IconButton(
                                    onPressed: () => editEvents(),
                                    icon: const Icon(Icons.edit))
                                : Container(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (eventFeed.description != '')
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        eventFeed.description.toString(),
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  eventFeed.images.length >= 2
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: itemIndex == 0
                                    ? Colors.black12
                                    : Colors.black38,
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
                                      color: Colors.white,
                                    )),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                                  index: itemIndex,
                                                  images: images,
                                                  dateTime: eventFeed.eventDate,
                                                  title: eventFeed.user,
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
                              CircleAvatar(
                                backgroundColor:
                                    itemIndex >= eventFeed.images.length - 1
                                        ? Colors.black12
                                        : Colors.black38,
                                child: IconButton(
                                    onPressed:
                                        itemIndex >= eventFeed.images.length - 1
                                            ? null
                                            : () {
                                                setState(() {
                                                  itemIndex++;
                                                });
                                              },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  if (eventFeed.youtubeLink != '')
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
                                launchUrl(Uri.parse(eventFeed.youtubeLink),
                                    mode: LaunchMode.externalApplication);
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://img.youtube.com/vi/${getUrlYt(eventFeed.youtubeLink)}/0.jpg"),
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
                              launchUrl(Uri.parse(eventFeed.youtubeLink),
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

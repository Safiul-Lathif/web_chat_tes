import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ui/api/delete_api.dart';
import 'package:ui/api/info_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/config/size_config.dart';
import 'package:ui/custom/detail_page_image.dart';
import 'package:ui/custom/info_delete.dart';
import 'package:ui/custom/receive_message_importatnt_title.dart';
import 'package:ui/custom/receive_message_title.dart';
import 'package:ui/custom/send_message_important_title.dart';
import 'package:ui/custom/send_message_title.dart';
import 'package:ui/custom/time_widget.dart';
import 'package:ui/custom/visibility_widget.dart';
import 'package:ui/model/info_model.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/utils/utility.dart';

class ThirdCard extends StatefulWidget {
  const ThirdCard({
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

  @override
  State<ThirdCard> createState() => _ThirdCardState();
}

class _ThirdCardState extends State<ThirdCard> {
  bool isVisible = false;
  Info? infoMessage;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: widget.type == 2
          ? Align(
              alignment: Alignment.centerLeft,
              child: Row(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            Chat.imageIcon,
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(5)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade300,
                                    Colors.blueAccent
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.centerRight),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  const Text(
                                    'Image',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (widget.data.distributionType == 7 &&
                                      widget.role.toUpperCase() == "PARENT")
                                    Text(" (Only for you)",
                                        style: GoogleFonts.aBeeZee(
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          if (widget.data.distributionType == 7 &&
                              widget.role.toUpperCase() == "PARENT")
                            const Icon(
                              Icons.verified,
                              color: Colors.red,
                            )
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          ReceiveMessageImportantTitle(data: widget.data),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
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
                              margin: const EdgeInsets.only(bottom: 3),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.15,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: widget.data.images!.length == 1
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (_) {
                                                  return DetailScreen(
                                                    index: 0,
                                                    images: widget.data.images!
                                                        .toList(),
                                                  );
                                                }));
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(widget
                                                                .data.images![0]
                                                                .contains(
                                                                    "https://")
                                                            ? widget
                                                                .data.images![0]
                                                            : widget.data
                                                                    .images![0]
                                                                    .contains(
                                                                        "http://")
                                                                ? widget.data
                                                                    .images![0]
                                                                //data.images.toString()
                                                                : "http://${widget.data.images![0]}")),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                              ),
                                            )
                                          : Container(
                                              constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.3,
                                              ),
                                              child: GridView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          crossAxisSpacing: 5,
                                                          mainAxisSpacing: 5),
                                                  itemCount: widget
                                                      .data.images!.length,
                                                  itemBuilder:
                                                      (BuildContext ctx,
                                                          index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder: (_) {
                                                          return DetailScreen(
                                                              index: index,
                                                              images: widget
                                                                  .data.images!
                                                                  .toList());
                                                        }));
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                fit: BoxFit.cover,
                                                                colorFilter: widget.data.images!.length >= 5 && index == 3 ? const ColorFilter.linearToSrgbGamma() : null,
                                                                image: NetworkImage(widget.data.images![index].contains("https://")
                                                                    ? widget.data.images![index]
                                                                    : widget.data.images![index].contains("http://")
                                                                        ? widget.data.images![index]
                                                                        : "http://${widget.data.images![index]}")),
                                                            borderRadius: BorderRadius.circular(7)),
                                                        child: widget
                                                                        .data
                                                                        .images!
                                                                        .length >=
                                                                    5 &&
                                                                index == 3
                                                            ? Center(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons.add,
                                                                      size: 50,
                                                                    ),
                                                                    Text(
                                                                      (widget.data.images!.length -
                                                                              3)
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              40),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            : null,
                                                      ),
                                                    );
                                                  }),
                                            ),
                                    ),
                                    widget.data.caption != ''
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Text(
                                              widget.data.caption ?? '',
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          TimeWidget(
                            communicationType:
                                widget.data.communicationType.toString(),
                            redCount: widget.redCount,
                            role: widget.role,
                            tym: widget.data.dateTime.toString(),
                            notiid: widget.notiid,
                            gid: widget.id,
                            isDeleted: false,
                          )
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(4, 0 * fem, 130 * fem, 0),
                          child: VisibilityWidget(
                              role: widget.role,
                              visible: widget.data.visibility.toString())),
                    ],
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade300,
                                        Colors.blueAccent
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.centerRight),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    'Image',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Image.asset(
                                Chat.imageIcon,
                                height: 25,
                                width: 25,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SendMessageImportantTitle(data: widget.data),
                            const SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TimeWidget(
                              redCount: widget.redCount,
                              communicationType:
                                  widget.data.communicationType.toString(),
                              role: widget.role,
                              tym: widget.data.dateTime.toString(),
                              notiid: widget.notiid,
                              gid: widget.id,
                              isDeleted: false,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              child: ChatBubble(
                                clipper: ChatBubbleClipper10(
                                    type: BubbleType.sendBubble),
                                backGroundColor: const Color(0xffE7E7ED),
                                alignment: Alignment.topRight,
                                margin: const EdgeInsets.only(bottom: 3),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.15,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: widget.data.images!.length == 1
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (_) {
                                                    return DetailScreen(
                                                      index: 0,
                                                      images: widget
                                                          .data.images!
                                                          .toList(),
                                                    );
                                                  }));
                                                },
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(widget
                                                                  .data
                                                                  .images![0]
                                                                  .contains(
                                                                      "https://")
                                                              ? widget.data
                                                                  .images![0]
                                                              : widget
                                                                      .data
                                                                      .images![
                                                                          0]
                                                                      .contains(
                                                                          "http://")
                                                                  ? widget.data
                                                                          .images![
                                                                      0]
                                                                  //data.images.toString()
                                                                  : "http://${widget.data.images![0]}")),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7)),
                                                ),
                                              )
                                            : Container(
                                                constraints: BoxConstraints(
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.3,
                                                ),
                                                child: GridView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            crossAxisSpacing: 5,
                                                            mainAxisSpacing: 5),
                                                    itemCount: widget
                                                        .data.images!.length,
                                                    itemBuilder:
                                                        (BuildContext ctx,
                                                            index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) {
                                                            return DetailScreen(
                                                                index: index,
                                                                images: widget
                                                                    .data
                                                                    .images!
                                                                    .toList());
                                                          }));
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  fit: BoxFit.cover,
                                                                  colorFilter: widget.data.images!.length >= 5 && index == 3 ? const ColorFilter.linearToSrgbGamma() : null,
                                                                  image: NetworkImage(widget.data.images![index].contains("https://")
                                                                      ? widget.data.images![index]
                                                                      : widget.data.images![index].contains("http://")
                                                                          ? widget.data.images![index]
                                                                          : "http://${widget.data.images![index]}")),
                                                              borderRadius: BorderRadius.circular(7)),
                                                          child: widget
                                                                          .data
                                                                          .images!
                                                                          .length >=
                                                                      5 &&
                                                                  index == 3
                                                              ? Center(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            50,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      Text(
                                                                        (widget.data.images!.length -
                                                                                3)
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: Colors.white,
                                                                            fontSize: 40),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              : null,
                                                        ),
                                                      );
                                                    }),
                                              ),
                                      ),
                                      widget.data.caption != ''
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Text(
                                                widget.data.caption ?? '',
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: VisibilityWidget(
                              role: widget.role,
                              visible: widget.data.visibility.toString()),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isVisible,
                      child: InfoDeleteWidgetRight(
                          isDeleted: false,
                          data: widget.data,
                          itemIndex: widget.itemIndex,
                          id: widget.id,
                          callback: widget.callback,
                          type: widget.type),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

showDialogFunc(context, String img, String text) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              // padding: const EdgeInsets.all(15),
              child: Container(
                // decoration: BoxDecoration(
                //     color: Colors.blue.shade50,
                //     borderRadius: BorderRadius.circular(10),
                //     image: DecorationImage(
                //       colorFilter: ColorFilter.mode(
                //           Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                //       image: const NetworkImage(
                //           Images.bgImage),
                //       fit: BoxFit.fill,
                //     )),
                // padding: const EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Center(
                          child: Column(
                        children: [
                          Hero(
                            tag: img,
                            child: Image(
                              image: NetworkImage(img),
                              // fit: BoxFit.fill,
                              height: 300,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25)),
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.blue.withOpacity(0.3),
                                      BlendMode.dstATop),
                                  image: const AssetImage(Images.bgImage),
                                  fit: BoxFit.fill,
                                )),
                            padding:
                                text == '' ? null : const EdgeInsets.all(5),
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ),
            // Positioned(
            //   left: 312,
            //   bottom: 265,
            //   child: IconButton(
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //       icon: const CircleAvatar(
            //         radius: 12,
            //         backgroundColor: Colors.white,
            //         child: Icon(
            //           Icons.cancel_outlined,
            //           color: Colors.black,
            //         ),
            //       )),
            // )
          ],
        ),
      );
    },
  );
}

showMultiDialogFunc(
  context,
  List img,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                // padding: const EdgeInsets.all(15),
                child: Container(
                  // decoration: BoxDecoration(
                  //     color: Colors.blue.shade50,
                  //     borderRadius: BorderRadius.circular(10),
                  //     image: DecorationImage(
                  //       colorFilter: ColorFilter.mode(
                  //           Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                  //       image: const NetworkImage(
                  //           Images.bgImage),
                  //       fit: BoxFit.fill,
                  //     )),
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Center(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            CarouselSlider.builder(
                              itemCount: img.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  Image(
                                image: NetworkImage(
                                    img[itemIndex].contains("https://")
                                        ? img[itemIndex]
                                        : img[itemIndex].contains("http://")
                                            ? img[itemIndex]
                                            //data.images.toString()
                                            : "http://${img[itemIndex]}"),
                                height: 300,
                              ),
                              options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                                pauseAutoPlayOnTouch: true,
                              ),
                            )
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   left: 262,
              //   bottom: 190,
              //   child: IconButton(
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //       icon: const CircleAvatar(
              //         radius: 12,
              //         backgroundColor: Colors.white,
              //         child: Icon(
              //           Icons.cancel_outlined,
              //           color: Colors.black,
              //         ),
              //       )),
              // )
            ],
          ),
        ),
      );
    },
  );
}

Future<void> deleteNotify(BuildContext context,
    {required String grpid,
    required String notifyid,
    required String communicationType}) async {
  // _showLoader(context);
  await deleteNotification(
    grpid: grpid,
    notifyid: notifyid,
  ).then((value) {
    if (value["success"] == "Deleted Successfully!...") {
      // Navigator.of(context).pop();
      Utility.displaySnackBar(context, "Message Deleted");
      //     Navigator.push(
      // context,
      // MaterialPageRoute(
      //     builder: (context) => MainGroup(groups: null, name: '',
      //        )));
    } else {
      // Utility.displaySnackBar(
      //     context, "Message not Deleted");
      Navigator.of(context).pop();
      print("not delete");
    }
  });
}

ShowDialog(
  contex,
  Info? infoMessage,
) {
  return showDialog(
      context: (contex),
      builder: ((context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.41,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 179, 204, 245),
                        border: Border.all(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.blueAccent.shade400,
                                      Colors.blueAccent.shade100,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.centerRight)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                  "https://cdn-icons-png.flaticon.com/512/1665/1665646.png",
                                  width: 30,
                                  height: 30,
                                  color: Colors.white,
                                ),
                                const Text(
                                  "Message Info",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                      letterSpacing: 2),
                                ),
                                Image.network(
                                    "https://cdn-icons-png.flaticon.com/512/3972/3972676.png",
                                    color: Colors.white,
                                    width: 40,
                                    height: 40)
                              ],
                            ),
                          ),
                          Table(
                            border: TableBorder.all(
                              color: Colors.brown.shade400,
                              //style: BorderStyle.solid,
                              width: 0.2,
                            ),
                            children: [
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Initiated by",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infoMessage!.messageInfo.initiatedBy,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              /////////////////////2
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Initiated user Category",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infoMessage
                                        .messageInfo.initiatedUserCategory,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Initiated on",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    Utility.convertDateFormat(
                                        infoMessage.messageInfo.initiatedOn
                                            .toString(),
                                        "dd/MM/yyyy"),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Approved by",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infoMessage.messageInfo.approvedBy,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Approver user Category",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infoMessage
                                        .messageInfo.approverUserCategory,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Designation",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infoMessage.messageInfo.area,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Approved on",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    Utility.convertDateFormat(
                                        infoMessage.messageInfo.approvedAt
                                            .toString(),
                                        "dd/MM/yyyy"),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Deleted by",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    infoMessage.messageInfo.deletedBy,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                              TableRow(children: [
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Deleted on",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    Utility.convertDateFormat(
                                        infoMessage.messageInfo.deletedOn
                                            .toString(),
                                        "dd/MM/yyyy"),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ))
                              ]),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(13.0),
                            child: Text(
                              "Waiting for approval",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.87,
                  bottom: MediaQuery.of(context).size.height * 0.65,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ),
        );
      }));
}

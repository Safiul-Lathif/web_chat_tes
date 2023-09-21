// ignore_for_file: unnecessary_null_comparison, must_be_immutable

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:time_remaining/time_remaining.dart';
import 'package:ui/Utils/Utility.dart';
import 'package:ui/api/approve_home_work_api.dart';
import 'package:ui/api/home_work_api.dart';
import 'package:ui/api/send_message_api.dart';
import 'package:ui/custom/file_listview.dart';
import 'package:ui/model/staff_home_work_model.dart';
import 'package:ui/utils/utils_file.dart';

class HomeWorkPage extends StatefulWidget {
  HomeWorkPage({
    super.key,
    required this.isParent,
    required this.classId,
    required this.date,
    this.className,
  });
  final bool isParent;
  final String classId;
  DateTime date;
  String? className;

  @override
  State<HomeWorkPage> createState() => _HomeWorkPageState();
}

class _HomeWorkPageState extends State<HomeWorkPage> {
  var colorizeColors = [
    Colors.pink,
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.red
  ];

  var colorizeTextStyle = GoogleFonts.acme(
    fontSize: 27,
  );

  List<String> filterFile = ["PDF", "DOC", "PPT", "IMG", "XLC"];

  List<StaffHomework>? staffHomework;

  List<TextEditingController> controllers = [];
  List<PlatformFile> files = [];
  late List<String> extensions;

  List<String> notifyId = [];
  String dates = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      extensions = ['xlsx', 'pdf', 'jpg', 'jpeg', 'doc'];
    });
    dates = Utility.convertDateFormat(widget.date.toString(), "yyyy-MM-dd");
    initialize();
  }

  void initialize() async {
    await getStaffHomework(dates, widget.classId).then((value) {
      if (value != null) {
        setState(() {
          staffHomework = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.blue.shade50,
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                    image: const NetworkImage(
                        "https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg"),
                    repeat: ImageRepeat.repeat)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.blueGrey.shade400,
                              )),
                          Text(
                            'Home Work ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.blueGrey.shade600),
                          ),
                        ],
                      ),
                      Text(
                        widget.className!,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.blueGrey.shade600),
                      ),
                      Text(
                        Utility.convertDateFormat(
                            widget.date.toString(), "dd MMMM yyyy"),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                staffHomework == null || staffHomework!.isEmpty
                    ? Center(
                        child: SizedBox(
                          height: 400,
                          child: Lottie.network(
                            'https://assets7.lottiefiles.com/private_files/lf30_lkquf6qz.json',
                            height: 200.0,
                            repeat: true,
                            reverse: true,
                            animate: true,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.94,
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 5, left: 10, right: 10),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(.5),
                                        offset: const Offset(3, 2),
                                        blurRadius: 7)
                                  ],
                                  image: DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                        Colors.blue.withOpacity(0.1),
                                        BlendMode.dstATop),
                                    image: const NetworkImage(
                                        "https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg"),
                                    fit: BoxFit.cover,
                                  )),
                              child: SizedBox(
                                width: 250,
                                child: ListView.builder(
                                  itemCount: staffHomework!.length,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(.5),
                                                  offset: const Offset(3, 2),
                                                  blurRadius: 7)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              colorFilter: ColorFilter.mode(
                                                  Colors.blue.withOpacity(0.3),
                                                  BlendMode.dstATop),
                                              image: const NetworkImage(
                                                  "https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg"),
                                              fit: BoxFit.cover,
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      staffHomework![index]
                                                          .subjectName,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      staffHomework![index]
                                                          .staffName,
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                circularStrokeCap:
                                                    CircularStrokeCap.round,
                                                radius: 35.0,
                                                backgroundWidth: 2,
                                                lineWidth: 4.0,
                                                percent: (staffHomework![index]
                                                        .percent
                                                        .toDouble()) /
                                                    100,
                                                animation: true,
                                                animationDuration: 1000,
                                                center: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      (staffHomework![index]
                                                              .percent
                                                              .toDouble())
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 18),
                                                    ),
                                                    const Text("Percent",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 11))
                                                  ],
                                                ),
                                                linearGradient:
                                                    LinearGradient(colors: [
                                                  colorizeColors[index %
                                                          colorizeColors.length]
                                                      .shade100,
                                                  colorizeColors[index %
                                                          colorizeColors.length]
                                                      .shade500
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              staffHomework != null && staffHomework!.isNotEmpty
                                  ? SingleChildScrollView(
                                      child: Center(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.88,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: MediaQuery.removePadding(
                                            context: context,
                                            removeTop: true,
                                            child: GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 450,
                                                      childAspectRatio: 3 / 2,
                                                      crossAxisSpacing: 20,
                                                      mainAxisSpacing: 20),
                                              itemCount: staffHomework!.length,
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.only(
                                                  top: 20,
                                                  bottom: 20,
                                                  left: 15,
                                                  right: 15),
                                              itemBuilder: (context, index) {
                                                notifyId.add(
                                                    staffHomework![index]
                                                        .notificationId
                                                        .toString());

                                                controllers.add(
                                                    TextEditingController());
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors
                                                          .blueGrey.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                Colors.blue
                                                                    .withOpacity(
                                                                        0.3),
                                                                BlendMode
                                                                    .dstATop),
                                                        image: const NetworkImage(
                                                            "https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg"),
                                                        fit: BoxFit.cover,
                                                      )),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Column(
                                                      children: [
                                                        ExpansionTile(
                                                          leading: const CircleAvatar(
                                                              backgroundImage:
                                                                  AssetImage(
                                                                      "assets/images/icon.png")
                                                              // NetworkImage(
                                                              //     homeWorks[index]['image']),
                                                              ),
                                                          trailing: SizedBox(
                                                            width: 70,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                staffHomework![index].homeworkContent !=
                                                                            "" ||
                                                                        staffHomework![index]
                                                                            .images
                                                                            .isNotEmpty
                                                                    ? Row(
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.thumb_up,
                                                                            color:
                                                                                Colors.redAccent,
                                                                            size:
                                                                                20,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                4,
                                                                          ),
                                                                          Text(
                                                                            //    "0",
                                                                            staffHomework![index].completedCount.toString(),
                                                                            style:
                                                                                const TextStyle(color: Colors.black),
                                                                          )
                                                                        ],
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          ),
                                                          title: Text(
                                                            staffHomework![
                                                                    index]
                                                                .subjectName,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          subtitle: staffHomework![
                                                                              index]
                                                                          .homeworkContent !=
                                                                      "" ||
                                                                  staffHomework![
                                                                          index]
                                                                      .images
                                                                      .isNotEmpty
                                                              ? TimeRemaining(
                                                                  duration:
                                                                      const Duration(
                                                                          hours:
                                                                              4),
                                                                  warningDuration:
                                                                      const Duration(
                                                                          minutes:
                                                                              30),
                                                                  warningsStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blueGrey
                                                                          .shade500),
                                                                  dangerDuration:
                                                                      const Duration(
                                                                          minutes:
                                                                              10),
                                                                  dangerStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  onTimeOver:
                                                                      () {},
                                                                )
                                                              : Container(),
                                                        ),
                                                        staffHomework![index]
                                                                            .homeworkContent !=
                                                                        "" &&
                                                                    staffHomework![index]
                                                                            .homeworkContent !=
                                                                        null ||
                                                                widget.date
                                                                        .day !=
                                                                    DateTime.now()
                                                                        .day
                                                            ? Container(
                                                                width: 350,
                                                                height: widget
                                                                            .date
                                                                            .day ==
                                                                        DateTime.now()
                                                                            .day
                                                                    ? 104
                                                                    : 140,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  border: Border.all(
                                                                      color: const Color(
                                                                          0xff9f9f9f)),
                                                                ),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(staffHomework![index].homeworkContent ==
                                                                            ''
                                                                        ? 'No Home Work Given for this Subject'
                                                                        : staffHomework![index]
                                                                            .homeworkContent),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    // FileListView(
                                                                    //   file: staffHomework![
                                                                    //           index]
                                                                    //       .images,
                                                                    // )
                                                                  ],
                                                                ),
                                                              )
                                                            : Column(
                                                                children: [
                                                                  Container(
                                                                    width: 350,
                                                                    height: 32,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              7),
                                                                      border: Border.all(
                                                                          color:
                                                                              const Color(0xff9f9f9f)),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          TextField(
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        controller:
                                                                            controllers[index],
                                                                        decoration:
                                                                            InputDecoration.collapsed(
                                                                          hintText:
                                                                              'Type Your Text Here',
                                                                          hintStyle:
                                                                              SafeGoogleFont(
                                                                            'Inter',
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height:
                                                                                0.9152272542,
                                                                            letterSpacing:
                                                                                1.2,
                                                                            color:
                                                                                const Color(0xff797979),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      // ignore: no_leading_underscores_for_local_identifiers
                                                                      var _files = await FilePicker.platform.pickFiles(
                                                                          allowMultiple:
                                                                              true,
                                                                          type: FileType
                                                                              .custom,
                                                                          allowedExtensions:
                                                                              extensions);
                                                                      if (_files !=
                                                                          null) {
                                                                        setState(
                                                                            () {
                                                                          files.addAll(
                                                                              _files.files);
                                                                        });
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          350,
                                                                      height:
                                                                          82,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(7),
                                                                        border: Border.all(
                                                                            color:
                                                                                const Color(0xff9f9f9f)),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                25,
                                                                            width:
                                                                                25,
                                                                            decoration: const BoxDecoration(
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage(
                                                                                      ("https://cdn-icons-png.flaticon.com/128/6632/6632547.png"),
                                                                                    ),
                                                                                    fit: BoxFit.fill)),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          files.isEmpty
                                                                              ? Text(
                                                                                  "Please select files to upload",
                                                                                  style: SafeGoogleFont(
                                                                                    'Inter',
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    height: 0.9152272542,
                                                                                    letterSpacing: 1.2,
                                                                                    color: const Color(0xff797979),
                                                                                  ),
                                                                                )
                                                                              : FileListView(
                                                                                  file: files,
                                                                                )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        staffHomework![index]
                                                                        .approvalStatus ==
                                                                    0 &&
                                                                widget.date
                                                                        .day ==
                                                                    DateTime.now()
                                                                        .day
                                                            ? SizedBox(
                                                                height: 40,
                                                                child: ElevatedButton(
                                                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black26)),
                                                                    onPressed: staffHomework![index].homeworkContent != "" && staffHomework![index].homeworkContent != null
                                                                        //     ||
                                                                        // staffHomework![
                                                                        //         index]
                                                                        //     .homeworkContent
                                                                        //     .isNotEmpty
                                                                        ? () {
                                                                            dialogbox(
                                                                                homedata: staffHomework![index],
                                                                                txt: staffHomework![index].homeworkContent,
                                                                                attch: staffHomework![index].images);
                                                                          }
                                                                        : () async {
                                                                            if (controllers[index].text.isNotEmpty &&
                                                                                files.isEmpty) {
                                                                              await sendHomework(
                                                                                      notifyId: "",
                                                                                      fileList: files,
                                                                                      classConfig:
                                                                                          // "12",
                                                                                          widget.classId,
                                                                                      msgCategory: "1",
                                                                                      subId:
                                                                                          //      "1",
                                                                                          staffHomework![index].subjectId.toString(),
                                                                                      msg: controllers[index].text)
                                                                                  .then((value) {
                                                                                if (value != null) {
                                                                                  // Navigator.pop(context);
                                                                                  Utility.displaySnackBar(context, "Message send Successfully");
                                                                                } else {
                                                                                  // Navigator.pop(context);
                                                                                  Utility.displaySnackBar(context, "Message not send");
                                                                                }
                                                                                initState();
                                                                              });
                                                                            } else if (controllers[index].text.isEmpty && files.isNotEmpty) {
                                                                              await sendHomework(notifyId: "", fileList: files, classConfig: widget.classId, msgCategory: "3", subId: staffHomework![index].subjectId.toString(), msg: controllers[index].text).then((value) {
                                                                                if (value != null) {
                                                                                  Navigator.pop(context);
                                                                                  Utility.displaySnackBar(context, "Message send Successfully");
                                                                                } else {
                                                                                  Navigator.pop(context);
                                                                                  Utility.displaySnackBar(context, "Message not send");
                                                                                }
                                                                                initState();
                                                                              });
                                                                            } else if (controllers[index].text.isNotEmpty && files.isNotEmpty) {
                                                                              await sendHomework(notifyId: "", fileList: files, classConfig: widget.classId, msgCategory: "2", subId: staffHomework![index].subjectId.toString(), msg: controllers[index].text).then((value) {
                                                                                if (value != null) {
                                                                                  Utility.displaySnackBar(context, "Message send Successfully");
                                                                                } else {
                                                                                  Navigator.pop(context);
                                                                                  Utility.displaySnackBar(context, "Message not send");
                                                                                }
                                                                                initState();
                                                                              });
                                                                            }
                                                                          },
                                                                    child: staffHomework![index].homeworkContent != "" && staffHomework![index].homeworkContent != null
                                                                        //      ||
                                                                        // staffHomework![
                                                                        //         index]
                                                                        //     .homeworkContent
                                                                        //     .isNotEmpty
                                                                        ? const Text(
                                                                            "Edit",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                          )
                                                                        : const Text(
                                                                            "Add Task",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                          )),
                                                              )
                                                            : Container()
                                                        // Row(
                                                        //   mainAxisAlignment:
                                                        //       MainAxisAlignment
                                                        //           .spaceBetween,
                                                        //   children: [
                                                        //     const CircleAvatar(
                                                        //         backgroundImage:
                                                        //             AssetImage(
                                                        //                 "assets/images/icon.png")),
                                                        //     staffHomework![index]
                                                        //                     .homeworkContent !=
                                                        //                 "" ||
                                                        //             staffHomework![
                                                        //                     index]
                                                        //                 .images
                                                        //                 .isNotEmpty
                                                        //         ? Row(
                                                        //             children: [
                                                        //               const Icon(
                                                        //                 Icons
                                                        //                     .thumb_up,
                                                        //                 color:
                                                        //                     Colors.redAccent,
                                                        //                 size:
                                                        //                     20,
                                                        //               ),
                                                        //               const SizedBox(
                                                        //                 width:
                                                        //                     4,
                                                        //               ),
                                                        //               Text(
                                                        //                 //    "0",
                                                        //                 staffHomework![index]
                                                        //                     .completedCount
                                                        //                     .toString(),
                                                        //                 style:
                                                        //                     const TextStyle(color: Colors.black),
                                                        //               )
                                                        //             ],
                                                        //           )
                                                        //         : Container(),
                                                        //   ],
                                                        // )
                                                        // ListTileTheme(
                                                        //   contentPadding:
                                                        //       const EdgeInsets
                                                        //           .only(
                                                        //     left: 10,
                                                        //     right: 10,
                                                        //   ),
                                                        //   child: Theme(
                                                        //     data: Theme.of(
                                                        //             context)
                                                        //         .copyWith(
                                                        //             dividerColor:
                                                        //                 Colors
                                                        //                     .transparent),
                                                        //     child:
                                                        //         ExpansionTile(
                                                        //       leading: const CircleAvatar(
                                                        //           backgroundImage:
                                                        //               AssetImage(
                                                        //                   "assets/images/icon.png")
                                                        //           // NetworkImage(
                                                        //           //     homeWorks[index]['image']),
                                                        //           ),
                                                        //       trailing:
                                                        //           SizedBox(
                                                        //         width: 70,
                                                        //         child: Row(
                                                        //           mainAxisAlignment:
                                                        //               MainAxisAlignment
                                                        //                   .end,
                                                        //           children: [
                                                        //             staffHomework![index].homeworkContent !=
                                                        //                         "" ||
                                                        //                     staffHomework![index].images.isNotEmpty
                                                        //                 ? Row(
                                                        //                     children: [
                                                        //                       const Icon(
                                                        //                         Icons.thumb_up,
                                                        //                         color: Colors.redAccent,
                                                        //                         size: 20,
                                                        //                       ),
                                                        //                       const SizedBox(
                                                        //                         width: 4,
                                                        //                       ),
                                                        //                       Text(
                                                        //                         //    "0",
                                                        //                         staffHomework![index].completedCount.toString(),
                                                        //                         style: const TextStyle(color: Colors.black),
                                                        //                       )
                                                        //                     ],
                                                        //                   )
                                                        //                 : Container(),
                                                        //             const Icon(
                                                        //               Icons
                                                        //                   .arrow_drop_down_outlined,
                                                        //               size: 30,
                                                        //               color: Colors
                                                        //                   .black,
                                                        //             )
                                                        //           ],
                                                        //         ),
                                                        //       ),
                                                        //       title: Text(
                                                        //         staffHomework![
                                                        //                 index]
                                                        //             .subjectName,
                                                        //         style: const TextStyle(
                                                        //             color: Colors
                                                        //                 .black),
                                                        //       ),
                                                        //       subtitle: staffHomework![index]
                                                        //                       .homeworkContent !=
                                                        //                   "" ||
                                                        //               staffHomework![
                                                        //                       index]
                                                        //                   .images
                                                        //                   .isNotEmpty
                                                        //           ? TimeRemaining(
                                                        //               duration: const Duration(
                                                        //                   hours:
                                                        //                       4),
                                                        //               warningDuration:
                                                        //                   const Duration(
                                                        //                       minutes: 30),
                                                        //               warningsStyle:
                                                        //                   const TextStyle(
                                                        //                 fontSize:
                                                        //                     18,
                                                        //                 fontWeight:
                                                        //                     FontWeight.bold,
                                                        //                 color: Colors
                                                        //                     .green,
                                                        //               ),
                                                        //               style: TextStyle(
                                                        //                   color: Colors
                                                        //                       .blueGrey
                                                        //                       .shade500),
                                                        //               dangerDuration:
                                                        //                   const Duration(
                                                        //                       minutes: 10),
                                                        //               dangerStyle:
                                                        //                   const TextStyle(
                                                        //                 fontSize:
                                                        //                     18,
                                                        //                 fontWeight:
                                                        //                     FontWeight.bold,
                                                        //                 color: Colors
                                                        //                     .red,
                                                        //               ),
                                                        //               onTimeOver:
                                                        //                   () {},
                                                        //             )
                                                        //           : Container(),
                                                        //       childrenPadding:
                                                        //           const EdgeInsets
                                                        //                   .only(
                                                        //               top: 5,
                                                        //               left: 10,
                                                        //               right: 10,
                                                        //               bottom:
                                                        //                   10),
                                                        //       children: [
                                                        //         staffHomework![index].homeworkContent !=
                                                        //                     "" &&
                                                        //                 staffHomework![index].homeworkContent !=
                                                        //                     null
                                                        //             ? Container(
                                                        //                 width:
                                                        //                     350,
                                                        //                 height:
                                                        //                     104,
                                                        //                 decoration:
                                                        //                     BoxDecoration(
                                                        //                   borderRadius:
                                                        //                       BorderRadius.circular(7),
                                                        //                   border:
                                                        //                       Border.all(color: const Color(0xff9f9f9f)),
                                                        //                 ),
                                                        //                 child:
                                                        //                     Column(
                                                        //                   mainAxisAlignment:
                                                        //                       MainAxisAlignment.center,
                                                        //                   children: [
                                                        //                     Text(staffHomework![index].homeworkContent),
                                                        //                     const SizedBox(
                                                        //                       height: 10,
                                                        //                     ),
                                                        //                     FileListView(
                                                        //                       file: staffHomework![index].images,
                                                        //                       iconPath: Images.folderImg,
                                                        //                     )
                                                        //                   ],
                                                        //                 ),
                                                        //               )
                                                        //             : Column(
                                                        //                 children: [
                                                        //                   Container(
                                                        //                     width:
                                                        //                         350,
                                                        //                     height:
                                                        //                         32,
                                                        //                     decoration:
                                                        //                         BoxDecoration(
                                                        //                       borderRadius: BorderRadius.circular(7),
                                                        //                       border: Border.all(color: const Color(0xff9f9f9f)),
                                                        //                     ),
                                                        //                     child:
                                                        //                         Center(
                                                        //                       child: TextField(
                                                        //                         textAlign: TextAlign.center,
                                                        //                         controller: controllers[index],
                                                        //                         decoration: InputDecoration.collapsed(
                                                        //                           hintText: 'Type Your Text Here',
                                                        //                           hintStyle: SafeGoogleFont(
                                                        //                             'Inter',
                                                        //                             fontSize: 12,
                                                        //                             fontWeight: FontWeight.w400,
                                                        //                             height: 0.9152272542,
                                                        //                             letterSpacing: 1.2,
                                                        //                             color: const Color(0xff797979),
                                                        //                           ),
                                                        //                         ),
                                                        //                       ),
                                                        //                     ),
                                                        //                   ),
                                                        //                   const SizedBox(
                                                        //                     height:
                                                        //                         10,
                                                        //                   ),
                                                        //                   GestureDetector(
                                                        //                     onTap:
                                                        //                         () async {
                                                        //                       // ignore: no_leading_underscores_for_local_identifiers
                                                        //                       var _files = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: extensions);
                                                        //                       if (_files != null) {
                                                        //                         setState(() {
                                                        //                           files.addAll(_files.files);
                                                        //                         });
                                                        //                       }
                                                        //                     },
                                                        //                     child:
                                                        //                         Container(
                                                        //                       width: 350,
                                                        //                       height: 82,
                                                        //                       decoration: BoxDecoration(
                                                        //                         borderRadius: BorderRadius.circular(7),
                                                        //                         border: Border.all(color: const Color(0xff9f9f9f)),
                                                        //                       ),
                                                        //                       child: Column(
                                                        //                         mainAxisAlignment: MainAxisAlignment.center,
                                                        //                         children: [
                                                        //                           Container(
                                                        //                             height: 25,
                                                        //                             width: 25,
                                                        //                             decoration: const BoxDecoration(
                                                        //                                 image: DecorationImage(
                                                        //                                     image: NetworkImage(
                                                        //                                       ("https://cdn-icons-png.flaticon.com/128/6632/6632547.png"),
                                                        //                                     ),
                                                        //                                     fit: BoxFit.fill)),
                                                        //                           ),
                                                        //                           const SizedBox(
                                                        //                             height: 10,
                                                        //                           ),
                                                        //                           files.isEmpty
                                                        //                               ? Text(
                                                        //                                   "Please select files to upload",
                                                        //                                   style: SafeGoogleFont(
                                                        //                                     'Inter',
                                                        //                                     fontSize: 12,
                                                        //                                     fontWeight: FontWeight.w400,
                                                        //                                     height: 0.9152272542,
                                                        //                                     letterSpacing: 1.2,
                                                        //                                     color: const Color(0xff797979),
                                                        //                                   ),
                                                        //                                 )
                                                        //                               : FileListView(
                                                        //                                   file: files,
                                                        //                                   iconPath: Images.folderImg,
                                                        //                                 )
                                                        //                         ],
                                                        //                       ),
                                                        //                     ),
                                                        //                   ),
                                                        //                   const SizedBox(
                                                        //                     height:
                                                        //                         10,
                                                        //                   ),
                                                        //                 ],
                                                        //               ),
                                                        //         const SizedBox(
                                                        //           height: 5,
                                                        //         ),
                                                        //         staffHomework![index]
                                                        //                     .approvalStatus ==
                                                        //                 0
                                                        //             ? SizedBox(
                                                        //                 height:
                                                        //                     40,
                                                        //                 child: ElevatedButton(
                                                        //                     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black26)),
                                                        //                     onPressed: staffHomework![index].homeworkContent != "" && staffHomework![index].homeworkContent != null
                                                        //                         //     ||
                                                        //                         // staffHomework![
                                                        //                         //         index]
                                                        //                         //     .homeworkContent
                                                        //                         //     .isNotEmpty
                                                        //                         ? () {
                                                        //                             dialogbox(homedata: staffHomework![index], txt: staffHomework![index].homeworkContent, attch: staffHomework![index].images);
                                                        //                           }
                                                        //                         : () async {
                                                        //                             if (controllers[index].text.isNotEmpty && files.isEmpty) {
                                                        //                               await sendHomework(
                                                        //                                       notifyId: "",
                                                        //                                       fileList: files,
                                                        //                                       classConfig:
                                                        //                                           // "12",
                                                        //                                           widget.clasId,
                                                        //                                       msgCategory: "1",
                                                        //                                       subId:
                                                        //                                           //      "1",
                                                        //                                           staffHomework![index].subjectId.toString(),
                                                        //                                       msg: controllers[index].text)
                                                        //                                   .then((value) {
                                                        //                                 if (value != null) {
                                                        //                                   // Navigator.pop(context);
                                                        //                                   Utility.displaySnackBar(context, "Message send Successfully");
                                                        //                                 } else {
                                                        //                                   // Navigator.pop(context);
                                                        //                                   Utility.displaySnackBar(context, "Message not send");
                                                        //                                 }
                                                        //                                 initState();
                                                        //                               });
                                                        //                             } else if (controllers[index].text.isEmpty && files.isNotEmpty) {
                                                        //                               await sendHomework(notifyId: "", fileList: files, classConfig: widget.clasId, msgCategory: "3", subId: staffHomework![index].subjectId.toString(), msg: controllers[index].text).then((value) {
                                                        //                                 if (value != null) {
                                                        //                                   Navigator.pop(context);
                                                        //                                   Utility.displaySnackBar(context, "Message send Successfully");
                                                        //                                 } else {
                                                        //                                   Navigator.pop(context);
                                                        //                                   Utility.displaySnackBar(context, "Message not send");
                                                        //                                 }
                                                        //                                 initState();
                                                        //                               });
                                                        //                             } else if (controllers[index].text.isNotEmpty && files.isNotEmpty) {
                                                        //                               await sendHomework(notifyId: "", fileList: files, classConfig: widget.clasId, msgCategory: "2", subId: staffHomework![index].subjectId.toString(), msg: controllers[index].text).then((value) {
                                                        //                                 if (value != null) {
                                                        //                                   Utility.displaySnackBar(context, "Message send Successfully");
                                                        //                                 } else {
                                                        //                                   Navigator.pop(context);
                                                        //                                   Utility.displaySnackBar(context, "Message not send");
                                                        //                                 }
                                                        //                                 initState();
                                                        //                               });
                                                        //                             }
                                                        //                           },
                                                        //                     child: staffHomework![index].homeworkContent != "" && staffHomework![index].homeworkContent != null
                                                        //                         //      ||
                                                        //                         // staffHomework![
                                                        //                         //         index]
                                                        //                         //     .homeworkContent
                                                        //                         //     .isNotEmpty
                                                        //                         ? const Text(
                                                        //                             "Edit",
                                                        //                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                        //                           )
                                                        //                         : const Text(
                                                        //                             "Add Task",
                                                        //                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                        //                           )),
                                                        //               )
                                                        //             : Container()
                                                        //       ],
                                                        //     ),
                                                        //   ),
                                                        // )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            )),
                                      ),
                                    ))
                                  : Container(),
                              widget.date.day == DateTime.now().day
                                  ? Center(
                                      child: SizedBox(
                                        height: 40,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black26)),
                                            onPressed: () async {
                                              //notifyId
                                              await approveHomework(
                                                      notifyid: notifyId)
                                                  .then((value) {
                                                if (value != null) {
                                                  Navigator.pop(context);
                                                  Utility.displaySnackBar(
                                                      context,
                                                      "Message Approved Successfully");
                                                  setState(() {
                                                    notifyId.length = 0;
                                                  });
                                                } else {
                                                  Utility.displaySnackBar(
                                                      context,
                                                      "Message not Approved");
                                                  setState(() {
                                                    notifyId.length = 0;
                                                  });
                                                }
                                                initState();
                                              });
                                            },
                                            child: const Text(
                                              "Approve All",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            )),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> chatBottomSheet(BuildContext context, name, subject) {
  //   return showModalBottomSheet<void>(
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         return HomeWorkSendMessage(
  //           name: name,
  //           subject: subject,
  //         );
  //       });
  // }

  // Future<void> filterBottomSheet(BuildContext context) {
  //   return showModalBottomSheet<void>(
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: MediaQuery.of(context).size.height * 0.45,
  //         decoration: BoxDecoration(
  //             color: Colors.blue.shade50,
  //             boxShadow: [
  //               BoxShadow(
  //                   color: Colors.grey.withOpacity(.5),
  //                   offset: const Offset(3, 2),
  //                   blurRadius: 7)
  //             ],
  //             borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(24), topRight: Radius.circular(24)),
  //             image: DecorationImage(
  //               colorFilter: ColorFilter.mode(
  //                   Colors.blue.withOpacity(0.3), BlendMode.dstATop),
  //               image: const NetworkImage(
  //                   "https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg"),
  //               fit: BoxFit.cover,
  //             )),
  //         child: Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     'Filter by:',
  //                     style: Theme.of(context)
  //                         .textTheme
  //                         .titleLarge!
  //                         .copyWith(color: Colors.blueGrey.shade600),
  //                   ),
  //                   IconButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       icon: const Icon(
  //                         Icons.close,
  //                         size: 24,
  //                       ))
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   Text(
  //                     "Subjects",
  //                     style: Theme.of(context)
  //                         .textTheme
  //                         .bodyLarge!
  //                         .copyWith(color: Colors.blueGrey.shade600),
  //                   ),
  //                 ],
  //               ),
  //               Wrap(
  //                 children: [
  //                   for (int i = 0; i < filterSubjects.length; i++)
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 4, right: 4),
  //                       child: Chip(
  //                         label: Text(
  //                           filterSubjects[i],
  //                           style: const TextStyle(
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.w300),
  //                         ),
  //                         backgroundColor: Colors.blueGrey.shade400,
  //                       ),
  //                     )
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   Text(
  //                     "File",
  //                     style: Theme.of(context)
  //                         .textTheme
  //                         .bodyLarge!
  //                         .copyWith(color: Colors.blueGrey.shade600),
  //                   ),
  //                 ],
  //               ),
  //               Wrap(
  //                 children: [
  //                   for (int i = 0; i < filterFile.length; i++)
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 4, right: 4),
  //                       child: Chip(
  //                         label: Text(
  //                           filterFile[i],
  //                           style: const TextStyle(
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.w300),
  //                         ),
  //                         backgroundColor: Colors.blueGrey.shade400,
  //                       ),
  //                     )
  //                 ],
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               SizedBox(
  //                 height: 50,
  //                 width: MediaQuery.of(context).size.width * 0.8,
  //                 child: ElevatedButton(
  //                     style: ButtonStyle(
  //                         backgroundColor: MaterialStateProperty.all(
  //                             Colors.blueGrey.shade400)),
  //                     onPressed: () {},
  //                     child: const Text(
  //                       "Apply Filter",
  //                       style: TextStyle(
  //                           fontSize: 16, fontWeight: FontWeight.w300),
  //                     )),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> dialogbox(
      {required String txt,
      required List attch,
      required StaffHomework homedata}) async {
    TextEditingController txtController = TextEditingController();
    txtController.text = txt;
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(8.0),
            // <-- SEE HERE
            title: const Text('Edit Homework'),
            children: <Widget>[
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 350,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: const Color(0xff9f9f9f)),
                  ),
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: txtController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type Your Text Here',
                        hintStyle: SafeGoogleFont(
                          'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 0.9152272542,
                          letterSpacing: 1.2,
                          color: const Color(0xff797979),
                        ),
                      ),
                    ),
                  ),
                ),

                homedata.images == null || homedata.images.isEmpty
                    ? GestureDetector(
                        onTap: () async {
                          // ignore: no_leading_underscores_for_local_identifiers
                          var _files = await FilePicker.platform.pickFiles(
                              allowMultiple: true,
                              type: FileType.custom,
                              allowedExtensions: extensions);
                          if (_files != null) {
                            setState(() {
                              files.addAll(_files.files);
                            });
                          }
                          initState();
                        },
                        child: Container(
                          width: 350,
                          height: 137,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: const Color(0xff9f9f9f)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          ("https://cdn-icons-png.flaticon.com/128/6632/6632547.png"),
                                        ),
                                        fit: BoxFit.fill)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              files.isEmpty
                                  ? Text(
                                      "Please select files to upload",
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        height: 0.9152272542,
                                        letterSpacing: 1.2,
                                        color: const Color(0xff797979),
                                      ),
                                    )
                                  : FileListView(
                                      file: files,
                                    ),
                            ],
                          ),
                        ))
                    : GestureDetector(
                        onTap: () async {
                          // ignore: no_leading_underscores_for_local_identifiers
                          var _files = await FilePicker.platform.pickFiles(
                              allowMultiple: true,
                              type: FileType.custom,
                              allowedExtensions: extensions);
                          if (_files != null) {
                            setState(() {
                              files.addAll(_files.files);
                            });
                          }
                          initState();
                        },
                        child: Container(
                          width: 350,
                          height: 137,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: const Color(0xff9f9f9f)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          ("https://cdn-icons-png.flaticon.com/128/6632/6632547.png"),
                                        ),
                                        fit: BoxFit.fill)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // FileListView(
                              //   file: attch,
                              // ),
                            ],
                          ),
                        ),
                      ),
                // ),
              ]),
              SimpleDialogOption(
                onPressed: () async {
                  await sendHomework(
                          notifyId: homedata.notificationId.toString(),
                          fileList: files,
                          classConfig: widget.classId,
                          msgCategory: "2",
                          subId: homedata.subjectId.toString(),
                          msg: txtController.text)
                      .then((value) {
                    if (value != null) {
                      Navigator.pop(context);
                      Utility.displaySnackBar(
                          context, "Message Edited Successfully");
                    } else {
                      Navigator.pop(context);
                      Utility.displaySnackBar(context, "Message not Edited");
                    }
                    initState();
                  });
                },
                child: const Text(
                  'Submit',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        });
  }
}

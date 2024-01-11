// ignore_for_file: unnecessary_null_comparison, must_be_immutable
import 'dart:html';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_remaining/time_remaining.dart';
import 'package:ui/Utils/Utility.dart';
import 'package:ui/api/approve_home_work_api.dart';
import 'package:ui/api/deleteApi.dart';
import 'package:ui/api/edit_homework_api.dart';
import 'package:ui/api/homeWork/homework_status_api.dart';
import 'package:ui/api/home_work_api.dart';
import 'package:ui/api/homeworkapprovalapi.dart';
import 'package:ui/api/homeworkstatusapi.dart';
import 'package:ui/api/send_message_api.dart';
import 'package:ui/custom/file_listview.dart';
import 'package:ui/model/edit_homework_model.dart';
import 'package:ui/model/homeWork/homework_status_model.dart';
import 'package:ui/model/parenthomeworkmodel.dart';
import 'package:ui/model/staff_home_work_model.dart';
import 'package:ui/utils/session_management.dart';
import 'package:ui/utils/utils_file.dart';
import 'package:device_info/device_info.dart';

class HomeWorkPage extends StatefulWidget {
  HomeWorkPage({
    super.key,
    required this.isParent,
    required this.classId,
    this.className,
  });
  final bool isParent;
  final String classId;
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
  String index = '';

  var colorizeTextStyle = GoogleFonts.acme(
    fontSize: 27,
  );

  List<String> filterFile = ["PDF", "DOC", "PPT", "IMG", "XLC"];
  List<StaffHomework> staffHomework = [];
  List<PlatformFile> files = [];
  dynamic attached;
  bool taskAdded = false;
  int classIndex = 0;
  List<String> extensions = ['xlsx', 'pdf', 'jpg', 'jpeg', 'doc'];
  List<TextEditingController> controllers = [];
  List<HomeworkParent>? homeParent;
  final List<FilePickerResult> _files = [];
  List<String> notifyIds = [];
  String homeworkDate = "";
  String reason = "";
  String classTeacher = "";
  String approvedStatus = "";
  String content = '';
  String logId = '';
  int? stat;
  List<ImagesHw> pic = [];
  bool isApprove = false;
  List<EditHomeworkModel>? edithomework;

  String studentId = '';

  bool isAllApproved = false;
  bool noData = false;
  bool enableApproval = true;

  List<String> notifyId = [];
  String dates = "";
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      homeworkDate =
          Utility.convertDateFormat(_selectedDay.toString(), "yyyy-MM-dd");
    });
    getStudentId();
    getHomeWork(homeworkDate);
    setState(() {
      extensions = ['xlsx', 'pdf', 'jpg', 'jpeg', 'doc'];
    });
    dates = Utility.convertDateFormat(_selectedDay.toString(), "yyyy-MM-dd");
    initialize(dates);
  }

  void initialize(newDate) async {
    await getStaffHomework(newDate, widget.classId).then((value) {
      if (value != null) {
        setState(() {
          staffHomework = value;
          isLoading = false;
        });
      }
    });
  }

  getHomeWork(String homeworkDate) async {
    if (mounted) {
      await homeWork(homWorkDate: homeworkDate);
      SessionManager prefs = SessionManager();
      logId = (await prefs.getStudentId())!;
      setState(() {
        taskAdded = false;
      });
    }
  }

  updateHomeWork(String homeworkDate, int index) async {
    if (mounted) {
      await update(homWorkDate: homeworkDate, index: index);
      SessionManager prefs = SessionManager();
      logId = (await prefs.getStudentId())!;
      setState(() {
        taskAdded = false;
      });
    }
  }

  Future<void> update({required String homWorkDate, required int index}) async {
    await getStaffHomework(homWorkDate, widget.classId).then((value) {
      if (mounted) {
        if (value != null) {
          if (value.isEmpty) {
            setState(() {
              noData = true;
            });
          } else {
            setState(() {
              staffHomework[index] = value[index];
              classTeacher = value[0].flag;
            });
          }
        }
      }
    });
    updateData();
  }

  void updateData() {
    setState(() {
      var approvalData = [];
      var notificationData = [];
      for (int i = 0; i < staffHomework.length; i++) {
        approvalData.add(staffHomework[i].approvalStatus);
        notificationData.add(staffHomework[i].notificationId);
      }
      var data = approvalData.contains(0);
      isAllApproved = !data;
      var data2 = staffHomework
          .where((element) => element.notificationId != 0)
          .toList();
      var data3 = [];
      for (int i = 0; i < data2.length; i++) {
        data3.add(data2[i].approvalStatus);
      }
      enableApproval = data3.contains(0);
    });
  }

  Future<void> homeWork({required String homWorkDate}) async {
    await getStaffHomework(homWorkDate, widget.classId).then((value) {
      if (mounted) {
        if (value != null) {
          if (value.isEmpty) {
            setState(() {
              noData = true;
            });
          } else {
            setState(() {
              staffHomework = value;
              classTeacher = value[0].flag;
            });
          }
        }
      }
    });
    updateData();
  }

  void getStudentId() async {
    studentId = await SessionManager().getStudentId() ?? '';
  }

  Future<void> openFile({
    required String url,
    required String fileName,
  }) async {
    AnchorElement anchorElement = AnchorElement(href: url);
    anchorElement.download = fileName;
    anchorElement.click();
    // final file = await downloadFile(url, fileName);
    // if (file == null) {
    //   _snackBar('Unable to open Document');
    // } else {
    //   OpenFile.open(file.path);
    // }
  }

  _snackBar(String message) {
    if (message != '') {
      final snackBar = SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        duration: const Duration(milliseconds: 1000),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Future<File?> downloadFile(String url, String name) async {
  //   final appStorage = await getExternalStorageDirectory();
  //   final file = File('${appStorage!.path}/$name');
  //   try {
  //     final response = await Dio().get(url,
  //         options: Options(
  //           responseType: ResponseType.bytes,
  //         ));
  //     final raf = file.openSync(mode: FileMode.write);
  //     raf.writeFromSync(response.data);
  //     await raf.close();
  //     return file;
  //   } catch (e) {
  //     print('Error: $e');
  //     return null;
  //   }
  // }

  Future<dynamic> _showAlertDialog({required String id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              title: const Text(
                'Reason for not completing home work ?',
                style: TextStyle(fontSize: 14),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Row(
                      children: [
                        Radio(
                            activeColor: Colors.blue,
                            value: '1',
                            groupValue: index,
                            onChanged: (newValue) {
                              setState(() {
                                index = newValue.toString();
                                reason = "1";
                              });
                            }),
                        const Text('went out')
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            activeColor: Colors.blue,
                            value: '2',
                            groupValue: index,
                            onChanged: (newValue) {
                              setState(() {
                                index = newValue.toString();
                                reason = "2";
                              });
                            }),
                        const Text('Child is not feeling well')
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            activeColor: Colors.blue,
                            value: '3',
                            groupValue: index,
                            onChanged: (newValue) {
                              setState(() {
                                index = newValue.toString();
                                reason = "3";
                              });
                            }),
                        const Text('Others')
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () async {
                    await homeworkStatus(
                            aproval: "2",
                            notifyid: id,
                            reason: reason,
                            studentId: studentId)
                        .then((value) {
                      if (value != null) {
                        Utility.displaySnackBar(
                            context, "Status Updated Successfully");
                        Navigator.pop(ctx);
                        getHomeWork(homeworkDate);
                        index = " ";
                      } else {
                        Utility.displaySnackBar(context, "Status Not Updated");
                      }
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> editHomeWorkDialog(
      {required String txt,
      required List<EditHomeworkModel> fileimg,
      required BuildContext ctx,
      required EditHomeworkModel imgfile,
      required int aprove,
      required int index}) async {
    TextEditingController txtController = TextEditingController();
    txtController.text = txt;
    List<PlatformFile> newfiles = [];
    await showDialog<void>(
        context: ctx,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
            builder: (ctx, setState) {
              return SimpleDialog(
                contentPadding: const EdgeInsets.all(8.0),
                title: const Text('Edit Homework'),
                children: <Widget>[
                  SizedBox(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            textAlign: TextAlign.center,
                            controller: txtController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(5),
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
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                              onTap: () async {
                                var _files = await FilePicker.platform
                                    .pickFiles(
                                        allowMultiple: true,
                                        type: FileType.custom,
                                        allowedExtensions: extensions);
                                if (_files != null) {
                                  setState(() {
                                    newfiles.addAll(_files.files);
                                  });
                                  updateHomeWork(homeworkDate, index);
                                }
                              },
                              child: Container(
                                width: 350,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      color: const Color(0xff9f9f9f)),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
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
                                      imgfile.images.isNotEmpty
                                          ? SizedBox(
                                              width: 270,
                                              // height: 87,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    imgfile.images.length,
                                                itemBuilder: (context, idx) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          imgfile
                                                              .images[idx].image
                                                              .split('/')
                                                              .last,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      //
                                                      Expanded(
                                                        flex: 1,
                                                        child: IconButton(
                                                            onPressed:
                                                                () async {
                                                              await deleteHomework(
                                                                      fileId: imgfile
                                                                          .images[
                                                                              idx]
                                                                          .id
                                                                          .toString())
                                                                  .then(
                                                                      (value) {
                                                                if (value !=
                                                                    null) {
                                                                  setState(() {
                                                                    imgfile
                                                                        .images
                                                                        .removeAt(
                                                                            idx);
                                                                  });
                                                                  Utility.displaySnackBar(
                                                                      ctx,
                                                                      value[
                                                                          'message']);
                                                                }
                                                                getHomeWork(
                                                                    homeworkDate);
                                                              });
                                                            },
                                                            icon: const Icon(Icons
                                                                .cancel_rounded)),
                                                      )
                                                    ],
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(),
                                      FileListView(
                                        file: newfiles,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blueGrey.shade400)),
                    onPressed: () async {
                      await sendHomework(
                              homedate: '',
                              notifyId: imgfile.notificationId.toString(),
                              fileList: newfiles,
                              classConfig: widget.classId,
                              msgCategory: "2",
                              subId: imgfile.subjectId.toString(),
                              msg: txtController.text)
                          .then((value) {
                        if (value != null) {
                          Utility.displaySnackBar(
                              context, "Homework Updated Successfully");
                          Navigator.pop(ctx);
                          setState(() {
                            isApprove = true;
                            taskAdded = true;
                            classIndex = index;
                          });
                        } else {
                          Utility.displaySnackBar(
                              context, "Homework Not Updated");
                          Navigator.pop(ctx);
                        }
                        updateHomeWork(homeworkDate, index);
                      });
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  void completedNotCompletedDialog(
      {required List<HomeworkStatusModel> completedList,
      required bool isCompleted}) async {
    String dateOfHomework = "";
    double height = completedList.isEmpty ? 0.3 : 0.7;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          for (var i = 0; i < completedList.length; i++) {
            dateOfHomework = Utility.convertDateFormat(
                completedList[i].reportedTime.toString(), "dd-MMM-yyyy");
          }
          return SimpleDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            titlePadding: const EdgeInsets.all(8.0),
            title: completedList.isEmpty
                ? null
                : Align(
                    alignment: Alignment.center,
                    child: Text(
                        !isCompleted
                            ? "Not Completed ($dateOfHomework)"
                            : "Completed ($dateOfHomework)",
                        style: const TextStyle(fontSize: 18)),
                  ),
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.2,
                    maxHeight: MediaQuery.of(context).size.height * height),
                child: completedList.isEmpty
                    ? Center(
                        child: Lottie.asset(
                          'assets/lottie/no_data.json',
                          width: MediaQuery.of(context).size.width * 0.5,
                          repeat: true,
                          reverse: true,
                          animate: true,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: completedList.length,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  " ${index + 1}) ${completedList[index].studentName} (${Utility.convertTimeFormat(completedList[index].reportedTime.toString().split(" ").last)})",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                if (!isCompleted)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      completedList[index].reason == 1
                                          ? 'Reason: went out'
                                          : completedList[index].reason == 2
                                              ? 'Reason: Child is not feeling well'
                                              : 'Reason: others',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
              ),
            ],
          );
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
                            _focusedDay.toString(), "dd MMMM yyyy"),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                isLoading
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
                                  itemCount: staffHomework.length,
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
                                                      staffHomework[index]
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
                                                      staffHomework[index]
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
                                                percent: (staffHomework[index]
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
                                                      (staffHomework[index]
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
                              staffHomework != null && staffHomework.isNotEmpty
                                  ? homeWorkCard()
                                  : Container(),
                              classTeacher == "classteacher" &&
                                      DateTime.parse(homeworkDate).compareTo(
                                              DateTime.now().subtract(
                                                  const Duration(days: 1))) >
                                          0
                                  ? isAllApproved
                                      ? Container()
                                      : Center(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 8, bottom: 8),
                                            height: 45,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14.0),
                                                    )),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .black26)),
                                                onPressed: !enableApproval
                                                    ? () {
                                                        Utility.displaySnackBar(
                                                            context,
                                                            'No New Home work to Approve');
                                                      }
                                                    : () async {
                                                        var data = staffHomework
                                                            .where((element) =>
                                                                element
                                                                    .notificationId !=
                                                                0)
                                                            .toList();

                                                        var addedData = data
                                                            .where((element) =>
                                                                element
                                                                    .approvalStatus ==
                                                                0)
                                                            .toList();
                                                        await aproveHomework(
                                                                homeworkList:
                                                                    addedData)
                                                            .then((value) {
                                                          if (value != null) {
                                                            Navigator.pop(
                                                                context); //T icket No 61 - Homework Approve
                                                            Utility.displaySnackBar(
                                                                context,
                                                                value[
                                                                    'message']);
                                                          } else {
                                                            //Ticket No 61 - Homework Updated
                                                            Utility.displaySnackBar(
                                                                context,
                                                                value[
                                                                    'message']);
                                                          }
                                                          getHomeWork(
                                                              homeworkDate);
                                                        });
                                                      },
                                                child: const Text(
                                                  "Approve All",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                )),
                                          ),
                                        )
                                  : Container(),
                            ],
                          ),
                          Expanded(
                            child: Card(
                              color: Colors.grey.shade300,
                              child: TableCalendar(
                                firstDay: DateTime.utc(2022, 10, 16),
                                lastDay: DateTime.utc(2050, 3, 14),
                                focusedDay: _focusedDay,
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                    // update `_focusedDay` here as well
                                    var date = Utility.convertDateFormat(
                                        _selectedDay.toString(), "yyyy-MM-dd");
                                    initialize(date);
                                  });
                                },
                              ),
                            ),
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

  Widget homeWorkCard() {
    return SingleChildScrollView(
        child: Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.86,
        width: MediaQuery.of(context).size.width * 0.6,
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 320,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 320),
              itemCount: staffHomework.length,
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 15, right: 15),
              itemBuilder: (context, index) {
                notifyId.add(staffHomework[index].notificationId.toString());
                controllers.add(TextEditingController());
                _files.add(FilePickerResult(files));
                return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.shade200,
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.blue.withOpacity(0.3),
                                  BlendMode.dstATop),
                              image: const NetworkImage(
                                  "https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg"),
                              fit: BoxFit.cover,
                            )),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: staffHomework[index].profileImage == ''
                                  ? const CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/images/icon.png"))
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          staffHomework[index].profileImage),
                                    ),
                              title: Row(
                                children: [
                                  Text(
                                    staffHomework[index].subjectName,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  staffHomework[index].homeworkContent != "" ||
                                          staffHomework[index].images.isNotEmpty
                                      ? Row(
                                          children: [
                                            staffHomework[index].edited == 1
                                                ? Text(
                                                    "Edited",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 12),
                                                  )
                                                : Container(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              width: 30.0,
                                              child: IconButton(
                                                onPressed: () async {
                                                  await getHomeworkStatusList(
                                                          staffHomework[index]
                                                              .notificationId
                                                              .toString(),
                                                          "1")
                                                      .then((value) {
                                                    if (value != null) {
                                                      completedNotCompletedDialog(
                                                          completedList: value,
                                                          isCompleted: true);
                                                    }
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.thumb_up,
                                                  size: 18,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              staffHomework[index]
                                                  .completedCount
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              width: 30.0,
                                              child: IconButton(
                                                onPressed: () async {
                                                  await getHomeworkStatusList(
                                                          staffHomework[index]
                                                              .notificationId
                                                              .toString(),
                                                          "2")
                                                      .then((value) {
                                                    if (value != null) {
                                                      completedNotCompletedDialog(
                                                          completedList: value,
                                                          isCompleted: false);
                                                    }
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.thumb_down,
                                                  size: 18,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              staffHomework[index]
                                                  .notCompletedStudents
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            staffHomework[index].notificationId != 0 ||
                                    staffHomework[index].images.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: const Color(0xff9f9f9f)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(staffHomework[index]
                                            .homeworkContent),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: staffHomework[index]
                                              .images
                                              .length,
                                          itemBuilder: (context, idx) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5.0,
                                                  left: 5,
                                                  right: 5),
                                              height: 42.0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      staffHomework[index]
                                                          .images[idx]['image']
                                                          .split('/')
                                                          .last,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  //
                                                  Expanded(
                                                    flex: 1, //
                                                    child: IconButton(
                                                        onPressed: () async {
                                                          openFile(
                                                            url: staffHomework[
                                                                        index]
                                                                    .images[idx]
                                                                ["image"],
                                                            fileName:
                                                                staffHomework[
                                                                        index]
                                                                    .images[idx]
                                                                        [
                                                                        "image"]
                                                                    .split('/')
                                                                    .last,
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .arrow_circle_down_rounded,
                                                          color: staffHomework[
                                                                          index]
                                                                      .approvalStatus ==
                                                                  1
                                                              ? Colors.red
                                                              : Colors.black,
                                                        )),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        width: 350,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          border: Border.all(
                                              color: const Color(0xff9f9f9f)),
                                        ),
                                        child: Center(
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.done,
                                            initialValue: staffHomework[index]
                                                .homeworkContent,
                                            keyboardType: TextInputType.text,
                                            minLines: 1,
                                            maxLines: 1,
                                            cursorColor: Colors.black45,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0),
                                                borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 2.0,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0),
                                                borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 2.0,
                                                ),
                                              ),
                                            ),
                                            onChanged: (text) {
                                              setState(() {
                                                staffHomework[index]
                                                    .homeworkContent = text;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          var attachments = await FilePicker
                                              .platform
                                              .pickFiles(
                                                  allowMultiple: true,
                                                  type: FileType.custom,
                                                  allowedExtensions:
                                                      extensions);
                                          setState(() {
                                            staffHomework[index]
                                                .attachments
                                                .addAll(attachments!.files);
                                          });
                                        },
                                        child: Container(
                                          width: 350,
                                          height: 112,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            border: Border.all(
                                                color: const Color(0xff9f9f9f)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                              staffHomework[index]
                                                              .attachments ==
                                                          null &&
                                                      staffHomework[index]
                                                          .attachments
                                                          .isEmpty
                                                  ? Text(
                                                      "Please select files to upload",
                                                      style: SafeGoogleFont(
                                                        'Inter',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 0.9152272542,
                                                        letterSpacing: 1.2,
                                                        color: const Color(
                                                            0xff797979),
                                                      ),
                                                    )
                                                  : FileListView(
                                                      file: staffHomework[index]
                                                          .attachments,
                                                    )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            staffHomework[index].approvalStatus == 0
                                ? SizedBox(
                                    height: 40,
                                    child: DateTime.parse(homeworkDate)
                                                .compareTo(DateTime.now()
                                                    .subtract(const Duration(
                                                        days: 1))) >
                                            0
                                        ? Visibility(
                                            visible: !taskAdded,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .black26)),
                                                onPressed: staffHomework[index]
                                                            .notificationId !=
                                                        0
                                                    ? () async {
                                                        await getEditHomeworklist(
                                                                homeworkDate,
                                                                widget.classId)
                                                            .then((value) {
                                                          if (value != null) {
                                                            setState(() {
                                                              edithomework =
                                                                  value;
                                                              enableApproval =
                                                                  false;
                                                              editHomeWorkDialog(
                                                                ctx: context,
                                                                aprove: edithomework![
                                                                        index]
                                                                    .approvalStatus,
                                                                txt: staffHomework[
                                                                        index]
                                                                    .homeworkContent,
                                                                fileimg:
                                                                    edithomework!,
                                                                index: index,
                                                                imgfile:
                                                                    edithomework![
                                                                        index],
                                                              );
                                                            });
                                                          }
                                                        });
                                                      }
                                                    : () async {
                                                        if (staffHomework[index]
                                                            .homeworkContent
                                                            .isNotEmpty) {
                                                          setState(() {
                                                            taskAdded = true;
                                                          });
                                                          await sendHomework(
                                                                  homedate:
                                                                      homeworkDate,
                                                                  notifyId: "",
                                                                  fileList: staffHomework[
                                                                          index]
                                                                      .attachments,
                                                                  classConfig:
                                                                      widget
                                                                          .classId,
                                                                  msgCategory: staffHomework[
                                                                              index]
                                                                          .attachments
                                                                          .isEmpty
                                                                      ? "1"
                                                                      : "2",
                                                                  subId: staffHomework[
                                                                          index]
                                                                      .subjectId
                                                                      .toString(),
                                                                  msg: staffHomework[
                                                                          index]
                                                                      .homeworkContent)
                                                              .then((value) {
                                                            if (value != null) {
                                                              setState(() {
                                                                enableApproval =
                                                                    false;
                                                                isApprove =
                                                                    true;
                                                              });
                                                              Utility.displaySnackBar(
                                                                  context,
                                                                  "Task Added Successfully");
                                                            } else {
                                                              Utility.displaySnackBar(
                                                                  context,
                                                                  "Task not Added");
                                                            }
                                                          });
                                                          updateHomeWork(
                                                              homeworkDate,
                                                              index);
                                                          initialize(
                                                              homeworkDate);
                                                        } else {
                                                          Utility.displaySnackBar(
                                                              context,
                                                              "Homework Title is Empty");
                                                        }
                                                      },
                                                child: Text(
                                                  staffHomework[index]
                                                              .notificationId !=
                                                          0
                                                      ? "Edit"
                                                      : "Add Task",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                )),
                                          )
                                        : Container(),
                                  )
                                : Container()
                          ]),
                        )));
              },
            )),
      ),
    ));
  }

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
                          msg: txtController.text,
                          homedate: '')
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

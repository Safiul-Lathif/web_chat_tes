// ignore_for_file: file_names, must_be_immutable
import 'dart:convert';
import 'dart:io';

import 'package:expandable_text/expandable_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ui/Utils/Utility.dart';
import 'package:ui/api/class_group_api.dart';
import 'package:ui/api/search/get_admin_list_api.dart';
import 'package:ui/api/sendTextApi.dart';
import 'package:ui/config/images.dart';
import 'package:ui/controllers/image_controller.dart';
import 'package:ui/custom/file_listview.dart';
import 'package:ui/custom/filelistviewnew.dart';
import 'package:ui/model/all_group_list.dart';
import 'package:ui/model/classModel.dart';
import 'package:ui/model/group/student_group_list_model.dart';
import 'package:ui/model/image/get_image_model.dart';
import 'package:ui/model/search/admin_list_model.dart';
import 'package:ui/model/search/management_list_model.dart';
import 'package:ui/utils/utils_file.dart';
import 'package:ui/widget/photo_view_page.dart';
import '../api/group/student_group_list.dart';
import '../api/message_visible_count_api.dart';
import '../api/search/get_management_list_api.dart';
import '../model/message_visiblecount.dart';
// import 'package:filepicker_windows/filepicker_windows.dart';

class MessageWidget extends StatefulWidget {
  MessageWidget({
    super.key,
    required this.focusNode,
    required this.id,
    required this.role,
    required this.name,
  });
  final FocusNode focusNode;
  String id;
  String name;
  String role;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool isEveryone = true;
  bool isTeacher = false;
  bool isParent = false;
  bool isTapped = false;

  bool? select;
  int distributionType = 3;
  int category = 0;
  int count = 0;

  TextEditingController textController = TextEditingController();
  TextEditingController textTitleController = TextEditingController();
  TextEditingController imgController = TextEditingController();
  TextEditingController quoteController = TextEditingController();
  TextEditingController speaksController = TextEditingController();
  TextEditingController videoLinkController = TextEditingController();
  TextEditingController videoCaptionController = TextEditingController();
  TextEditingController circularController = TextEditingController();
  TextEditingController docController = TextEditingController();
  TextEditingController materialController = TextEditingController();
  ImagePicker picker = ImagePicker();

  List<PlatformFile> image = [];
  List<PlatformFile> images = [];
  List<XFile> img = [];

  List<PlatformFile> document = [];
  List<PlatformFile> material = [];
  double sizeInMb = 0.0;
  String errorText = '';

  void pickDoc() async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'xlsx', 'xls', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        document.addAll(result.files);
      });
    }
  }

  void pickMaterial() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf', 'xlsx', 'xls', 'doc', 'docx'],
    );
    if (result != null) {
      material.clear();
      setState(() {
        material.addAll(result.files);
      });
    }
  }

  void pickFile() {
    // final file = OpenFilePicker()
    //   ..filterSpecification = {
    //     'Word Document (*.doc)': '*.doc',
    //     'Web Page (*.htm; *.html)': '*.htm;*.html',
    //     'Text Document (*.txt)': '*.txt',
    //     'All Files': '*.*'
    //   }
    //   ..defaultFilterIndex = 0
    //   ..defaultExtension = 'doc'
    //   ..title = 'Select a document';

    // final result = file.getFile();
    // if (result != null) {
    //   // setState(() {
    //   //   document.addAll(result.path as Iterable<PlatformFile>);
    //   // });
    //   print(result.path);
    // }
  }

  MessageVisibleCount? msgCount;
  @override
  void initState() {
    super.initState();
    initialize();
    getAllTheGroup();
  }

  List colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
  ];
  List<bool> studentSelect = [];
  ClassGroup? class_;
  GroupList? groupList;
  int groupCount = 0;
  List<StudentGroupList> studentGroupList = [];
  List<ManagementList> managementList = [];
  List<AdminList> listOfAdmin = [];

  List<String> menuItems = [];
  List<String> classWise = [];
  List<String> sectionWise = [];
  List<String> managementWise = [];
  List<String> selectedItems = [];

  void getAllTheGroup() async {
    if (widget.id == "2") {
      await getClassList().then((value) {
        if (mounted) {
          setState(() {
            groupList = value;
            for (int i = 0; i < groupList!.classes.length; i++) {
              classWise.add(groupList!.classes[i].className);
            }
          });
        }
      });
      await getClassGroup().then((value) {
        if (mounted) {
          setState(() {
            class_ = value;
            for (int i = 0; i < class_!.classGroup.length; i++) {
              sectionWise.add(class_!.classGroup[i].groupName);
            }
          });
        }
      });
    } else if (widget.name.toUpperCase() == "ADMIN-MANAGEMENT") {
      if (widget.role.toUpperCase() == "MANAGEMENT") {
        await getAdminList(0).then((value) {
          setState(() {
            dropDownTitle = "Select Individual Admin";
            listOfAdmin = value!.data;
            for (int i = 0; i < value.data.length; i++) {
              menuItems.add(listOfAdmin[i].firstName);
            }
          });
        });
      } else {
        await getManagementList(0).then((value) => {
              setState(() {
                dropDownTitle = "Select Individual Management";
                managementList = value!.data;
                for (int i = 0; i < value.data.length; i++) {
                  menuItems.add(managementList[i].firstName);
                }
              })
            });
      }
    } else {
      await getStudentGroupList(widget.id).then((value) {
        if (mounted) {
          setState(() {
            studentGroupList = value!;
            for (int i = 0; i < value.length; i++) {
              menuItems.add(studentGroupList[i].name);
            }
          });
        }
      });
    }
  }

  bool isSelected = false;
  bool isClassWise = true;
  bool isSectionWise = true;
  void initialize() async {
    if (widget.name.toUpperCase() == "ADMIN-MANAGEMENT") {
      setState(() {
        distributionType = 9;
      });
    }
    await getVisibleCount(widget.id).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            msgCount = value;
            count = (int.parse(msgCount!.admin.length.toString()) +
                int.parse(msgCount!.management.length.toString()) +
                int.parse(msgCount!.parent.length.toString()) +
                int.parse(msgCount!.staff.length.toString()));
            groupCount = (int.parse(msgCount!.admin.length.toString()) +
                int.parse(msgCount!.management.length.toString()) +
                int.parse(msgCount!.staff.length.toString()));
          });
        }
      }
    });
  }

  Color color = Colors.orange;
  String selected = "";
  String text = 'Everyone';
  String visibilityMessage = 'Visible to ';
  bool isMessageSend = true;
  String dropDownTitle = '';
  String errorImage = '';

  List checkListItems = [
    {
      "width": 0.16,
      "id": 3,
      "value": true,
      "fl": 4,
      "title": "Everyone",
    },
    {
      "width": 0.15,
      "id": 4,
      "value": false,
      "fl": 5,
      "title": "ClassWise",
    },
    {
      "width": 0.17,
      "id": 5,
      "value": false,
      "fl": 4,
      "title": "Parents",
    },
  ];

  List checkListItems1 = [
    {
      "width": 0.15,
      "id": 3,
      "value": true,
      "title": "Everyone",
    },
    {
      "width": 0.15,
      "id": 4,
      "value": false,
      "title": "StudentWise",
    },
    {
      "width": 0.15,
      "id": 5,
      "value": false,
      "title": "Parents",
    },
  ];
  List checkListItems2 = [
    {
      "width": 0.15,
      "id": 9,
      "value": true,
      "title": "Everyone",
    },
    {
      "width": 0.15,
      "id": 9,
      "value": false,
      "title": "ManagementWise",
    },
  ];
  List checkListItems3 = [
    {
      "width": 0.15,
      "id": 9,
      "value": true,
      "title": "Everyone",
    },
    {
      "width": 0.15,
      "id": 9,
      "value": false,
      "title": "AdminWise",
    },
  ];
  @override
  Widget build(BuildContext context) {
    double baseWidth = 1514;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            color: Colors.blue.shade50,
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.blue.withOpacity(0.3), BlendMode.dstATop),
              image: const AssetImage(Images.bgImage),
              fit: BoxFit.fill,
            )),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Icon(Icons.arrow_drop_down),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      // group38wXp (7:1664)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 10 * fem, 0 * fem),
                      width: 25 * fem,
                      height: 24 * fem,
                      child: Image.asset(
                        checkListItems[0]["value"]
                            ? 'assets/images/group-38-ZQv.png'
                            : checkListItems[2]["value"]
                                ? 'assets/images/parentIcon.png'
                                : 'assets/images/teacherIcon.png',
                        width: 25 * fem,
                        height: 24 * fem,
                      ),
                    ),
                    Container(
                      // group18dfY (7:1623)
                      width: 130.5 * fem,
                      height: 25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            checkListItems[2]["value"]
                                ? 'assets/images/parents.png'
                                : checkListItems[0]["value"]
                                    ? 'assets/images/rectangle-7-55t.png'
                                    : 'assets/images/teacher.png',
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          checkListItems[0]["value"] ? 'EveryOne' : text,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.2125 * ffem / fem,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    border: Border.all(color: color),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4 * fem,
                        height: 30 * fem,
                        child: Text(
                          count <= 1
                              ? "This message will be visible for $count user"
                              : "This message will be visible for $count users",
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 0.915227294 * ffem / fem,
                            letterSpacing: 1.6 * fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                      DefaultTabController(
                          length: widget.role == 'staff' ? 5 : 8,
                          initialIndex: 0,
                          child: Column(children: <Widget>[
                            TabBar(
                              indicatorColor: Colors.blue.shade50,
                              isScrollable: true,
                              onTap: (value) {
                                setState(() {
                                  textController.text = '';
                                  textTitleController.text = '';
                                  imgController.text = '';
                                  speaksController.text = '';
                                  materialController.text = '';
                                  videoCaptionController.text = '';
                                  videoLinkController.text = '';
                                  circularController.text = '';
                                  docController.text = '';
                                  document = [];
                                  material = [];
                                  image = [];
                                });
                              },
                              labelPadding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              labelStyle: SafeGoogleFont(
                                'Inter',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 0.9152272542 * ffem / fem,
                                letterSpacing: 1.2 * fem,
                                color: const Color(0xff000000),
                                decoration: TextDecoration.underline,
                                decorationColor: const Color(0xff2c5ec0),
                              ),
                              labelColor: Colors.blue.shade800,
                              unselectedLabelStyle:
                                  const TextStyle(color: Colors.black),
                              unselectedLabelColor: Colors.black,
                              tabs: [
                                TabWidget(
                                  text: 'text',
                                  assetImage: const AssetImage(
                                      "assets/images/text_icon.png"),
                                ),
                                TabWidget(
                                    assetImage: const AssetImage(
                                        "assets/images/document.png"),
                                    text: 'Document'),
                                TabWidget(
                                    assetImage: const AssetImage(
                                        "assets/images/video_icon.png"),
                                    text: 'Video'),
                                TabWidget(
                                    assetImage: const AssetImage(
                                        "assets/images/material.png"),
                                    text: 'Material'),
                                TabWidget(
                                    assetImage: const AssetImage(
                                        "assets/images/images.png"),
                                    text: 'Image'),
                                if (widget.role != 'staff')
                                  TabWidget(
                                      assetImage: const AssetImage(
                                          "assets/images/quote.png"),
                                      text: 'Quote'),
                                if (widget.role != 'staff')
                                  TabWidget(
                                      assetImage: const AssetImage(
                                          "assets/images/speaks.png"),
                                      text: 'Speaks'),
                                if (widget.role != 'staff')
                                  TabWidget(
                                      assetImage: const AssetImage(
                                          "assets/images/circular.png"),
                                      text: 'Circular'),
                              ],
                            ),
                            SizedBox(
                              height: 150,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TabBarView(children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4 *
                                          fem,
                                      height: 100 * fem,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7 * fem),
                                        border: Border.all(
                                            color: const Color(0xff9f9f9f)),
                                      ),
                                      child: Center(
                                        child: TextField(
                                          controller: textController,
                                          focusNode: widget.focusNode,
                                          textAlign: TextAlign.center,
                                          maxLines: 10,
                                          decoration: InputDecoration.collapsed(
                                            hintText: 'Type Your Text Here',
                                            hintStyle: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 12 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 0.9152272542 * ffem / fem,
                                              letterSpacing: 1.2 * fem,
                                              color: const Color(0xff797979),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7 * fem),
                                        border: Border.all(
                                            color: const Color(0xff9f9f9f)),
                                      ),
                                      child: Center(
                                        child: TextField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                100),
                                          ],
                                          controller: docController,
                                          focusNode: widget.focusNode,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration.collapsed(
                                            hintText: 'Add Document Caption',
                                            hintStyle: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 12 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 0.9152272542 * ffem / fem,
                                              letterSpacing: 1.2 * fem,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4 *
                                          fem,
                                      height: 102 * fem,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7 * fem),
                                        border: Border.all(
                                            color: const Color(0xff9f9f9f)),
                                      ),
                                      child: InkWell(
                                        onTap: pickDoc,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                            "https://cdn-icons-png.flaticon.com/128/3143/3143540.png",
                                                          ),
                                                          fit: BoxFit.fill)),
                                                ),
                                              ),
                                              document.isEmpty
                                                  ? Text(
                                                      "Please select Documents files to upload",
                                                      style: SafeGoogleFont(
                                                        'Inter',
                                                        fontSize: 12 * ffem,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 0.9152272542 *
                                                            ffem /
                                                            fem,
                                                        letterSpacing:
                                                            1.2 * fem,
                                                        color: const Color(
                                                            0xff797979),
                                                      ),
                                                    )
                                                  : FileListView(
                                                      file: document,
                                                    ),
                                            ])
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7 * fem),
                                        border: Border.all(
                                            color: const Color(0xff9f9f9f)),
                                      ),
                                      child: Center(
                                        child: TextField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                100),
                                          ],
                                          controller: videoCaptionController,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration.collapsed(
                                            hintText:
                                                'Add Caption about the video Here',
                                            hintStyle: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 12 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 0.9152272542 * ffem / fem,
                                              letterSpacing: 1.2 * fem,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4 *
                                          fem,
                                      height: 102 * fem,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7 * fem),
                                        border: Border.all(
                                            color: const Color(0xff9f9f9f)),
                                      ),
                                      child: Center(
                                        child: TextField(
                                          controller:
                                              videoLinkController, //Ticket No 17
                                          textAlign: TextAlign.center,

                                          maxLines: 10,
                                          decoration: InputDecoration.collapsed(
                                            hintText: //Ticket No 17
                                                "Paste your video link \n\n (for Multiple links use comma ',' at end of each link)",
                                            hintStyle: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 12 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 0.9152272542 * ffem / fem,
                                              letterSpacing: 1.2 * fem,
                                              color: const Color(0xff797979),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7 * fem),
                                        border: Border.all(
                                            color: const Color(0xff9f9f9f)),
                                      ),
                                      child: Center(
                                        child: TextField(
                                          //Ticket No
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                100),

                                            /// here char limit is 5
                                          ],
                                          controller: materialController,

                                          focusNode: widget.focusNode,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration.collapsed(
                                            hintText:
                                                'Add Material Caption Here',
                                            hintStyle: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 12 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 0.9152272542 * ffem / fem,
                                              letterSpacing: 1.2 * fem,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4 *
                                          fem,
                                      height: 105 * fem,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7 * fem),
                                        border: Border.all(
                                            color: const Color(0xff9f9f9f)),
                                      ),
                                      //Ticket No 30
                                      child: InkWell(
                                          onTap: pickMaterial,
                                          child: Column(
                                            mainAxisAlignment:
                                                //
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 25,
                                                width: 25,
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          "https://cdn-icons-png.flaticon.com/128/1981/1981438.png",
                                                        ),
                                                        fit: BoxFit.fill)),
                                              ),
                                              material.isEmpty
                                                  ? Text(
                                                      "Please select Material files to upload",
                                                      style: SafeGoogleFont(
                                                        'Inter',
                                                        fontSize: 12 * ffem,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 0.9152272542 *
                                                            ffem /
                                                            fem,
                                                        letterSpacing:
                                                            1.2 * fem,
                                                        color: const Color(
                                                            0xff797979),
                                                      ),
                                                    )
                                                  : FileListView(
                                                      file: material,
                                                    ),
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7 * fem),
                                        border: Border.all(
                                            color: const Color(0xff9f9f9f)),
                                      ),
                                      child: Center(
                                        child: TextField(
                                          //Ticket No
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                100),

                                            /// here char limit is 5
                                          ],
                                          controller: imgController,

                                          focusNode: widget.focusNode,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration.collapsed(
                                            hintText: 'Add image caption Here',
                                            hintStyle: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 12 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 0.9152272542 * ffem / fem,
                                              letterSpacing: 1.2 * fem,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4 *
                                          fem,
                                      height: 102 * fem,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7 * fem),
                                        border: Border.all(
                                            color: const Color(0xff9f9f9f)),
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          var getImage = await ImageController
                                              .pickAndProcessImage();
                                          if (getImage.images.isNotEmpty) {
                                            imageView(getImage);
                                          }
                                          if (getImage.errorText != '') {
                                            setState(() {
                                              errorImage = getImage.errorText;
                                            });
                                          }
                                        },
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
                                            images.isEmpty
                                                ? Text(
                                                    "Please select image files to upload",
                                                    style: SafeGoogleFont(
                                                      'Inter',
                                                      fontSize: 12 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0.9152272542 *
                                                          ffem /
                                                          fem,
                                                      letterSpacing: 1.2 * fem,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : FileListViewNew(
                                                    file: images,
                                                    iconPath: Images.folderImg)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                if (widget.role != 'staff')
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4 *
                                                fem,
                                        height: 102 * fem,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7 * fem),
                                          border: Border.all(
                                              color: const Color(0xff9f9f9f)),
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: quoteController,
                                            focusNode: widget.focusNode,
                                            textAlign: TextAlign.center,
                                            maxLines: 10,
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText: 'Type Your Quotes Here',
                                              hintStyle: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 12 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height:
                                                    0.9152272542 * ffem / fem,
                                                letterSpacing: 1.2 * fem,
                                                color: const Color(0xff797979),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (widget.role != 'staff')
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4 *
                                                fem,
                                        height: 102 * fem,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7 * fem),
                                          border: Border.all(
                                              color: const Color(0xff9f9f9f)),
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: speaksController,
                                            focusNode: widget.focusNode,
                                            textAlign: TextAlign.center,
                                            maxLines: 10,
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText:
                                                  'Type Announcements here',
                                              hintStyle: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 12 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height:
                                                    0.9152272542 * ffem / fem,
                                                letterSpacing: 1.2 * fem,
                                                color: const Color(0xff797979),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (widget.role != 'staff')
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4 *
                                                fem,
                                        height: 102 * fem,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7 * fem),
                                          border: Border.all(
                                              color: const Color(0xff9f9f9f)),
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: circularController,
                                            focusNode: widget.focusNode,
                                            textAlign: TextAlign.center,
                                            maxLines: 10,
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText: 'Type Circular here',
                                              hintStyle: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 12 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height:
                                                    0.9152272542 * ffem / fem,
                                                letterSpacing: 1.2 * fem,
                                                color: const Color(0xff797979),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ]),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  widget.id == "1" ||
                                          widget.id == '3' ||
                                          widget.id == '4' ||
                                          widget.id == '5'
                                      ? Container()
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: ExpandableText(
                                            visibilityMessage,
                                            expandText: 'show more',
                                            collapseText: 'show less',
                                            maxLines: 3,
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 12 * ffem,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1.2 * fem,
                                              color: const Color(0xff303030),
                                            ),
                                            linkColor: Colors.blue,
                                          ),
                                        ),
                                  Visibility(
                                    visible: !isTapped,
                                    child: InkWell(
                                      onTap: !isTapped && isMessageSend
                                          ? onMessageSend
                                          : null,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0 * fem, 3 * fem, 2 * fem, 0 * fem),
                                        width: 55 * fem,
                                        height: 22 * fem,
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius:
                                              BorderRadius.circular(10 * fem),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0x93000000),
                                              offset: Offset(-1 * fem, 1 * fem),
                                              blurRadius: 2 * fem,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                                top: 6,
                                                bottom: 3),
                                            child: Text(
                                              'Send',
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 12 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height:
                                                    0.9152272542 * ffem / fem,
                                                letterSpacing: 1.2 * fem,
                                                color: const Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 35,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  itemCount: widget.id == "1" ||
                                          widget.id == '3' ||
                                          widget.id == '4' ||
                                          widget.id == '5'
                                      ? 1
                                      : widget.name.toUpperCase() ==
                                              "ADMIN-MANAGEMENT"
                                          ? 2
                                          : checkListItems.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    checkListItems[0]['title'] = widget.name;
                                    var width = widget.name.toUpperCase() ==
                                            "ADMIN-MANAGEMENT"
                                        ? checkListItems2[index]['width']
                                        : widget.id == '2'
                                            ? checkListItems[index]['width']
                                            : checkListItems1[index]['width'];
                                    return Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              width),
                                      child: CheckboxListTile(
                                        visualDensity: const VisualDensity(
                                            horizontal: -4.0, vertical: -4.0),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        title: Transform.translate(
                                          offset: const Offset(-10, 0),
                                          child: Text(
                                            widget.id == '2'
                                                ? checkListItems[index]["title"]
                                                : widget.name.toUpperCase() ==
                                                            "ADMIN-MANAGEMENT" &&
                                                        widget.role
                                                                .toUpperCase() ==
                                                            "ADMIN"
                                                    ? checkListItems2[index]
                                                        ["title"]
                                                    : widget.name.toUpperCase() ==
                                                                "ADMIN-MANAGEMENT" &&
                                                            widget.role
                                                                    .toUpperCase() ==
                                                                "MANAGEMENT"
                                                        ? checkListItems3[index]
                                                            ['title']
                                                        : checkListItems1[index]
                                                            ['title'],
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              height: 0.9152272542 * ffem / fem,
                                              letterSpacing: 1,
                                              color: const Color(0xff8e8e8e),
                                            ),
                                          ),
                                        ),
                                        activeColor: checkListItems[0]["value"]
                                            ? const Color(0xfff98a1d)
                                            : checkListItems[1]["value"]
                                                ? Colors.green
                                                : Colors.pink,
                                        value: checkListItems[index]["value"],
                                        onChanged:
                                            widget.id == "1" ||
                                                    widget.id == '3' ||
                                                    widget.id == '4' ||
                                                    widget.id == '5'
                                                ? null
                                                : (value) {
                                                    HapticFeedback.vibrate();
                                                    if (index == 1) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => widget
                                                                        .id !=
                                                                    '2' &&
                                                                studentGroupList
                                                                    .isEmpty &&
                                                                widget.name
                                                                        .toUpperCase() !=
                                                                    "ADMIN-MANAGEMENT"
                                                            ? const AlertDialog(
                                                                title: Text(
                                                                    "No students in the group"),
                                                              )
                                                            : widget.id == '2'
                                                                ? AlertDialog(
                                                                    actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                for (var element in checkListItems) {
                                                                                  element["value"] = false;
                                                                                }
                                                                                checkListItems[index]["value"] = value;
                                                                                visibilityMessage = selectedItems.toString();
                                                                                errorText = '';
                                                                                List<int> selectedIds = [];
                                                                                if (distributionType == 6) {
                                                                                  for (int i = 0; i < selectedItems.length; i++) {
                                                                                    selectedIds.add(class_!.classGroup.firstWhere((element) => element.groupName == selectedItems[i]).allUserCount.toInt());
                                                                                  }
                                                                                } else {
                                                                                  for (int i = 0; i < selectedItems.length; i++) {
                                                                                    selectedIds.add(groupList!.classes.firstWhere((element) => element.className == selectedItems[i]).totalCount);
                                                                                  }
                                                                                }
                                                                                var totalCount = selectedIds.reduce((value, element) => value + element);
                                                                                count = totalCount;
                                                                                color = Colors.green;
                                                                                text = "ClassWise";
                                                                                isMessageSend = value!;
                                                                              });
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text("Ok"))
                                                                      ],
                                                                    title: const Text(
                                                                        'Select Classes'),
                                                                    content:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          StatefulBuilder(
                                                                        builder:
                                                                            (context,
                                                                                setState) {
                                                                          return Column(
                                                                            children: [
                                                                              Visibility(
                                                                                visible: isSectionWise,
                                                                                child: MultiSelectDialogField(
                                                                                  items: sectionWise.map((e) => MultiSelectItem(e, e)).toList(),
                                                                                  listType: MultiSelectListType.CHIP,
                                                                                  buttonText: const Text("Select section wise"),
                                                                                  onConfirm: (List<String> values) {
                                                                                    setState(() {
                                                                                      distributionType = 6;
                                                                                      selectedItems = values;
                                                                                      isClassWise = false;
                                                                                    });
                                                                                  },
                                                                                  searchable: true,
                                                                                  title: const Text("Select  classes"),
                                                                                  searchHint: 'Select section wise',
                                                                                  decoration: BoxDecoration(shape: BoxShape.rectangle, border: Border.all(color: Colors.black)),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Visibility(
                                                                                visible: isClassWise,
                                                                                child: MultiSelectDialogField(
                                                                                  items: classWise.map((e) => MultiSelectItem(e, e)).toList(),
                                                                                  listType: MultiSelectListType.CHIP,
                                                                                  buttonText: const Text("Select ClassWise"),
                                                                                  onConfirm: (List<String> values) {
                                                                                    setState(() {
                                                                                      distributionType = 8;
                                                                                      selectedItems = values;
                                                                                      isSectionWise = false;
                                                                                    });
                                                                                  },
                                                                                  searchable: true,
                                                                                  title: const Text("Select  classes"),
                                                                                  searchHint: 'Select ClassWise',
                                                                                  decoration: BoxDecoration(shape: BoxShape.rectangle, border: Border.all(color: Colors.black)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      ),
                                                                    ))
                                                                : AlertDialog(
                                                                    title: Text(
                                                                      widget.name.toUpperCase() ==
                                                                              "ADMIN-MANAGEMENT"
                                                                          ? dropDownTitle
                                                                          : 'Select Individual Student',
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            for (var element
                                                                                in checkListItems) {
                                                                              element["value"] = false;
                                                                            }
                                                                            checkListItems[index]["value"] =
                                                                                value;
                                                                            setState(() {
                                                                              visibilityMessage = selectedItems.toString();
                                                                              errorText = '';
                                                                              count = widget.name.toUpperCase() == "ADMIN-MANAGEMENT" ? selectedItems.length : groupCount + selectedItems.length;

                                                                              color = Colors.green;
                                                                              text = widget.name.toUpperCase() == "ADMIN-MANAGEMENT" ? "Management" : 'StudentWise';
                                                                              isMessageSend = value!;
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text("Ok"))
                                                                    ],
                                                                    content:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          MultiSelectDialogField(
                                                                        dialogHeight: MediaQuery.of(context)
                                                                            .size
                                                                            .height,
                                                                        items: menuItems
                                                                            .map((e) =>
                                                                                MultiSelectItem(e, e))
                                                                            .toList(),
                                                                        searchable:
                                                                            true,
                                                                        listType:
                                                                            MultiSelectListType.CHIP,
                                                                        onConfirm:
                                                                            (List<String>
                                                                                values) {
                                                                          selectedItems =
                                                                              values;
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                      );
                                                    } else if (value == true) {
                                                      setState(() {
                                                        selectedItems.clear();
                                                        errorText = '';
                                                        visibilityMessage =
                                                            "visible to ";
                                                        for (var element
                                                            in checkListItems) {
                                                          element["value"] =
                                                              false;
                                                        }
                                                        checkListItems[index]
                                                            ["value"] = value;
                                                        checkListItems[0]
                                                                ["value"]
                                                            ? color =
                                                                const Color(
                                                                    0xfff98a1d)
                                                            : checkListItems[1]
                                                                    ["value"]
                                                                ? color =
                                                                    Colors.green
                                                                : color =
                                                                    Colors.pink;
                                                        text = checkListItems[
                                                            index]['title'];
                                                        distributionType =
                                                            checkListItems[
                                                                index]['id'];
                                                        isMessageSend = value!;
                                                        checkListItems[0]
                                                                ["value"]
                                                            ? count = (int.parse(msgCount!.admin.length.toString()) +
                                                                int.parse(msgCount!
                                                                    .management
                                                                    .length
                                                                    .toString()) +
                                                                int.parse(msgCount!
                                                                    .parent
                                                                    .length
                                                                    .toString()) +
                                                                int.parse(msgCount!
                                                                    .staff
                                                                    .length
                                                                    .toString()))
                                                            : checkListItems[1]
                                                                    ['value']
                                                                ? count = msgCount!
                                                                    .staff
                                                                    .length
                                                                : count =
                                                                    msgCount!
                                                                        .parent
                                                                        .length;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        errorText =
                                                            'Cant unselect all the field select any one !';
                                                      });
                                                    }
                                                  },
                                      ),
                                    );
                                  }),
                            )
                          ])),
                      if (errorText != '')
                        const SizedBox(
                          height: 10,
                        ),
                      if (errorText != '')
                        Text(
                          errorText,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: 12 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 0.9152272542 * ffem / fem,
                            letterSpacing: 1.2 * fem,
                            color: const Color(0xff303030),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ]),
      ),
    );
  }

  void imageView(GetImageModel getImage) async {
    await showDialog<void>(
        context: context,
        builder: (context) => PhotoViewPage(
              onBack: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              images: getImage.images,
              onPressed: () {
                setState(() {
                  errorImage = getImage.errorText;
                  images.addAll(getImage.images);
                });
                Navigator.pop(context);
              },
            ));
  }

  void onMessageSend() async {
    HapticFeedback.vibrate();
    List<String> selectedIds = [];
    setState(() {
      isTapped = true;
    });

    if (widget.name.toUpperCase() == "ADMIN-MANAGEMENT") {
      for (int i = 0; i < selectedItems.length; i++) {
        if (widget.role.toUpperCase() == "MANAGEMENT") {
          selectedIds.add(listOfAdmin
              .firstWhere((element) => element.firstName == selectedItems[i])
              .id
              .toString());
        } else {
          selectedIds.add(managementList
              .firstWhere((element) => element.firstName == selectedItems[i])
              .id
              .toString());
        }
        setState(() {
          distributionType = 9;
        });
      }
    } else if (widget.id != '2') {
      for (int i = 0; i < selectedItems.length; i++) {
        selectedIds.add(studentGroupList
            .firstWhere((element) => element.name == selectedItems[i])
            .id
            .toString());
        setState(() {
          distributionType = 7;
        });
      }
    }
    switch (distributionType) {
      case 6:
        {
          for (int i = 0; i < selectedItems.length; i++) {
            selectedIds.add(class_!.classGroup
                .firstWhere((element) => element.groupName == selectedItems[i])
                .classConfig
                .toString());
          }
        }
        break;
      case 8:
        {
          for (int i = 0; i < selectedItems.length; i++) {
            selectedIds.add(groupList!.classes
                .firstWhere((element) => element.className == selectedItems[i])
                .id
                .toString());
          }
        }
    }
    if (textController.text.isNotEmpty) {
      category = 1;
      await sendText(
        msg: textController.text,
        distType: distributionType.toString(),
        msgCategory: category.toString(),
        groupId: widget.id,
        title: textTitleController.text,
        important: "0",
        classIds: selectedIds,
      ).then((value) {
        navigateFunction(value);
      });
    } else if (imgController.text.isNotEmpty && images.isNotEmpty) {
      category = 2;
      await sendImg(
              img: images,
              distType: distributionType.toString(),
              msgCategory: category.toString(),
              groupId: widget.id,
              title: imgController.text,
              classIds: selectedIds,
              important: "0")
          .then((value) {
        navigateFunction(value);
      });
    } else if (imgController.text.isEmpty && images.isNotEmpty) {
      category = 3;
      await sendImg(
              img: images,
              distType: distributionType.toString(),
              msgCategory: category.toString(),
              groupId: widget.id,
              title: imgController.text,
              classIds: selectedIds,
              important: "0")
          .then((value) {
        navigateFunction(value);
      });
    } else if (document.isNotEmpty) {
      category = 4;
      await sendDocument(
              img: document,
              distType: distributionType.toString(),
              msgCategory: category.toString(),
              groupId: widget.id,
              title: docController.text,
              classIds: selectedIds,
              important: "0")
          .then((value) {
        navigateFunction(value);
      });
    } else if (material.isNotEmpty) {
      category = 10;
      await sendDocument(
              img: material,
              distType: distributionType.toString(),
              msgCategory: category.toString(),
              groupId: widget.id,
              title: materialController.text,
              classIds: selectedIds,
              important: "0")
          .then((value) {
        navigateFunction(value);
      });
    } else if (quoteController.text.isNotEmpty) {
      category = 7;
      await sendQuotes(
              msg: quoteController.text,
              distType: distributionType.toString(),
              msgCategory: category.toString(),
              groupId: widget.id,
              title: textTitleController.text,
              classIds: selectedIds,
              important: "0")
          .then((value) {
        navigateFunction(value);
      });
    } else if (speaksController.text.isNotEmpty) {
      category = 8;
      await sendSpeaks(
              msg: speaksController.text,
              distType: distributionType.toString(),
              msgCategory: category.toString(),
              groupId: widget.id,
              classIds: selectedIds,
              title: '',
              important: "0")
          .then((value) {
        navigateFunction(value);
      });
    } else if (circularController.text.isNotEmpty) {
      category = 9;
      await sendCircular(
              msg: circularController.text,
              distType: distributionType.toString(),
              msgCategory: category.toString(),
              groupId: widget.id,
              classIds: selectedIds,
              title: '',
              important: "0")
          .then((value) {
        navigateFunction(value);
      });
    } else if (videoLinkController.text.isNotEmpty) {
      category = 6;
      await sendVideo(
              msg: videoLinkController.text,
              distType: distributionType.toString(),
              msgCategory: category.toString(),
              groupId: widget.id,
              title: videoCaptionController.text,
              classIds: selectedIds,
              important: "0")
          .then((value) {
        navigateFunction(value);
      });
    }
  }

  void navigateFunction(value) async {
    if (value != null) {
      Navigator.pop(context);
      widget.role == "staff"
          ? Utility.displaySnackBar(
              context, "Notification sent for approval successfully")
          : Utility.displaySnackBar(context, value['message']);
    } else {
      Navigator.pop(context);
      Utility.displaySnackBar(context, "Message not send");
    }
  }

  void selectImages() async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        image.addAll(result.files);
        images.addAll(result.files);
      });
    }
  }
}

class TabWidget extends StatelessWidget {
  TabWidget({super.key, required this.assetImage, required this.text});
  AssetImage assetImage;
  String text;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1514;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Tab(
      child: Container(
        margin: EdgeInsets.fromLTRB(10 * fem, 0 * fem, 0 * fem, 0 * fem),
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 10 * fem),
              width: 20 * fem,
              height: 20 * fem,
              child: Image.asset(
                assetImage.assetName,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              text,
              style: SafeGoogleFont(
                'Inter',
                fontSize: 12 * ffem,
                fontWeight: FontWeight.w400,
                height: 0.9152272542 * ffem / fem,
                letterSpacing: 1.2 * fem,
                color: const Color(0xff000000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

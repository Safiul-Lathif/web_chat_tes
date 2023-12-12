// ignore_for_file: unrelated_type_equality_checks, must_be_immutable
import 'package:flutter/material.dart';
import 'package:ui/api/group_info_api.dart';
import 'package:ui/api/image_list_api.dart';
import 'package:ui/api/main_group_api.dart';
import 'package:ui/api/messageviewAPI.dart';
import 'package:ui/api/profile_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/model/classModel.dart';
import 'package:ui/model/configurationModel.dart';
import 'package:ui/model/group_info_model.dart';
import 'package:ui/model/image_list_model.dart';
import 'package:ui/model/main_group_model.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/model/profile_model.dart';
import 'package:ui/pages/group_info.dart';
import 'package:ui/pages/chat_page.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/api/class_group_api.dart';

class MainWebScreen extends StatefulWidget {
  const MainWebScreen({
    super.key,
  });

  @override
  State<MainWebScreen> createState() => _MainWebScreenState();
}

class _MainWebScreenState extends State<MainWebScreen> {
  Configurations? res;
  MainGroupList? group;
  MainGroupList? mainGroup;
  ClassGroup? classGroup;
  ProfileModel? profiles;
  int selectedIndex = 0;
  String userRole = "";
  String userSchoolName = "";
  String userName = "";
  String userId = "";
  String userClassId = "";
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    initialize();
    profile();
  }

  void profile() async {
    await getProfile(id: "", role: "", studentId: '').then((value) {
      if (value != null) {
        setState(() {
          profiles = value;
        });
      }
    });
  }

  void initialize() async {
    await getMainGroup().then((value) {
      if (mounted) {
        setState(() {
          mainGroup = value;
          userRole = mainGroup!.userRole;
        });
      }
    });
    await getClassGroup().then((value) {
      if (mounted) {
        setState(() {
          classGroup = value;
        });
      }
    });
  }

  MessageView? msgView;
  List<ImageList>? imageList;
  grpInfoController(BuildContext context, bool isGrpInfo) {
    setState(() {
      isVisible = isGrpInfo;
    });
  }

  msg(BuildContext context, String id, String className, String name,
      String role, String classId) async {
    setState(() {
      isLoading = true;
    });
    await getChatData(
        id: id, classId: classId, className: className, name: name, role: role);
  }

  String grpId = '';

  Future<void> getChatData(
      {required String id,
      required String className,
      required String name,
      required String role,
      required String classId}) async {
    await getMsgFeed(id, 1).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            isVisible = false;
            msgView = value;
            userId = id;
            userSchoolName = className;
            userName = name;
            userRole = role;
            userClassId = classId;
            isLoading = false;
            grpId = id;
          });
        }
      }
    });

    await getImageList(id).then((value) {
      if (value != null) {
        setState(() {
          imageList = value;
        });
      }
    });
  }

  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.254,
            child: Container(
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
                child: GroupList(
                  mainGroup: mainGroup,
                  classGroup: classGroup,
                  callback: msg,
                )),
          ),
          Container(
            width: isVisible
                ? MediaQuery.of(context).size.width * 0.47
                : MediaQuery.of(context).size.width * 0.70,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: 1, color: Colors.grey.shade300),
                left: BorderSide(width: 1, color: Colors.grey.shade300),
              ),
            ),
            child: ChatPage(
              role: userRole,
              name: userName,
              id: userId,
              clsId: userClassId,
              msgView: msgView,
              isLoading: isLoading,
              callback: grpInfoController,
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Expanded(
              child: Container(
                color: Colors.green.shade400,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.blue.withOpacity(0.4), BlendMode.dstATop),
                        image: const AssetImage(Images.bgImage),
                        fit: BoxFit.cover,
                      )),
                  child: GroupInfoWidget(
                    id: grpId,
                    schoolName: userSchoolName,
                    imageList: imageList,
                    isLoading: isLoading,
                    callback: grpInfoController,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupList extends StatefulWidget {
  const GroupList(
      {super.key,
      required this.mainGroup,
      required this.classGroup,
      required this.callback});

  final MainGroupList? mainGroup;
  final ClassGroup? classGroup;
  final Function callback;

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 5,
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Main Group",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 270,
                  child: widget.mainGroup == null
                      ? Lottie.network(
                          'https://assets8.lottiefiles.com/packages/lf20_fzmasdx7.json',
                          height: 50.0,
                          repeat: true,
                          reverse: true,
                          animate: true,
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.mainGroup!.groupList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: const CircleAvatar(
                                    radius: 18.0,
                                    backgroundImage: NetworkImage(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpCKq1XnPYYDaUIlwlsvmLPZ-9-rdK28RToA&usqp=CAU'),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  title: Tooltip(
                                    message: widget
                                        .mainGroup!.groupList[index].groupName,
                                    child: Text(widget
                                        .mainGroup!.groupList[index].groupName),
                                  ),
                                  subtitle: SizedBox(
                                    width: 200,
                                    child: Text(
                                      widget.mainGroup!.groupList[index]
                                          .groupDescription,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  selectedColor: Colors.black87,
                                  onTap: () {
                                    setState(() {
                                      var name = widget.mainGroup!
                                          .groupList[index].groupName;
                                      var className =
                                          widget.mainGroup!.schoolName;
                                      var id = widget
                                          .mainGroup!.groupList[index].id
                                          .toString();
                                      var role = widget.mainGroup!.userRole;
                                      widget.callback(context, id, className,
                                          name, role, '');
                                    });
                                  },
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                )
                              ],
                            );
                          },
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 2,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.transparent,
                    Colors.grey,
                    Colors.transparent
                  ])),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Classes",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.47,
                      child: widget.classGroup == null
                          ? Lottie.network(
                              'https://assets8.lottiefiles.com/packages/lf20_fzmasdx7.json',
                              height: 50.0,
                              repeat: true,
                              reverse: true,
                              animate: true,
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.classGroup!.classGroup.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        setState(() {
                                          var name = widget.classGroup!
                                              .classGroup[index].groupName;
                                          var className =
                                              widget.classGroup!.schoolName;
                                          var id = widget.classGroup!
                                              .classGroup[index].groupId
                                              .toString();
                                          var role = widget.mainGroup!.userRole;
                                          var classId = widget.classGroup!
                                              .classGroup[index].classConfig
                                              .toString();
                                          widget.callback(context, id,
                                              className, name, role, classId);
                                        });
                                      },
                                      leading: Stack(
                                        children: const [
                                          CircleAvatar(
                                            radius: 18.0,
                                            backgroundImage: NetworkImage(
                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpCKq1XnPYYDaUIlwlsvmLPZ-9-rdK28RToA&usqp=CAU'),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ],
                                      ),
                                      title: Tooltip(
                                        message: widget.classGroup!
                                            .classGroup[index].groupName,
                                        child: Text(widget
                                                    .classGroup!
                                                    .classGroup[index]
                                                    .classteacher ==
                                                true
                                            ? widget.classGroup!
                                                .classGroup[index].groupName
                                            : widget.classGroup!
                                                .classGroup[index].groupName),
                                      ),
                                      subtitle: Text(
                                        "Class Teacher: ${widget.classGroup!.classGroup[index].classTeacher}",
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                );
                              },
                            ),
                    ),
                    // Positioned(
                    //   right: 1,
                    //   bottom: 1,
                    //   child: CircleAvatar(
                    //     radius: 20,
                    //     backgroundColor: Colors.green.shade500,
                    //     child: const Icon(
                    //       Icons.chat,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: iterable_contains_unrelated_type, must_be_immutable
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/api/inactive_user_api.dart';
import 'package:ui/custom/detail_page_image.dart';
import 'package:ui/model/group_info_model.dart';
import 'package:ui/model/image_list_model.dart';
import 'package:ui/utils/utility.dart';
import 'package:ui/widget/profile_info.dart';

class GroupInfoWidget extends StatefulWidget {
  final String schoolName;
  List<GroupInfoModel>? groupInfo;
  List<ImageList>? imageList;
  bool isLoading;
  final Function callback;

  GroupInfoWidget(
      {super.key,
      required this.schoolName,
      required this.groupInfo,
      required this.imageList,
      required this.isLoading,
      required this.callback});

  @override
  State<GroupInfoWidget> createState() => _GroupInfoWidgetState();
}

class _GroupInfoWidgetState extends State<GroupInfoWidget> {
  Future<bool> activeInactiveUser(
    String number,
    String id,
    String name,
    String role,
  ) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove User'),
            content: Text('Do you want to Remove $name User?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // await removeFromGroup(number, '2', role, id);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1300;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                setState(() {
                  widget.callback(context, false);
                });
              },
              icon: const Icon(
                Icons.cancel_rounded,
                color: Colors.black,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 17, right: 12),
          child: widget.groupInfo == null || widget.imageList == null
              ? Lottie.network(
                  'https://assets8.lottiefiles.com/packages/lf20_fzmasdx7.json',
                  height: 50.0,
                  repeat: true,
                  reverse: true,
                  animate: true,
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.groupInfo!.length} Members",
                          style: TextStyle(
                              color: Colors.green.shade500,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await inactiveUser().then((value) {
                                if (value != null) {
                                  setState(() {
                                    Utility.displaySnackBar(
                                        context, value["message"]);
                                  });
                                }
                              });
                            },
                            child: const Text("Resend Credentials")),
                      ],
                    ),
                    SizedBox(
                      height: 320,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.groupInfo!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Tooltip(
                                message: widget.groupInfo![index].appStatus !=
                                        "Not Installed"
                                    ? 'Active User'
                                    : 'InActive User',
                                child: ListTile(
                                  leading: Stack(
                                    children: [
                                      const CircleAvatar(
                                        radius: 18.0,
                                        backgroundImage: NetworkImage(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpCKq1XnPYYDaUIlwlsvmLPZ-9-rdK28RToA&usqp=CAU'),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      widget.groupInfo![index].appStatus !=
                                              "Not Installed"
                                          ? const Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Icon(
                                                Icons.circle,
                                                color: Colors.green,
                                                size: 12,
                                              ))
                                          : const Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Icon(
                                                Icons.circle,
                                                color: Colors.red,
                                                size: 12,
                                              )),
                                    ],
                                  ),
                                  title: Text(widget.groupInfo![index].name),
                                  subtitle: Text(
                                      widget.groupInfo![index].designation),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Material(
                                        type: MaterialType.transparency,
                                        child: Center(
                                            child: SizedBox(
                                                width:
                                                    MediaQuery.of(context).size.width *
                                                        0.5,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                                child: ProfileInfo(
                                                    lastSeen: widget.groupInfo![index].lastLogin != ''
                                                        ? "Last Login:${Utility.convertDateFormat(widget.groupInfo![index].lastLogin, "dd-MMM-yyyy")} \t${Utility.convertTimeFormat(widget.groupInfo![index].lastLogin.split(' ').last)}"
                                                        : "",
                                                    id: widget
                                                        .groupInfo![index].id,
                                                    role: widget
                                                        .groupInfo![index]
                                                        .userRole
                                                        .toString(),
                                                    image: widget
                                                        .groupInfo![index]
                                                        .profile,
                                                    name: widget.groupInfo![index].name,
                                                    mobileNumber: widget.groupInfo![index].mobileNumber.toString()))),
                                      ),
                                    );
                                  },
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
                      height: 6,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       'Images(${widget.imageList!.length})',
                    //       style: TextStyle(
                    //           color: Colors.green.shade500,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // widget.imageList!.isEmpty
                    //     ? Container()
                    //     : SizedBox(
                    //         height: 80,
                    //         child: GridView.builder(
                    //           scrollDirection: Axis.horizontal,
                    //           shrinkWrap: true,
                    //           itemCount: widget.imageList!.length,
                    //           gridDelegate:
                    //               const SliverGridDelegateWithFixedCrossAxisCount(
                    //             crossAxisCount: 1,
                    //             crossAxisSpacing: 6,
                    //             mainAxisSpacing: 7,
                    //           ),
                    //           itemBuilder: (context, index) {
                    //             return InkWell(
                    //               onTap: () {
                    //                 Navigator.push(context,
                    //                     MaterialPageRoute(builder: (_) {
                    //                   return DetailScreen(
                    //                     images: [
                    //                       widget.imageList![index].image
                    //                     ],
                    //                     index: index,
                    //                   );
                    //                 }));
                    //               },
                    //               child: Container(
                    //                 decoration: BoxDecoration(
                    //                     image: DecorationImage(
                    //                         image: NetworkImage(widget
                    //                                 .imageList![index].image
                    //                                 .contains("https://")
                    //                             ? widget.imageList![index].image
                    //                             : widget.imageList![index].image
                    //                                     .contains("http://")
                    //                                 ? widget
                    //                                     .imageList![index].image
                    //                                 //data.images.toString()
                    //                                 : "http://${widget.imageList![index].image}"),
                    //                         fit: BoxFit.fill),
                    //                     borderRadius: const BorderRadius.only(
                    //                       topRight: Radius.circular(5),
                    //                       bottomLeft: Radius.circular(5),
                    //                       bottomRight: Radius.circular(5),
                    //                       topLeft: Radius.circular(5),
                    //                     )),
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

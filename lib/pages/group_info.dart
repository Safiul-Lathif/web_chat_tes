// ignore_for_file: iterable_contains_unrelated_type, must_be_immutable
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/api/group_info_api.dart';
import 'package:ui/api/inactive_user_api.dart';
import 'package:ui/model/group_info_model.dart';
import 'package:ui/model/image_list_model.dart';
import 'package:ui/utils/utility.dart';
import 'package:ui/widget/profile_info.dart';

class GroupInfoWidget extends StatefulWidget {
  final String schoolName;
  String id;
  List<ImageList>? imageList;
  bool isLoading;
  final Function callback;

  GroupInfoWidget(
      {super.key,
      required this.schoolName,
      required this.id,
      required this.imageList,
      required this.isLoading,
      required this.callback});

  @override
  State<GroupInfoWidget> createState() => _GroupInfoWidgetState();
}

class _GroupInfoWidgetState extends State<GroupInfoWidget> {
  Iterable<ParticipantsList>? groupInfo;

  int page = 1;

  String stats = "";
  String url = 'data';

  final ScrollController _scrollController = ScrollController();
  List<ParticipantsList> listOfParticipants = [];

  int totalItem = 0;
  bool isSearch = false;

  bool isLoading = false;
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
                onPressed: () async {},
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    getGroupList(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (url != '') {
          if (page != 0) {
            _loadNextPage();
          }
        }
      }
    });
  }

  TextEditingController controller = TextEditingController();

  void _loadNextPage() {
    setState(() {
      page++;
      isLoading = true;
    });
    getGroupList(page);
  }

  void getGroupList(int pageNumber) async {
    await getGroupInfo(widget.id, pageNumber).then((value) {
      if (value != null) {
        setState(() {
          listOfParticipants.addAll(value.data);
          groupInfo = listOfParticipants;
          totalItem = value.total;
          url = value.nextPageUrl;
        });
      }
      for (var i = 0; i < groupInfo!.length; i++) {
        stats = groupInfo!.elementAt(i).appStatus;
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  String searchText = '';

  void searchMember() {
    final listOfData = groupInfo!.where((element) {
      final name = element.name.toLowerCase();
      final text = searchText.toLowerCase();
      return name.contains(text);
    });
    setState(() => groupInfo = listOfData);
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
          child: groupInfo == null
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
                          "$totalItem Members",
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
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: Colors.black)),
                      child: TextField(
                        onTap: () {
                          setState(() {
                            isSearch = !isSearch;
                            // listOfParticipants.clear();
                            // groupInfo = null;
                            // page = 0;
                            // getGroupList(0);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                            searchMember();
                          });
                        },
                        controller: controller,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                              top: 12,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: !isSearch
                                  ? Colors.black38
                                  : Colors.grey.shade600,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: !isSearch
                                    ? Colors.black38
                                    : Colors.grey.shade600,
                              ),
                              onPressed: () {
                                setState(() {
                                  controller.clear();
                                  searchText = '';
                                  isSearch = !isSearch;
                                });
                              },
                            ),
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              color: !isSearch
                                  ? Colors.black38
                                  : Colors.grey.shade600,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 320,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: groupInfo!.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Tooltip(
                                message:
                                    groupInfo!.elementAt(index).appStatus !=
                                            "Not Installed"
                                        ? 'Installed User'
                                        : 'Not Installed User',
                                child: ListTile(
                                  leading: Stack(
                                    children: [
                                      const CircleAvatar(
                                        radius: 18.0,
                                        backgroundImage: NetworkImage(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpCKq1XnPYYDaUIlwlsvmLPZ-9-rdK28RToA&usqp=CAU'),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      groupInfo!.elementAt(index).appStatus !=
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
                                  title: Text(groupInfo!.elementAt(index).name),
                                  subtitle: Text(
                                      groupInfo!.elementAt(index).designation),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Material(
                                        type: MaterialType.transparency,
                                        child: Center(
                                            child: SizedBox(
                                                width: MediaQuery.of(context).size.width *
                                                    0.5,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                                child: ProfileInfo(
                                                    lastSeen: groupInfo!.elementAt(index).lastLogin != ''
                                                        ? "Last Login:${Utility.convertDateFormat(groupInfo!.elementAt(index).lastLogin, "dd-MMM-yyyy")} \t${Utility.convertTimeFormat(groupInfo!.elementAt(index).lastLogin.split(' ').last)}"
                                                        : "",
                                                    id: groupInfo!
                                                        .elementAt(index)
                                                        .id,
                                                    role: groupInfo!
                                                        .elementAt(index)
                                                        .userRole
                                                        .toString(),
                                                    image: groupInfo!
                                                        .elementAt(index)
                                                        .profile,
                                                    name: groupInfo!
                                                        .elementAt(index)
                                                        .name,
                                                    mobileNumber: groupInfo!
                                                        .elementAt(index)
                                                        .mobileNumber
                                                        .toString()))),
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

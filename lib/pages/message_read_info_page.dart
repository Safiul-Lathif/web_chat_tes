import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/Utils/Utility.dart';
import 'package:ui/api/message_read_api.dart';
import 'package:ui/model/message_read_info_model.dart';
import 'package:ui/utils/utils_file.dart';

class MessageReadInfoPage extends StatefulWidget {
  const MessageReadInfoPage(
      {super.key,
      required this.notiid,
      required this.gid,
      required this.role,
      required this.communicationType});
  final int notiid;
  final String gid;
  final String role;
  final String communicationType;
  @override
  State<MessageReadInfoPage> createState() => _MessageReadInfoPageState();
}

class _MessageReadInfoPageState extends State<MessageReadInfoPage> {
  bool isSearch = false;
  String searchText = '';
  TextEditingController controller = TextEditingController();
  Iterable<DeliveredUser>? readInfo;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await getReadinfo(
            widget.gid, widget.notiid.toString(), widget.communicationType)
        .then((value) {
      if (value != null) {
        setState(() {
          readInfo = value;
        });
      }
    });
  }

  var colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  var colorizeTextStyle = GoogleFonts.acme(
    fontSize: 33,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: goBack,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.2), BlendMode.dstATop),
                image: const AssetImage('assets/images/bg_image_tes.jpg'),
                fit: BoxFit.cover,
              )),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios)),
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.black)),
                        child: TextField(
                          onTap: () {
                            setState(() {
                              isSearch = !isSearch;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                              searchTeacher();
                            });
                          },
                          controller: controller,
                          decoration: InputDecoration(
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
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.86,
                  child: readInfo == null
                      ? AnimatedTextKit(repeatForever: true, animatedTexts: [
                          ColorizeAnimatedText(
                            "Loading . . .",
                            textStyle: colorizeTextStyle,
                            colors: colorizeColors,
                          ),
                        ])
                      : readInfo!.isEmpty
                          ? AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                  ColorizeAnimatedText(
                                    "Waiting for Message to Delivered",
                                    textStyle: colorizeTextStyle,
                                    colors: colorizeColors,
                                  ),
                                ])
                          : MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: ListView.builder(
                                itemCount: readInfo!.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: const CircleAvatar(
                                      radius: 23,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                        'https://cdn-icons-png.flaticon.com/512/3177/3177440.png',
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        Text(readInfo!.elementAt(index).name),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(readInfo!
                                            .elementAt(index)
                                            .designation),
                                      ],
                                    ),
                                    //  Row(
                                    //   crossAxisAlignment: CrossAxisAlignment.center,
                                    //   children: [
                                    //     Container(
                                    //       // group22AbL (7:847)
                                    //       margin:
                                    //           const EdgeInsets.fromLTRB(0, 0, 3, 1),
                                    //       width: 10,
                                    //       height: 10,
                                    //       child: Image.asset(
                                    //         'assets/images/group-22-MXG.png',
                                    //         width: 10,
                                    //         height: 10,
                                    //       ),
                                    //     ),
                                    //     const SizedBox(
                                    //       width: 3,
                                    //     ),
                                    //     Column(
                                    //       children: [
                                    //         Text(
                                    //           Utility.convertTimeFormat(readInfo!
                                    //               .deliveredUsers[index].viewTime
                                    //               .toString()
                                    //               .split(' ')
                                    //               .last),
                                    //           //widget.tym.split(' ').last,
                                    //           style: SafeGoogleFont(
                                    //             'Inter',
                                    //             fontSize: 10,
                                    //             fontWeight: FontWeight.w300,
                                    //             height: 0.9152273178,
                                    //             letterSpacing: 1,
                                    //             color: Colors.black,
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                    trailing: SizedBox(
                                      width: 70,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            readInfo!
                                                        .elementAt(index)
                                                        .messageStatus !=
                                                    1
                                                ? Icons.done_all
                                                : Icons.done,
                                            color: readInfo!
                                                        .elementAt(index)
                                                        .messageStatus !=
                                                    1
                                                ? Colors.blue
                                                : null,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            Utility.convertTimeFormat(readInfo!
                                                .elementAt(index)
                                                .viewTime
                                                .toString()
                                                .split(' ')
                                                .last),
                                            overflow: TextOverflow.ellipsis,
                                            //widget.tym.split(' ').last,
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              height: 0.9152273178,
                                              letterSpacing: 1,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // onTap: () {
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) => ProfileInfo(
                                    //                 image: '',
                                    //                 id: 0,
                                    //                 role: readInfo!
                                    //                     .elementAt(index)
                                    //                     .designation,
                                    //                 name: readInfo!
                                    //                     .elementAt(index)
                                    //                     .name,
                                    //                 mobileNumber: readInfo!
                                    //                     .elementAt(index)
                                    //                     .mobileNo
                                    //                     .toString(),
                                    //                 lastSeen: '',
                                    //               )));
                                    // },
                                  );
                                },
                              )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void searchTeacher() {
    final listOfData = readInfo!.where((element) {
      final name = element.name.toLowerCase();
      final text = searchText.toLowerCase();
      return name.contains(text);
    });
    setState(() => readInfo = listOfData);
  }

  Future<bool> goBack() async {
    Navigator.pop(context);
    return true;
  }
}

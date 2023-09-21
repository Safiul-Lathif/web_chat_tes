// ignore_for_file: import_of_legacy_library_into_null_safe, use_build_context_synchronously, must_be_immutable
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/config/images.dart';
import 'package:ui/config/size_config.dart';
import 'package:ui/model/class_group_model.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/model/sibling_details_model.dart';
import 'package:ui/utils/utils_file.dart';
import 'package:ui/widget/chat_feed.dart';
import 'package:ui/widget/message_widget.dart';

class ChatPage extends StatefulWidget {
  final String role;
  final String name;
  final String id;
  final String clsId;
  final MessageView? msgView;
  final bool isLoading;
  final Function callback;

  const ChatPage(
      {Key? key,
      required this.role,
      required this.name,
      required this.id,
      required this.clsId,
      required this.isLoading,
      required this.callback,
      this.msgView})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final focusNode = FocusNode();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showDrawer = false;

  int index = 0;
  List<Message> detail = [];
  ScrollController sc = ScrollController();
  bool hasConnection = false;
  bool isLoading = true;
  String nextUrl = "";
  final scrollController = ScrollController();

  List<Message>? msgInfo;
  int totalRecord = 0;
  String dates = "";

  List<SiblingDetail> sibling_ = [];
  int selectedSibling = 1;

  ClassGroup? classparent_;
  int? firstId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: widget.msgView == null
          ? Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.blue.withOpacity(0.2), BlendMode.dstATop),
                      image: const AssetImage(Images.bgImage),
                      repeat: ImageRepeat.repeatX)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Images.appLogo,
                      width: 200,
                      height: 200,
                    ),
                    Text(
                      'TES Chat Web',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        height: 1.2125,
                        color: const Color(0xff505050),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Send and receive message with web and user can configure also',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        height: 1.2125,
                        color: const Color(0xff505050),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Your session will be cleared when you are offline for more then 15 min',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.2125,
                        color: const Color(0xff505050),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _backgroundWidget(),
    );
  }

  Future<bool> goBack() async {
    Navigator.pop(context);
    return true;
  }

  Widget _previewWidget() {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Stack(
      children: [
        InkWell(
          onTap: filterBottomSheet,
          child: SizedBox(
            width: 268 * fem,
            height: 57 * fem,
            child: Stack(
              children: [
                Positioned(
                  // rectangle33EqG (7:2403)
                  left: 8 * fem,
                  top: 15 * fem,
                  child: Align(
                    child: SizedBox(
                      width: 245 * fem,
                      height: 36 * fem,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13 * fem),
                          color: const Color(0xffa3d371),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // rectangle32ugW (7:2404)
                  left: 8 * fem,
                  top: 33 * fem,
                  child: Align(
                    child: SizedBox(
                      width: 245 * fem,
                      height: 18 * fem,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff81ba49),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(13 * fem),
                            bottomLeft: Radius.circular(13 * fem),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // initiatecommunicationnkJ (7:2405)
                  left: 44 * fem,
                  top: 23 * fem,
                  child: Align(
                    child: SizedBox(
                      width: 180 * fem,
                      height: 20 * fem,
                      child: Text(
                        'Initiate Communication',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Inter',
                          fontSize: 16 * ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.2125 * ffem / fem,
                          color: const Color(0xff505050),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  filterBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 470, right: 370),
          child: MessageWidget(
              focusNode: focusNode,
              id: widget.id,
              role: widget.role,
              name: widget.name),
        );
      },
    );
  }

  Future<bool> exitApp() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  var colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  var colorizeTextStyle = GoogleFonts.acme(
    fontSize: 27,
  );

  Widget _backgroundWidget() {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.blue.withOpacity(0.3),
                                BlendMode.dstATop),
                            image: const AssetImage(Images.bgImage),
                            repeat: ImageRepeat.repeatX)),
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              const SizedBox(width: 5),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    FittedBox(
                                      child: SizedBox(
                                        child: Text(
                                          widget.isLoading ? "" : widget.name,
                                          textAlign: TextAlign.start,
                                          style: SafeGoogleFont(
                                            'Inter',
                                            fontSize: 20 * ffem,
                                            fontWeight: FontWeight.w500,
                                            height: 0.9152272542 * ffem / fem,
                                            letterSpacing: 2.4 * fem,
                                            color: const Color(0xff575757),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.callback(context, true);
                                    });
                                  },
                                  icon: const Icon(Icons.menu))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          // line135xZY (7:1574)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 3 * fem),
                          width: double.infinity,
                          height: 1 * fem,
                          color: const Color(0xffcccccc),
                        ),
                        widget.isLoading
                            ? Center(
                                child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.81,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 300.0),
                                  child: AnimatedTextKit(
                                      repeatForever: true,
                                      animatedTexts: [
                                        ColorizeAnimatedText(
                                          "Loading ...",
                                          textStyle: colorizeTextStyle,
                                          colors: colorizeColors,
                                        ),
                                      ]),
                                ),
                              ))
                            : SingleChildScrollView(
                                child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.81,
                                    child: NewsFeedInfo(
                                      classId: widget.clsId,
                                      id: widget.id,
                                      role: widget.role,
                                    )),
                              ),
                        _previewWidget()
                      ],
                    ),
                  );
                });
          }),
    );
  }

  void showDrawer() {
    print('tapped on show drawer!');
    setState(() {
      _showDrawer = !_showDrawer;
    });
  }
}

class DrawerWidget extends StatefulWidget {
  final Function closeFunction;

  const DrawerWidget({
    Key? key,
    required this.closeFunction,
  }) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double height;
  late double width;
  double backgroundOpacity = 0;
  bool isCollapsed = true;
  bool isCollapsedAfterSec = true;

  void initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 500,
      ),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );
    startAnimation();
  }

  void startAnimation() {
    _controller.forward();
    _animation.addListener(() {
      setState(() {
        backgroundOpacity = 0.7 * _animation.value;
      });
    });
  }

  void stopAnimation() {
    _controller.stop();
  }

  void reverseAnimation() {
    _controller.reverse();
  }

  void onCollapseTap() {
    if (isCollapsed) {
      Future.delayed(const Duration(
        milliseconds: 70,
      )).then((value) {
        setState(() {
          isCollapsedAfterSec = !isCollapsedAfterSec;
        });
      });
    } else if (!isCollapsed) {
      setState(() {
        isCollapsedAfterSec = !isCollapsedAfterSec;
      });
    }
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(
        backgroundOpacity,
      ),
      body: Row(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (ctx, child) {
              return AnimatedContainer(
                duration: const Duration(
                  milliseconds: 70,
                ),
                width: (isCollapsed)
                    ? width * .2 * _animation.value
                    : width * .7 * _animation.value,
                margin: EdgeInsets.only(
                  left: width * .06 * _animation.value,
                  top: height * .05,
                  bottom: height * .05,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  image: DecorationImage(
                    opacity: 5,
                    colorFilter: ColorFilter.mode(
                        Colors.blue.withOpacity(0.5), BlendMode.dstATop),
                    image: const AssetImage(Images.bgImage),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                child: (_animation.value > 0.7)
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          DrawerUser(
                            afterCollapse: 'PK',
                            beforeCollapse: 'Prakash',
                            isCollapsed: isCollapsed,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          isCollapsed == true
                              ? const Text("..")
                              : const Text("F/O Lithikesh",
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                          const SizedBox(
                            height: 10,
                          ),
                          isCollapsed == true
                              ? const Text("..")
                              : const Text("E-Mail: xyz@gmail.com",
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),

                          // Padding(
                          //   padding:
                          //       const EdgeInsets.only(left: 8.0, right: 8.0),
                          //   child: DrawerItem(
                          //     icon: const Icon(
                          //       Icons.account_box,
                          //       color: Colors.black,
                          //       size: 35,
                          //     ),
                          //     label: const Text(
                          //       "   Add Student",
                          //       style: TextStyle(
                          //         color: Colors.black,
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 22,
                          //       ),
                          //     ),
                          //     isCollapsed: isCollapsedAfterSec,
                          //   ),
                          // ),

                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const Changepassword()));
                                },
                                child: DrawerItem(
                                  icon: const Icon(
                                    Icons.lock_reset,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                                  label: const Text(
                                    '   Change Password',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  isCollapsed: isCollapsedAfterSec,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: DrawerItem(
                              icon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                                size: 35,
                              ),
                              label: const Text(
                                '   Forget Password',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              isCollapsed: isCollapsedAfterSec,
                            ),
                          ),
                          PopupMenuItem(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: InkWell(
                              onTap: () async {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(
                                      "Sign out Confirmation",
                                      style: TextStyle(
                                          fontSize:
                                              2.5 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700]),
                                    ),
                                    content: Text(
                                      "Are you sure you want to sign out?",
                                      style: TextStyle(
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier,
                                          color: Colors.grey[700]),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          SharedPreferences preferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          await preferences.clear();
                                          Navigator.of(ctx).pop();
                                          // Navigator.pushReplacement(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             const LoginPage()));
                                        },
                                        child: const Text("Yes"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text("No"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: DrawerItem(
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.black,
                                  size: 35,
                                ),
                                label: const Text(
                                  '   Log Out',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                isCollapsed: isCollapsedAfterSec,
                              ),
                            ), //Inkwell
                          ),
                          const Spacer(),
                          // * Bottom Toggle Button
                          if (_controller.value >= 1)
                            DrawerCollapse(
                              isCollapsed: isCollapsed,
                              onTap: onCollapseTap,
                            ),
                        ],
                      )
                    : const SizedBox(),
              );
            },
          ),

          // * The left area on the side which will used
          // * to close the drawer when tapped

          Expanded(
            flex: 3,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  reverseAnimation();
                  Future.delayed(
                    const Duration(
                      milliseconds: 500,
                    ),
                  ).then(
                    (value) => widget.closeFunction(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerCollapse extends StatefulWidget {
  const DrawerCollapse({
    Key? key,
    required this.isCollapsed,
    required this.onTap,
  }) : super(key: key);
  final bool isCollapsed;
  final Function onTap;

  @override
  _DrawerCollapseState createState() => _DrawerCollapseState();
}

class _DrawerCollapseState extends State<DrawerCollapse> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: IconButton(
            icon: (widget.isCollapsed)
                ? const Icon(Icons.arrow_forward_ios)
                : const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () => widget.onTap(),
          ),
        ),
      ],
    );
  }
}

class DrawerItem extends StatefulWidget {
  const DrawerItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isCollapsed,
  }) : super(key: key);
  final Icon icon;
  final bool isCollapsed;
  final Text label;

  @override
  _DrawerItemState createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 30,
      ),
      child: Row(
        mainAxisAlignment: (widget.isCollapsed)
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          widget.icon,
          (widget.isCollapsed)
              ? Container()
              : AnimatedOpacity(
                  duration: const Duration(
                    seconds: 1,
                  ),
                  opacity: (widget.isCollapsed) ? 0 : 1,
                  child: widget.label,
                ),
        ],
      ),
    );
  }
}

class SecondDelayedAnimatedOpacity extends StatefulWidget {
  const SecondDelayedAnimatedOpacity({
    Key? key,
    required this.icon,
    required this.label,
    required this.isCollapsed,
  }) : super(key: key);
  final Icon icon;
  final bool isCollapsed;
  final Text label;

  @override
  SecondDelayedAnimatedOpacityState createState() =>
      SecondDelayedAnimatedOpacityState();
}

class SecondDelayedAnimatedOpacityState
    extends State<SecondDelayedAnimatedOpacity> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DrawerUser extends StatefulWidget {
  const DrawerUser({
    Key? key,
    required this.afterCollapse,
    required this.beforeCollapse,
    required this.isCollapsed,
  }) : super(key: key);
  final bool isCollapsed;
  final String beforeCollapse;
  final String afterCollapse;
  @override
  _DrawerUserState createState() => _DrawerUserState();
}

class _DrawerUserState extends State<DrawerUser> {
  late double height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      curve: Curves.linear,
      duration: const Duration(
        milliseconds: 100,
      ),
      width: (widget.isCollapsed) ? width * .15 : width * .4,
      height: width * .15,
      decoration: BoxDecoration(
        borderRadius: (widget.isCollapsed)
            ? BorderRadius.circular((width * .15) / 2)
            : BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: (widget.isCollapsed) ? 1 : 2,
        ),
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            (widget.isCollapsed) ? widget.afterCollapse : widget.beforeCollapse,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

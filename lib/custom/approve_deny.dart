import 'package:flutter/material.dart';
import 'package:ui/card/parents_reply_card.dart';
import 'package:ui/config/size_config.dart';
import 'package:ui/model/message_view_model.dart';
import 'package:ui/utils/utils_file.dart';

class ApproveDenyWidget extends StatelessWidget {
  final Function callback;
  final Message data;
  final String user;

  const ApproveDenyWidget(
      {super.key,
      required this.callback,
      required this.data,
      required this.user});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return user == 'staff'
        ? Padding(
            padding: EdgeInsets.all(5),
            child: Image.asset(
              'assets/images/clockwise.png',
              height: 15,
              width: 15,
            ),
          )
        : SizedBox(
            // group72SUS (7:816)
            width: 67 * fem,
            // height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // group75jiS (7:817)
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 4 * fem),
                  width: double.infinity,
                  height: 16 * fem,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // group70qmU (7:818)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 5 * fem, 0.94 * fem),
                        width: 13 * fem,
                        height: 11.06 * fem,
                        child: Image.asset(
                          'assets/images/group-70.png',
                          width: 13 * fem,
                          height: 11.06 * fem,
                        ),
                      ),
                      Material(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(
                                  "Approve Confirmation",
                                  style: TextStyle(
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]),
                                ),
                                content: Text(
                                  "Do you wants to Approve the Message?",
                                  style: TextStyle(
                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                      color: Colors.grey[700]),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(ctx).pop();
                                      approver(context,
                                          approval: "1",
                                          notifyid:
                                              data.notificationId.toString());
                                      callback(ctx);
                                    },
                                    child: const Text("Aprove"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                ],
                              ),
                            );
                          },
                          // onTap: () async {
                          //    Navigator.of(ctx).pop();
                          //   aprover(context,
                          //       aproval: "1",
                          //       notifyid: widget.data.notificationId
                          //           .toString());
                          //           widget.callback(ctx);
                          // },
                          child: Container(
                            // group7676i (7:821)
                            padding: EdgeInsets.fromLTRB(
                                2 * fem, 3 * fem, 1 * fem, 1 * fem),
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xff2c5ec0),
                              borderRadius: BorderRadius.circular(3 * fem),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x93000000),
                                  offset: Offset(-1 * fem, 1 * fem),
                                  blurRadius: 2 * fem,
                                ),
                              ],
                            ),
                            child: Text(
                              'Approve',
                              style: SafeGoogleFont(
                                'Inter',
                                fontSize: 10 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 0.9152273178 * ffem / fem,
                                letterSpacing: 1 * fem,
                                color: const Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  // group73hqc (7:824)
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 3 * fem, 6 * fem, 0 * fem),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // group71ote (7:828)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 8 * fem, 0 * fem),
                        width: 12 * fem,
                        height: 13.28 * fem,
                        child: Image.asset(
                          'assets/images/group-71.png',
                          width: 13.1 * fem,
                          height: 13.28 * fem,
                        ),
                      ),
                      Material(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(
                                  "Deny Confirmation",
                                  style: TextStyle(
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]),
                                ),
                                content: Text(
                                  "Do you wants to Deny the Message?",
                                  style: TextStyle(
                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                      color: Colors.grey[700]),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(ctx).pop();
                                      denied(context,
                                          approval: "2",
                                          notifyid:
                                              data.notificationId.toString());
                                      callback(ctx);
                                    },
                                    child: const Text("Denied"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            // group77HYv (7:825)
                            width: 34 * fem,
                            height: 16 * fem,
                            decoration: BoxDecoration(
                              color: const Color(0xff2c5ec0),
                              borderRadius: BorderRadius.circular(3 * fem),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x93000000),
                                  offset: Offset(-1 * fem, 1 * fem),
                                  blurRadius: 2 * fem,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Deny',
                                style: SafeGoogleFont(
                                  'Inter',
                                  fontSize: 9 * ffem,
                                  fontWeight: FontWeight.w300,
                                  height: 0.9152273178 * ffem / fem,
                                  letterSpacing: 1 * fem,
                                  color: const Color(0xffffffff),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

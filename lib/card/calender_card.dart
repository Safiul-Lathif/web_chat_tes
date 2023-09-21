// import 'package:flutter/material.dart';
// import 'package:tes_chat/Screens/googleFont.dart';
// import 'package:ui/model/message_view_model.dart';

// import 'package:ui/model/news_feed_model.dart';
// import 'package:tes_chat/widget/school_admin.dart';
// import 'package:tes_chat/widget/time_widget.dart';
// import 'package:tes_chat/widget/visiblity_widget.dart';

// class CalenderCard extends StatelessWidget {
//   const CalenderCard({super.key, required this.data, required this.itemIndex});
//   final Message data;
//   final int itemIndex;
//   @override
//   Widget build(BuildContext context) {
//     double baseWidth = 414;
//     double fem = MediaQuery.of(context).size.width / baseWidth;
//     double ffem = fem * 0.97;
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SchoolAdmin(),
//         Padding(
//           padding: const EdgeInsets.only(
//             top: 5,
//           ),
//           child: SizedBox(
//             width: 200,
//             height: 30,
//             child: Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(
//                     'assets/images/rectangle-6-3Ez.png',
//                   ),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 7, left: 5),
//                 child: Column(
//                   children: const [
//                     Text(
//                       "New addition to calender ",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Row(
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 0),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.78,
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.deepOrange),
//                     borderRadius: const BorderRadius.only(
//                       topRight: Radius.circular(15),
//                       bottomLeft: Radius.circular(15),
//                       bottomRight: Radius.circular(15),
//                     )),
//                 child: Padding(
//                     padding: const EdgeInsets.only(
//                         left: 10, top: 10, bottom: 10, right: 5),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 90,
//                               child: Wrap(
//                                 runSpacing: 10,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.sell_outlined,
//                                         size: 18,
//                                       ),
//                                       const SizedBox(
//                                         width: 3,
//                                       ),
//                                       Text(
//                                         "Title",
//                                         style: TextStyle(
//                                             color: Colors.brown.shade900,
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold),
//                                       )
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.category_outlined,
//                                         size: 18,
//                                       ),
//                                       const SizedBox(
//                                         width: 3,
//                                       ),
//                                       Text(
//                                         "Category",
//                                         style: TextStyle(
//                                             color: Colors.brown.shade900,
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold),
//                                       )
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.calendar_month,
//                                         size: 18,
//                                       ),
//                                       const SizedBox(
//                                         width: 3,
//                                       ),
//                                       Text(
//                                         "Date",
//                                         style: TextStyle(
//                                             color: Colors.brown.shade900,
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold),
//                                       )
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               height: 50,
//                               width: 1,
//                               decoration: const BoxDecoration(
//                                   gradient: LinearGradient(colors: [
//                                 Colors.white,
//                                 Color(0xffcccccc),
//                                 Colors.white
//                               ])),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: const [
//                                 Text(
//                                   "Parent Teachers Meeting",
//                                   style: TextStyle(
//                                       color: Colors.brown,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w400),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Text(
//                                   "General",
//                                   style: TextStyle(
//                                       color: Colors.brown,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w400),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Text(
//                                   "22-Dec-2022",
//                                   style: TextStyle(
//                                       color: Colors.brown,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w400),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         Container(
//                           height: 1,
//                           decoration: const BoxDecoration(
//                               gradient: LinearGradient(colors: [
//                             Colors.white,
//                             Color(0xffcccccc),
//                             Colors.white
//                           ])),
//                         ),
//                         const SizedBox(
//                           height: 6,
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               " View calender",
//                               style: TextStyle(
//                                   color: Colors.transparent,
//                                   decorationColor: Colors.red.shade300,
//                                   shadows: [
//                                     Shadow(
//                                         color: Colors.red.shade300,
//                                         offset: const Offset(0, -3))
//                                   ],
//                                   decoration: TextDecoration.underline,
//                                   decorationThickness: 1.5),
//                             ),
//                             Icon(
//                               Icons.calendar_month,
//                               color: Colors.red.shade300,
//                               size: 18,
//                             )
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 3,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: const [
//                             Icon(
//                               Icons.remove_red_eye_sharp,
//                               size: 15,
//                             ),
//                             SizedBox(
//                               width: 3,
//                             ),
//                             Text(
//                               "Watched: 35",
//                               style: TextStyle(fontSize: 11),
//                             )
//                           ],
//                         ),
//                       ],
//                     )),
//               ),
//             ),
//             //  TimeWiget(tym: data.dateTime.toString(),notiid:0,gid:"")
//           ],
//         ),
//         VisibilityWidget(role: '', visible: data.visibility.toString()),
//         Padding(
//           padding: const EdgeInsets.only(left: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0x3fccccccc),
//                       offset: Offset(0 * fem, 0 * fem),
//                       blurRadius: 1 * fem,
//                     ),
//                   ],
//                 ),
//                 child: const CircleAvatar(
//                   radius: 11,
//                   backgroundImage:
//                       AssetImage("assets/images/rectangle-7-X7G.png"),
//                   child: Text(
//                     "!",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontSize: 18),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 5, top: 5),
//                 child: Container(
//                   margin: EdgeInsets.fromLTRB(
//                       10 * fem, 0 * fem, 200 * fem, 0 * fem),
//                   padding:
//                       EdgeInsets.fromLTRB(11 * fem, 4 * fem, 15 * fem, 3 * fem),
//                   height: 23,
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                       topRight: Radius.circular(5),
//                       bottomLeft: Radius.circular(5),
//                       bottomRight: Radius.circular(5),
//                       topLeft: Radius.circular(5),
//                     ),
//                     image: const DecorationImage(
//                       fit: BoxFit.cover,
//                       image: AssetImage(
//                         'assets/images/rectangle-3-jsg.png',
//                       ),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0x3f000000),
//                         offset: Offset(-2 * fem, 2 * fem),
//                         blurRadius: 2 * fem,
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Text(
//                         "Mahesh ",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         "Principal",
//                         softWrap: true,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 5, left: 10),
//           child: SizedBox(
//             width: 160,
//             height: 32,
//             child: Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(
//                     'assets/images/rectangle-7-JCr.png',
//                   ),
//                 ),
//               ),
//               child: const Center(
//                 child: Text(
//                   "From Management ",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 5, left: 25),
//           child: SizedBox(
//             width: 160,
//             height: 32,
//             child: Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(
//                     'assets/images/rectangle-7-JCr.png',
//                   ),
//                 ),
//               ),
//               child: const Center(
//                 child: Text(
//                   " Management Speaks ",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Row(
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 0),
//               child: Container(
//                   width: MediaQuery.of(context).size.width * 0.7,
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.blue),
//                       borderRadius: const BorderRadius.only(
//                         topRight: Radius.circular(15),
//                         bottomLeft: Radius.circular(15),
//                         bottomRight: Radius.circular(15),
//                       )),
//                   child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Text(
//                         "Hello parents i am writing to inform you that a new announcement from  government is received and a new direction on syllabus will be shared with you all soon .We hope that it will be great modification to make ",
//                         textAlign: TextAlign.start,
//                         style: SafeGoogleFont(
//                           'Inter',
//                           fontSize: 16 * ffem,
//                           fontWeight: FontWeight.w500,
//                           height: 1.2125 * ffem / fem,
//                           color: Colors.black,
//                         ),
//                       ))),
//             ),
//             //  TimeWiget(tym: data.dateTime.toString(),notiid:0,gid:"")
//           ],
//         ),
//         VisibilityWidget(visible: data.visibility.toString()),
//         Padding(
//           padding: const EdgeInsets.only(left: 5, top: 5),
//           child: Container(
//             margin: EdgeInsets.fromLTRB(10 * fem, 0 * fem, 220 * fem, 0 * fem),
//             padding: EdgeInsets.fromLTRB(11 * fem, 4 * fem, 15 * fem, 3 * fem),
//             height: 23,
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(5),
//                 bottomLeft: Radius.circular(5),
//                 bottomRight: Radius.circular(5),
//                 topLeft: Radius.circular(5),
//               ),
//               image: const DecorationImage(
//                 fit: BoxFit.cover,
//                 image: AssetImage(
//                   'assets/images/rectangle-3-jsg.png',
//                 ),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0x3f000000),
//                   offset: Offset(-2 * fem, 2 * fem),
//                   blurRadius: 2 * fem,
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Text(
//                   "Mahesh ",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "Principal",
//                   softWrap: true,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 5),
//           child: SizedBox(
//             width: 120,
//             height: 32,
//             child: Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(
//                     'assets/images/rectangle-7-oyU.png',
//                   ),
//                 ),
//               ),
//               child: const Center(
//                 child: Text(
//                   "Quote",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Row(
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 0),
//               child: Container(
//                   width: MediaQuery.of(context).size.width * 0.7,
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.blue),
//                       borderRadius: const BorderRadius.only(
//                         topRight: Radius.circular(15),
//                         bottomLeft: Radius.circular(15),
//                         bottomRight: Radius.circular(15),
//                       )),
//                   child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Text(
//                         " \" He who has plans correctly and puts consistence efforts will always win!\" -- Anonymous  ",
//                         textAlign: TextAlign.start,
//                         style: SafeGoogleFont(
//                           'Inter',
//                           fontSize: 16 * ffem,
//                           fontWeight: FontWeight.w500,
//                           height: 1.2125 * ffem / fem,
//                           color: Colors.black,
//                         ),
//                       ))),
//             ),
//             //  TimeWiget(tym: data.dateTime.toString(),notiid:0,gid:"")
//           ],
//         ),
//         VisibilityWidget(visible: data.visibility.toString()),
//         Padding(
//           padding: const EdgeInsets.only(left: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0x3fccccccc),
//                       offset: Offset(0 * fem, 0 * fem),
//                       blurRadius: 1 * fem,
//                     ),
//                   ],
//                 ),
//                 child: const CircleAvatar(
//                   radius: 11,
//                   backgroundImage:
//                       AssetImage("assets/images/rectangle-7-X7G.png"),
//                   child: Text(
//                     "!",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontSize: 18),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 5, top: 5),
//                 child: Container(
//                   margin: EdgeInsets.fromLTRB(
//                       10 * fem, 0 * fem, 200 * fem, 0 * fem),
//                   padding:
//                       EdgeInsets.fromLTRB(11 * fem, 4 * fem, 15 * fem, 3 * fem),
//                   height: 33,
//                   width: 120,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(5),
//                       bottomLeft: Radius.circular(5),
//                       bottomRight: Radius.circular(5),
//                       topLeft: Radius.circular(5),
//                     ),
//                     image: DecorationImage(
//                       image: AssetImage(
//                         'assets/images/rectangle-7-X7G.png',
//                       ),
//                     ),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       "IMPORTANT",
//                       softWrap: true,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Row(
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 0),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.70,
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.pink.shade400),
//                     borderRadius: const BorderRadius.only(
//                       topRight: Radius.circular(15),
//                       bottomLeft: Radius.circular(15),
//                       bottomRight: Radius.circular(15),
//                     )),
//                 child: Padding(
//                     padding: const EdgeInsets.only(
//                         left: 10, top: 10, bottom: 10, right: 5),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Exam Timetable published ",
//                           textAlign: TextAlign.center,
//                           style: SafeGoogleFont(
//                             'Inter',
//                             fontSize: 18 * ffem,
//                             fontWeight: FontWeight.w500,
//                             height: 0.9152272542 * ffem / fem,
//                             letterSpacing: 1.2 * fem,
//                             color: const Color(0xff000000),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Container(
//                           height: 1,
//                           decoration: const BoxDecoration(
//                               gradient: LinearGradient(colors: [
//                             Colors.white,
//                             Color(0xffcccccc),
//                             Colors.white
//                           ])),
//                         ),
//                         const SizedBox(
//                           height: 6,
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               " View Timetable",
//                               style: TextStyle(
//                                   color: Colors.transparent,
//                                   decorationColor: Colors.pink.shade300,
//                                   shadows: [
//                                     Shadow(
//                                         color: Colors.pink.shade300,
//                                         offset: const Offset(0, -3))
//                                   ],
//                                   decoration: TextDecoration.underline,
//                                   decorationThickness: 1.5),
//                             ),
//                             Icon(
//                               Icons.calendar_month,
//                               color: Colors.pink.shade300,
//                               size: 18,
//                             )
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 3,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: const [
//                             Icon(
//                               Icons.remove_red_eye_sharp,
//                               size: 15,
//                             ),
//                             SizedBox(
//                               width: 3,
//                             ),
//                             Text(
//                               "Watched: 55",
//                               style: TextStyle(fontSize: 11),
//                             )
//                           ],
//                         ),
//                       ],
//                     )),
//               ),
//             ),
//             // TimeWiget(tym: data.dateTime.toString(),notiid:0,gid:"")
//           ],
//         ),
//         VisibilityWidget(visible: data.visibility.toString())
//       ],
//     );
//   }
// }

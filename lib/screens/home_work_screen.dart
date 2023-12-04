import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ui/api/get_home_work.dart';
import 'package:ui/config/images.dart';
import 'package:ui/model/class_group_model.dart';
import 'package:ui/pages/home_work_page.dart';

class HomeWorkScreen extends StatefulWidget {
  const HomeWorkScreen({super.key});

  @override
  State<HomeWorkScreen> createState() => _HomeWorkScreenState();
}

class _HomeWorkScreenState extends State<HomeWorkScreen> {
  ClassGroup? classGroup;
  final DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    initialize(_selectedDate);
  }

  void initialize(DateTime dateTime) async {
    await getHomeWork(dateTime).then((value) {
      if (mounted) {
        setState(() {
          classGroup = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //padding: const EdgeInsets.only(top: 13),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.blue.withOpacity(0.2), BlendMode.dstATop),
              image: const AssetImage(
                Images.bgImage,
              ),
              repeat: ImageRepeat.repeat),
        ),
        child: Column(children: [
          // Container(
          //   decoration: BoxDecoration(
          //       color: Colors.green,
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.grey.withOpacity(.5),
          //             offset: const Offset(3, 2),
          //             blurRadius: 7)
          //       ],
          //       image: DecorationImage(
          //           colorFilter: ColorFilter.mode(
          //               Colors.blue.withOpacity(0.1), BlendMode.dstATop),
          //           image: const NetworkImage(
          //               "https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg"),
          //           repeat: ImageRepeat.repeat)),
          //   padding: const EdgeInsets.only(
          //     top: 5,
          //     bottom: 5,
          //   ),
          //   child: CalendarTimeline(
          //     initialDate: _selectedDate,
          //     firstDate: DateTime(2020),
          //     lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
          //     onDateSelected: (date) async {
          //       setState(() {
          //         _selectedDate = date;
          //       });
          //       initialize(_selectedDate);
          //     },
          //     leftMargin: 150,
          //     monthColor: Colors.black,
          //     dayColor: Colors.white,
          //     dayNameColor: const Color(0xFF333A47),
          //     activeDayColor: Colors.white,
          //     activeBackgroundDayColor: Colors.blueGrey.shade100,
          //     dotsColor: const Color(0xFF333A47),
          //     locale: 'en',
          //   ),
          // ),
          classGroup == null
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: Lottie.network(
                      'https://assets8.lottiefiles.com/packages/lf20_fzmasdx7.json',
                      height: 100.0,
                      repeat: true,
                      reverse: true,
                      animate: true,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 310,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20),
                              itemCount: classGroup!.classGroup.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(
                                  top: 20, bottom: 20, left: 15, right: 15),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeWorkPage(
                                              isParent: false,
                                              classId: classGroup!
                                                  .classGroup[index].classConfig
                                                  .toString(),
                                              className: classGroup!
                                                  .classGroup[index].groupName,
                                            ),
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              colorFilter: ColorFilter.mode(
                                                  Colors.blue.withOpacity(0.2),
                                                  BlendMode.dstATop),
                                              image: const AssetImage(
                                                Images.bgImage,
                                              ),
                                              fit: BoxFit.cover),
                                          color: Colors.blueGrey.shade200,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.green.shade500,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(
                                                                20))),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    classGroup!
                                                        .classGroup[index]
                                                        .groupName,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  LinearPercentIndicator(
                                                    width: 100,
                                                    animation: true,
                                                    lineHeight: 20.0,
                                                    animationDuration: 2000,
                                                    percent: ((int.parse(classGroup!
                                                            .classGroup[index]
                                                            .uploadedHomeworksCount
                                                            .toString()) /
                                                        int.parse(classGroup!
                                                            .classGroup[index]
                                                            .subjectList
                                                            .length
                                                            .toString()))),
                                                    center: Text(
                                                      "${((int.parse(classGroup!.classGroup[index].uploadedHomeworksCount.toString()) / int.parse(classGroup!.classGroup[index].subjectList.length.toString())) * 100).toStringAsFixed(0)} %",
                                                    ),
                                                    backgroundColor:
                                                        Colors.grey,
                                                    progressColor: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text(
                                                            'Class Teacher :',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff575757),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                            classGroup!
                                                                .classGroup[
                                                                    index]
                                                                .classTeacher,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xff575757),
                                                              fontSize: 14,
                                                            )),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                            'Number of subjects :',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff575757),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                            classGroup!
                                                                .classGroup[
                                                                    index]
                                                                .subjectList
                                                                .length
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xff575757),
                                                              fontSize: 14,
                                                            )),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                            'Parents Count:',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff575757),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                            classGroup!
                                                                .classGroup[
                                                                    index]
                                                                .totalParentCount
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xff575757),
                                                              fontSize: 14,
                                                            )),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                            'HomeWork Added:',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff575757),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                            "${classGroup!.classGroup[index].uploadedHomeworksCount.toString()}/${classGroup!.classGroup[index].subjectList.length.toString()}",
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xff575757),
                                                              fontSize: 14,
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }))))
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/DivisionlistApi.dart';
import 'package:ui/api/deleteApi.dart';
import 'package:ui/api/excelAPiservice.dart';
import 'package:ui/api/get_subjects_list_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/DivisionlistModel.dart';
import 'package:ui/model/MapClassModel.dart';
import 'package:ui/model/get_subjects_list.dart';

class SubjectWidget extends StatefulWidget {
  const SubjectWidget({super.key});

  @override
  State<SubjectWidget> createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget> {
  List<Division> divisions = [];
  List<Subjects>? subjects;
  int divisionId = 0;
  bool isLoading = true;
  String className = '';

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await getDivisionList().then((value) {
      if (value != null) {
        setState(() {
          divisions = value;
          divisionId = divisions[0].id;
        });
      }
    });
    getListOfSubject(divisionId);
  }

  void getListOfSubject(int divId) async {
    await getSubjectsList(divId: divId.toString()).then((value) {
      if (value != null) {
        setState(() {
          subjects = value;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Subjects"),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await addData(
                                configType: "subjects",
                                updateType: "manual",
                                data: [className],
                                divId: divisionId.toString())
                            .then((value) {
                          getListOfSubject(divisionId);
                          if (value != null) {
                            Utility.displaySnackBar(context, value["message"]);
                          } else {
                            Utility.displaySnackBar(context, "error");
                          }
                          Navigator.pop(context);
                        });
                      },
                      child: const Text("Submit")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"))
                ],
                content: FormBuilderTextField(
                  onChanged: (value) {
                    setState(() {
                      className = value!;
                    });
                  },
                  name: 'Subjects name',
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: 'type Subject name ',
                      focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                      labelStyle: TextStyle(color: Colors.grey.shade800),
                      contentPadding:
                          const EdgeInsets.only(left: 10, top: 4, bottom: 4)),
                ),
              );
            },
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Subjects"),
        tooltip: 'Add Subjects',
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.2), BlendMode.dstATop),
                image: const AssetImage(Images.bgImage),
                repeat: ImageRepeat.repeatX)),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Subject List",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                )),
            DefaultTabController(
                length: divisions.length,
                initialIndex: 0,
                child: Column(children: <Widget>[
                  TabBar(
                    onTap: (value) {
                      setState(() {
                        isLoading = true;
                        divisionId = divisions[value].id;
                      });
                      getListOfSubject(divisionId);
                    },
                    isScrollable: true,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(color: Colors.black),
                    unselectedLabelColor: Colors.black,
                    indicator: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(10), // Creates border
                        color: Colors.blue.shade200),
                    tabs: [
                      for (int i = 0; i < divisions.length; i++)
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              divisions[i].divisionName,
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16)),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.83,
                      child: TabBarView(children: [
                        for (int i = 0; i < divisions.length; i++)
                          subjects == null
                              ? LoadingAnimator()
                              : subjects!.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No Subjects here click add button to add the division",
                                        style: GoogleFonts.lato(),
                                      ),
                                    )
                                  : GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 5,
                                              crossAxisCount: 4),
                                      itemCount: subjects!.length,
                                      itemBuilder: (context, index) {
                                        var subjectList = subjects![index];
                                        return Card(
                                          child: ListTile(
                                            title: Text(
                                              subjectList.subjectName,
                                              style: GoogleFonts.lato(),
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Do you want to Delete this division"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              await deleteClass(
                                                                      clsId: subjects![
                                                                              i]
                                                                          .id
                                                                          .toString(),
                                                                      divisionId:
                                                                          divisionId
                                                                              .toString())
                                                                  .then(
                                                                      (value) {
                                                                if (value !=
                                                                    null) {
                                                                  getListOfSubject(
                                                                      divisionId);

                                                                  Utility.displaySnackBar(
                                                                      context,
                                                                      "Deleted Successfully");
                                                                } else {
                                                                  Utility.displaySnackBar(
                                                                      context,
                                                                      "Not Deleted");
                                                                }
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                            child: const Text(
                                                                "Yes")),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "No"))
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                      ]))
                ])),
          ],
        ),
      ),
    );
  }
}

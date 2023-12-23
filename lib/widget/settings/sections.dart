import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/api/settings/index.dart';
import 'package:ui/model/settings/index.dart';

class SectionWidget extends StatefulWidget {
  const SectionWidget({super.key});

  @override
  State<SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  List<Division> divisions = [];
  SectionList? sectionList;
  int divisionId = 0;
  bool isLoading = true;
  String sectionName = '';

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
    getListOfSections(divisionId);
  }

  void getListOfSections(int divId) async {
    await getSectionList(dId: divId.toString()).then((value) {
      if (value != null) {
        setState(() {
          sectionList = value;
          isLoading = false;
        });
      }
    });
  }

  Future<void> addEditPopUp(bool isAdd, Section section) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isAdd ? "Add Sections" : "Edit Sections"),
          actions: [
            TextButton(
                onPressed: () async {
                  await addEditSection(
                          sectionId: section.id,
                          sectionName: sectionName,
                          divId: divisionId.toString())
                      .then((value) {
                    getListOfSections(divisionId);
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
                sectionName = value!;
              });
            },
            name: 'Sections name',
            initialValue: section.sectionName,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintText: 'type section name ',
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1)),
                labelStyle: TextStyle(color: Colors.grey.shade800),
                contentPadding:
                    const EdgeInsets.only(left: 10, top: 4, bottom: 4)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          addEditPopUp(true, Section(id: 0, sectionName: '', isclicked: false));
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Section"),
        tooltip: 'Add Sections',
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
                  "Section List",
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
                      getListOfSections(divisionId);
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
                          sectionList == null
                              ? LoadingAnimator()
                              : sectionList!.sections!.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No Sections here click add button to add the Sections",
                                        style: GoogleFonts.lato(),
                                      ),
                                    )
                                  : GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 5,
                                              crossAxisCount: 4),
                                      itemCount: sectionList!.sections!.length,
                                      itemBuilder: (context, index) {
                                        var section =
                                            sectionList!.sections![index];
                                        return Card(
                                          child: ListTile(
                                            title: Text(
                                              section.sectionName,
                                              style: GoogleFonts.lato(),
                                            ),
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        content:
                                                            SingleChildScrollView(
                                                                child: Column(
                                                                    children: [
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        title: const Text(
                                                                            "Do you want to Delete this division"),
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: () async {
                                                                                await deleteSection(secId: section.id.toString(), divId: divisionId.toString()).then((value) {
                                                                                  if (value != null) {
                                                                                    getListOfSections(divisionId);
                                                                                    Utility.displaySnackBar(context, "Deleted Successfully");
                                                                                  } else {
                                                                                    Utility.displaySnackBar(context, "Not Deleted");
                                                                                  }
                                                                                  Navigator.pop(context);
                                                                                });
                                                                              },
                                                                              child: const Text("Yes")),
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text("No"))
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text("Delete ${section.sectionName}"),
                                                                        )),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  addEditPopUp(
                                                                      false,
                                                                      section);
                                                                },
                                                                child:
                                                                    Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text("Edit ${section.sectionName}"),
                                                                        )),
                                                              ),
                                                            ])));
                                                  });
                                            },
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

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/settings/index.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/settings/index.dart';

class ClassWidget extends StatefulWidget {
  const ClassWidget({super.key});

  @override
  State<ClassWidget> createState() => _ClassWidgetState();
}

class _ClassWidgetState extends State<ClassWidget> {
  List<Division> divisions = [];
  List<ListsClass>? classes;
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
    getListOfClass(divisionId);
  }

  void getListOfClass(int divId) async {
    await getClassList(dId: divId.toString()).then((value) {
      if (value != null) {
        setState(() {
          classes = value;
          isLoading = false;
        });
      }
    });
  }

  Future<void> addEditPopUp(bool isAdd, ListsClass classList) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isAdd ? "Add Classes" : "Edit Classes"),
          actions: [
            TextButton(
                onPressed: () async {
                  await addEditClass(
                          classId: classList.id,
                          className: className,
                          divId: divisionId.toString())
                      .then((value) {
                    getListOfClass(divisionId);
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
            name: 'Classes name',
            initialValue: classList.className,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintText: 'type Class name ',
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
          addEditPopUp(true, ListsClass(id: 0, className: ''));
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Classes"),
        tooltip: 'Add Classes',
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
                  "Class List",
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
                      getListOfClass(divisionId);
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
                          classes == null
                              ? LoadingAnimator()
                              : classes!.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No Classes here click add button to add the division",
                                        style: GoogleFonts.lato(),
                                      ),
                                    )
                                  : GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 5,
                                              crossAxisCount: 4),
                                      itemCount: classes!.length,
                                      itemBuilder: (context, index) {
                                        var classList = classes![index];
                                        return Card(
                                          child: ListTile(
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
                                                                onTap: () {
                                                                  delete(i);
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
                                                                              Text("Delete ${classList.className}"),
                                                                        )),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  addEditPopUp(
                                                                      false,
                                                                      classList);
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
                                                                              Text("Edit ${classList.className}"),
                                                                        )),
                                                              ),
                                                            ])));
                                                  });
                                            },
                                            title: Text(
                                              classList.className,
                                              style: GoogleFonts.lato(),
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

  Future<void> delete(int i) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Do you want to Delete this division"),
          actions: [
            TextButton(
                onPressed: () async {
                  await deleteClass(
                          clsId: classes![i].id.toString(),
                          divisionId: divisionId.toString())
                      .then((value) {
                    if (value != null) {
                      getListOfClass(divisionId);

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
  }
}

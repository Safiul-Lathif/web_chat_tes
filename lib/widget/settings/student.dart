import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/excelAPiservice.dart';
import 'package:ui/api/search/get_management_list_api.dart';
import 'package:ui/api/settings/index.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';

import 'package:ui/model/search/management_list_model.dart';
import 'package:ui/model/settings/index.dart';

class StudentWidget extends StatefulWidget {
  const StudentWidget({super.key});

  @override
  State<StudentWidget> createState() => _StudentWidgetState();
}

class _StudentWidgetState extends State<StudentWidget> {
  List<Division>? divisions = [];
  List<ListsClass>? classes;
  int divisionId = 0;
  bool isLoading = true;
  String className = '';
  SectionList? sectionList;
  List<ManagementList>? managementList = [];

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
          divisionId = divisions![0].id;
        });
      }
    });
    getListOfStudent(divisionId);
    getListOfSections(divisionId);
    await getManagementList(0).then((value) {
      if (value != null) {
        setState(() {
          managementList = value.data;
          isLoading = false;
        });
      }
    });
  }

  void getListOfStudent(int divId) async {
    await getClassList(dId: divId.toString()).then((value) {
      if (value != null) {
        setState(() {
          classes = value;
          isLoading = false;
        });
      }
    });
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
                title: const Text("Add Classes"),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await addData(
                                configType: "classes",
                                updateType: "manual",
                                data: [className],
                                divId: divisionId.toString())
                            .then((value) {
                          getListOfStudent(divisionId);
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
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: 'type Class name ',
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
        label: const Text("Add Students"),
        tooltip: 'Add Students',
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
                  "Student List",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Row(
                    children: [
                      Text(
                        "Division",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (divisions != null)
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: DropdownButtonFormField<dynamic>(
                              isExpanded: true,
                              value: divisions![0].divisionName,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1)),
                                  labelStyle:
                                      TextStyle(color: Colors.grey.shade800),
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, top: 4, bottom: 4)),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: divisions!
                                  .map<DropdownMenuItem<dynamic>>((item) {
                                return DropdownMenuItem(
                                  value: item.divisionName,
                                  child: Text(item.divisionName),
                                );
                              }).toList(),
                              onChanged: (newValue) async {
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Row(
                    children: [
                      Text(
                        "Sections",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (sectionList != null)
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: DropdownButtonFormField<dynamic>(
                              isExpanded: true,
                              value: sectionList!.sections![0].sectionName,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1)),
                                  labelStyle:
                                      TextStyle(color: Colors.grey.shade800),
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, top: 4, bottom: 4)),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: sectionList!.sections!
                                  .map<DropdownMenuItem<dynamic>>((item) {
                                return DropdownMenuItem(
                                  value: item.sectionName,
                                  child: Text(item.sectionName),
                                );
                              }).toList(),
                              onChanged: (newValue) async {
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Row(
                    children: [
                      Text(
                        "classes",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (sectionList != null)
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: DropdownButtonFormField<dynamic>(
                              isExpanded: true,
                              value: classes![0].className,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1)),
                                  labelStyle:
                                      TextStyle(color: Colors.grey.shade800),
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, top: 4, bottom: 4)),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: classes!
                                  .map<DropdownMenuItem<dynamic>>((item) {
                                return DropdownMenuItem(
                                  value: item.className,
                                  child: Text(item.className),
                                );
                              }).toList(),
                              onChanged: (newValue) async {
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: managementList == null
                  ? LoadingAnimator()
                  : managementList!.isEmpty
                      ? Center(
                          child: Text(
                            "No Management here click add button to add the Managements",
                            style: GoogleFonts.lato(),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 330,
                                  childAspectRatio: 4 / 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: managementList!.length,
                          itemBuilder: (context, index) {
                            var management = managementList![index];
                            return InkWell(
                              onTap: () {
                                // showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       return AlertDialog(
                                //           shape: RoundedRectangleBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(10),
                                //           ),
                                //           contentPadding: EdgeInsets.zero,
                                //           content: SingleChildScrollView(
                                //               child: Column(children: [
                                //             InkWell(
                                //               onTap: () async {
                                //                 await deleteManagement(
                                //                         managementId: management
                                //                             .id
                                //                             .toString())
                                //                     .then((value) {
                                //                   getListOfManagement();
                                //                   if (value != null) {
                                //                     Navigator.pop(context);
                                //                     Utility.displaySnackBar(
                                //                         context,
                                //                         "Delete Successfully");
                                //                   } else {
                                //                     Navigator.pop(context);
                                //                     Utility.displaySnackBar(
                                //                         context, "Not Deleted");
                                //                   }
                                //                 });
                                //               },
                                //               child: Container(
                                //                   width: double.infinity,
                                //                   padding: const EdgeInsets.only(
                                //                       top: 10, bottom: 10),
                                //                   child: Center(
                                //                     child: Text(
                                //                         "Delete ${management.firstName}"),
                                //                   )),
                                //             ),
                                //             InkWell(
                                //               onTap: () {
                                //                 setState(() {
                                //                   isEdit = true;
                                //                   userId =
                                //                       management.id.toString();
                                //                   nameController.text =
                                //                       management.firstName;
                                //                   mailController.text = management
                                //                       .mobileNumber
                                //                       .toString();
                                //                   numberController.text =
                                //                       management.mobileNumber
                                //                           .toString();
                                //                 });
                                //                 Navigator.pop(context);
                                //                 addEditPopUp(management);
                                //               },
                                //               child: Container(
                                //                   width: double.infinity,
                                //                   padding: const EdgeInsets.only(
                                //                       top: 10, bottom: 10),
                                //                   child: Center(
                                //                     child: Text(
                                //                         "Edit ${management.firstName}"),
                                //                   )),
                                //             ),
                                //           ])));
                                //     });
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        management.profileImage == ''
                                            ? Image.asset(
                                                Images.userProfile,
                                                width: 88.28,
                                                height: 81,
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                child: Image.network(
                                                  management.profileImage,
                                                  width: 88.28,
                                                  height: 81,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                      Images.userProfile,
                                                      width: 88.28,
                                                      height: 81,
                                                    );
                                                  },
                                                ),
                                              ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Name : ",
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ),
                                                  Text(
                                                    management.firstName,
                                                    style: GoogleFonts.lato(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Number : ",
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ),
                                                  Text(
                                                    management.mobileNumber
                                                        .toString(),
                                                    style: GoogleFonts.lato(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Email : ",
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ),
                                                  FittedBox(
                                                    child: Text(
                                                      management.employeeNo ==
                                                              ''
                                                          ? "N/A"
                                                          : management
                                                              .employeeNo
                                                              .toString(),
                                                      style: GoogleFonts.lato(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Designation : ",
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ),
                                                  Text(
                                                    management.designation,
                                                    style: GoogleFonts.lato(),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }
}

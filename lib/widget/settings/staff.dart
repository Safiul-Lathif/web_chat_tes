import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/categoryListAPI.dart';
import 'package:ui/api/settings/index.dart';
import 'package:ui/api/deleteApi.dart';
import 'package:ui/api/designation_list_api.dart';
import 'package:ui/api/excelAPiservice.dart';
import 'package:ui/api/view_staff_list_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/categorylistModel.dart';
import 'package:ui/model/settings/index.dart';

class StaffWidget extends StatefulWidget {
  const StaffWidget({super.key});

  @override
  State<StaffWidget> createState() => _StaffWidgetState();
}

class _StaffWidgetState extends State<StaffWidget> {
  List<Division> divisions = [];
  List<DesignationList> designationList = [];
  List<StaffListModel>? staffList;
  List<Category> teacherCategory = [];
  List<Subject> subjectList = [];
  List<SectionDetail>? sectionList = [];

  int divisionId = 0;
  bool isLoading = true;
  bool isClassTeacher = false;
  bool notAClassTeacher = false;

  int designation = 0;
  String userId = '';
  int selectedSubject = 0;
  int selectedSection = 0;
  int selectedCategory = 0;
  TextEditingController mailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

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
    getListOfStaff();
    await getTeacherCategoryList().then((value) {
      if (value != null) {
        setState(() {
          teacherCategory = value;
          selectedCategory = value[0].id;
        });
      }
    });
    await getSubjectList().then((value) {
      if (value != null) {
        setState(() {
          subjectList = value;
          selectedSubject = value[0].id;
        });
      }
    });
    await getClassSectionsList(dId: divisionId.toString()).then((value) {
      if (value != null) {
        setState(() {
          sectionList = value;
          selectedSection = value[0].id;
        });
      }
    });
  }

  void getListOfStaff() async {
    await getStaffsList().then((value) {
      if (value != null) {
        setState(() {
          staffList = value;
          isLoading = false;
        });
      }
    });
    await getDesignationList().then((value) {
      if (value != null) {
        setState(() {
          designationList = value;
          designation = value[0].id;
        });
      }
    });
  }

  bool onError = false;
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            isEdit = false;
          });
          addEditPopUp();
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Staff"),
        tooltip: 'Add Staffs',
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
        child: Column(children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Staff List",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.83,
            child: staffList == null || designationList.isEmpty
                ? LoadingAnimator()
                : staffList!.isEmpty
                    ? Center(
                        child: Text(
                          "No Staff here click add button to add the Staffs",
                          style: GoogleFonts.lato(),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, childAspectRatio: 2.1),
                        itemCount: staffList!.length,
                        itemBuilder: (context, index) {
                          var staff = staffList![index];
                          return InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        content: SingleChildScrollView(
                                            child: Column(children: [
                                          InkWell(
                                            onTap: () async {
                                              await deleteStaff(
                                                      staffId:
                                                          staff.id.toString())
                                                  .then((value) {
                                                getListOfStaff();
                                                if (value != null) {
                                                  Navigator.pop(context);
                                                  Utility.displaySnackBar(
                                                      context,
                                                      "Delete Successfully");
                                                } else {
                                                  Navigator.pop(context);
                                                  Utility.displaySnackBar(
                                                      context, "Not Deleted");
                                                }
                                              });
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Center(
                                                  child: Text(
                                                      "Delete ${staff.firstName}"),
                                                )),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isEdit = true;
                                                userId = staff.id.toString();
                                                nameController.text =
                                                    staff.firstName;
                                                numberController.text = staff
                                                    .mobileNumber
                                                    .toString();
                                              });
                                              Navigator.pop(context);
                                              addEditPopUp();
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Center(
                                                  child: Text(
                                                      "Edit ${staff.firstName}"),
                                                )),
                                          ),
                                        ])));
                                  });
                            },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      staff.profileImage == ''
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
                                                staff.profileImage,
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
                                      Padding(
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
                                                  staff.firstName,
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
                                                  staff.mobileNumber.toString(),
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
                                                  "Designation : ",
                                                  style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ),
                                                Text(
                                                  "Teaching staff",
                                                  style: GoogleFonts.lato(),
                                                ),
                                              ],
                                            ),
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
        ]),
      ),
    );
  }

  addEditPopUp() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(isEdit ? "Edit Staff" : "Add Staff"),
          actions: [
            TextButton(
                onPressed: () async {
                  isEdit
                      ? await editManualDataStaff(
                          id: userId,
                          classTeacher: isClassTeacher == true ? "yes" : "no",
                          classConfig: selectedSection.toString(),
                          mail: mailController.text,
                          mob: numberController.text,
                          name: nameController.text,
                          special: selectedSubject.toString(),
                          teacherCategory: selectedCategory.toString(),
                        ).then((value) {
                          if (value != null) {
                            getListOfStaff();
                            Utility.displaySnackBar(context, value);
                          } else {
                            Utility.displaySnackBar(context, "error");
                          }
                          Navigator.pop(context);
                        })
                      : await manualDataStaff(
                          configType: "staffs",
                          updateType: "manual",
                          classTeacher: isClassTeacher == true ? "yes" : "no",
                          classSection: selectedSection.toString(),
                          mail: mailController.text,
                          mob: numberController.text,
                          name: nameController.text,
                          special: selectedSubject.toString(),
                          teacherCategory: selectedCategory.toString(),
                        ).then((value) {
                          getListOfStaff();
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
          content: SingleChildScrollView(
              child: StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                runSpacing: 15,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FormBuilderTextField(
                      name: 'Staff name',
                      controller: nameController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: 'type Staff name ',
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          labelStyle: TextStyle(color: Colors.grey.shade800),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 4, bottom: 4)),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FormBuilderTextField(
                      controller: numberController,
                      name: 'Staff Number',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: 'type Staff Number ',
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          labelStyle: TextStyle(color: Colors.grey.shade800),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 4, bottom: 4)),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: DropdownButtonFormField<dynamic>(
                      isExpanded: true,
                      value: selectedCategory,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          labelStyle: TextStyle(color: Colors.grey.shade800),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 4, bottom: 4)),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: teacherCategory
                          .map<DropdownMenuItem<dynamic>>((item) {
                        return DropdownMenuItem(
                          value: item.id,
                          child: Text(item.categoryName),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: DropdownButtonFormField<dynamic>(
                      isExpanded: true,
                      value: selectedSubject,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          labelStyle: TextStyle(color: Colors.grey.shade800),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 4, bottom: 4)),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: subjectList.map<DropdownMenuItem<dynamic>>((item) {
                        return DropdownMenuItem(
                          value: item.id,
                          child: Text(item.subjectName),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        setState(() {
                          selectedSubject = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FormBuilderTextField(
                      controller: mailController,
                      name: 'Staff email',
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: 'type Staff email ',
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          labelStyle: TextStyle(color: Colors.grey.shade800),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 4, bottom: 4)),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: DropdownButtonFormField<dynamic>(
                      isExpanded: true,
                      value: designation,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          labelStyle: TextStyle(color: Colors.grey.shade800),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 4, bottom: 4)),
                      items: designationList
                          .map<DropdownMenuItem<dynamic>>((item) {
                        return DropdownMenuItem(
                          value: item.id,
                          child: Text(item.categoryName),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        setState(() {
                          designation = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Row(
                      children: [
                        const Text(
                          "Class Teacher: ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Checkbox(
                          activeColor: Colors.transparent,
                          checkColor: const Color.fromARGB(255, 68, 138, 255),
                          value: isClassTeacher,
                          onChanged: (value) {
                            setState(() {
                              isClassTeacher = true;
                              notAClassTeacher = false;
                            });
                          },
                        ),
                        const Text("YES"),
                        Checkbox(
                          activeColor: Colors.transparent,
                          checkColor: const Color.fromARGB(255, 68, 138, 255),
                          value: notAClassTeacher,
                          onChanged: (value) {
                            setState(() {
                              isClassTeacher = false;
                              notAClassTeacher = true;
                            });
                          },
                        ),
                        const Text("NO"),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: DropdownButtonFormField<dynamic>(
                      isExpanded: true,
                      value: selectedSection,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          labelStyle: TextStyle(color: Colors.grey.shade800),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 4, bottom: 4)),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items:
                          sectionList!.map<DropdownMenuItem<dynamic>>((item) {
                        return DropdownMenuItem(
                          value: item.id,
                          child: Text(item.classSection),
                        );
                      }).toList(),
                      onChanged: isClassTeacher
                          ? (newValue) async {
                              setState(() {
                                selectedSection = newValue;
                              });
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            );
          })),
        );
      },
    );
  }
}

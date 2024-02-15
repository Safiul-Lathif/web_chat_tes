import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/search/check_mobile_number.dart';
import 'package:ui/api/search/get_management_list_api.dart';
import 'package:ui/api/settings/get_admissin_number.dart';
import 'package:ui/api/settings/index.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';

import 'package:ui/model/search/management_list_model.dart';
import 'package:ui/model/search/student_list_model.dart';
import 'package:ui/model/settings/index.dart';
import 'package:ui/widget/search_profile_student.dart';

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
  List<ParentList> parentList = [];
  int classSection = 0;
  String className = '';
  List<SectionDetail> sectionList = [];
  List<ManagementList>? managementList = [];
  List<PlatformFile> fatherPhoto = [];
  List<PlatformFile> motherPhoto = [];
  List<PlatformFile> guardianPhoto = [];
  List<PlatformFile> studentPhoto = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> getAllStudentList(int id) async {
    await StudentController().getAllParentList().then((value) {
      if (value != null) {
        setState(() {
          parentList = value;
        });
      }
    });
    filterStudentDataById(id);
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
    await getListOfSections(divisionId);

    await getManagementList(0).then((value) {
      if (value != null) {
        setState(() {
          managementList = value.data;
          isLoading = false;
        });
      }
    });
  }

  Future<void> filterStudentDataById(int classConfig) async {
    setState(() {
      classSection = classConfig;
      parentList = parentList
          .where((element) => element.classConfig == classConfig)
          .toList();
    });
  }

  Future<void> getListOfSections(int divId) async {
    await getClassSectionsList(dId: divId.toString()).then((value) {
      if (value != null) {
        setState(() {
          sectionList = value;
          isLoading = false;
        });
      }
    });
    if (sectionList.isEmpty) {
      setState(() {
        parentList.clear();
      });
    } else {
      getAllStudentList(sectionList.first.id);
    }
  }

  Future<bool> studentProfileInfo(
    StudentList studentList,
  ) async {
    return await showDialog(
            context: context,
            builder: (context) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: StudentProfileInfo(
                        studentList: studentList,
                      ),
                    ),
                  ),
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: divisions != null && sectionList.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: Colors.green,
              onPressed: () {
                addEditPopUp(SingleParent(
                    studentId: 0,
                    studentName: '',
                    fatherMobileNumber: 0,
                    fatherEmailAddress: '',
                    fatherName: '',
                    fatherId: 0,
                    motherMobileNumber: 0,
                    motherEmailAddress: '',
                    motherName: '',
                    motherId: 0,
                    guardianMobileNumber: 0,
                    guardianEmailAddress: '',
                    guardianName: '',
                    guardianId: 0,
                    admissionNumber: '',
                    rollNo: 0,
                    dob: '',
                    employeeNo: '',
                    gender: '',
                    photo: '',
                    temporaryStudent: '',
                    classSection: classSection));
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Students"),
              tooltip: 'Add Students',
            )
          : null,
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.2), BlendMode.dstATop),
                image: const AssetImage(Images.bgImage),
                repeat: ImageRepeat.repeatX)),
        child: isLoading
            ? Container()
            : Column(
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
                                    value: divisions![0].id,
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1)),
                                        labelStyle: TextStyle(
                                            color: Colors.grey.shade800),
                                        contentPadding: const EdgeInsets.only(
                                            left: 10, top: 4, bottom: 4)),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: divisions!
                                        .map<DropdownMenuItem<dynamic>>((item) {
                                      return DropdownMenuItem(
                                        value: item.id,
                                        child: Text(item.divisionName),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        divisionId =
                                            int.parse(newValue.toString());
                                        sectionList.clear();
                                      });
                                      getListOfSections(divisionId);
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      sectionList.isEmpty
                          ? Container()
                          : SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Row(
                                children: [
                                  Text(
                                    "classes and section",
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 35,
                                      child: DropdownButtonFormField<dynamic>(
                                        isExpanded: true,
                                        value: sectionList[0].id,
                                        decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1)),
                                            labelStyle: TextStyle(
                                                color: Colors.grey.shade800),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 10,
                                                    top: 4,
                                                    bottom: 4)),
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: sectionList
                                            .map<DropdownMenuItem<dynamic>>(
                                                (item) {
                                          return DropdownMenuItem(
                                            value: item.id,
                                            child: Text(item.classSection),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) async {
                                          setState(() {
                                            getAllStudentList(newValue);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: managementList == null
                        ? LoadingAnimator()
                        : managementList!.isEmpty
                            ? Center(
                                child: Text(
                                  "No Student here click add button to add the Students",
                                  style: GoogleFonts.lato(),
                                ),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 330,
                                        childAspectRatio: 4 / 1.5,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemCount: parentList.length,
                                itemBuilder: (context, index) {
                                  var parent = parentList[index];
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
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "Do you want to Delete this User"),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await StudentController()
                                                                        .deleteParent(
                                                                            id: parent.id
                                                                                .toString())
                                                                        .then(
                                                                            (value) {
                                                                      if (value !=
                                                                          null) {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Utility.displaySnackBar(
                                                                            context,
                                                                            "Delete Successfully");
                                                                      } else {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Utility.displaySnackBar(
                                                                            context,
                                                                            "Not Deleted");
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          "Yes")),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          "No"))
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10,
                                                                bottom: 10),
                                                        child: Center(
                                                          child: Text(
                                                              "Delete ${parent.firstName}"),
                                                        )),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      await StudentController()
                                                          .fetchSingleStaff(
                                                              id: parent.id)
                                                          .then((value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            SingleParent
                                                                    .student =
                                                                value;
                                                            dobController.text =
                                                                SingleParent
                                                                    .student
                                                                    .dob;

                                                            isEdit = true;
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                          addEditPopUp(
                                                              SingleParent
                                                                  .student);
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10,
                                                                bottom: 10),
                                                        child: Center(
                                                          child: Text(
                                                              "Edit ${parent.firstName}"),
                                                        )),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      await StudentController()
                                                          .fetchSingleStaff(
                                                              id: parent.id)
                                                          .then((value) {
                                                        if (value != null) {
                                                          studentProfileInfo(StudentList(
                                                              id: value
                                                                  .studentId,
                                                              userId: '',
                                                              firstName: value
                                                                  .studentName,
                                                              admissionNumber: value
                                                                  .admissionNumber,
                                                              dob: value.dob,
                                                              rollNumber:
                                                                  value.rollNo,
                                                              gender: 0,
                                                              profileImage:
                                                                  value.photo,
                                                              classConfig: value
                                                                  .classSection,
                                                              userStatus: 0,
                                                              createdBy: 0,
                                                              createdTime: DateTime
                                                                  .now(),
                                                              updatedTime:
                                                                  DateTime
                                                                      .now(),
                                                              guardianName: value
                                                                  .guardianName,
                                                              motherName: value
                                                                  .motherName,
                                                              fatherName: value
                                                                  .fatherName,
                                                              guardianMobile: value
                                                                  .guardianMobileNumber,
                                                              motherMobile: value
                                                                  .motherMobileNumber,
                                                              fatherMobile: value
                                                                  .fatherMobileNumber,
                                                              studentName: value
                                                                  .studentName,
                                                              studentListClass:
                                                                  'yes',
                                                              classTeacher: value
                                                                  .classSection
                                                                  .toString(),
                                                              studentProfileImage:
                                                                  value.photo,
                                                              fatherId: value
                                                                  .fatherId,
                                                              motherId: value.motherId,
                                                              guardianId: value.guardianId));
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10,
                                                                bottom: 10),
                                                        child: Center(
                                                          child: Text(
                                                              "View ${parent.firstName}"),
                                                        )),
                                                  ),
                                                ])));
                                          });
                                    },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              // parent. == ''
                                              //     ? Image.asset(
                                              //         Images.userProfile,
                                              //         width: 88.28,
                                              //         height: 81,
                                              //       )
                                              //     : ClipRRect(
                                              //         borderRadius:
                                              //             const BorderRadius
                                              //                     .all(
                                              //                 Radius.circular(
                                              //                     10)),
                                              //         child: Image.network(
                                              //           parent.profileImage,
                                              //           width: 88.28,
                                              //           height: 81,
                                              //           fit: BoxFit.cover,
                                              //           errorBuilder: (context,
                                              //               error, stackTrace) {
                                              //             return Image.asset(
                                              //               Images.userProfile,
                                              //               width: 88.28,
                                              //               height: 81,
                                              //             );
                                              //           },
                                              //         ),
                                              //       ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5),
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
                                                              textStyle: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        Text(
                                                          parent.firstName,
                                                          style: GoogleFonts
                                                              .lato(),
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
                                                              textStyle: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        Text(
                                                          parent.mobileNumber
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .lato(),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
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
                ],
              ),
      ),
    );
  }

  bool onError = false;
  bool isEdit = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController dobController = TextEditingController();
  final TextEditingController dojController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(
      BuildContext context, String field, SingleParent singleStudent) async {
    setState(() {
      selectedDate = DateTime.now();
    });
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        switch (field) {
          case 'dob':
            singleStudent.dob = DateFormat('dd-MM-yyyy').format(selectedDate);
            dobController.text = singleStudent.dob;
            break;
        }
      });
    }
  }

  bool isValidNumber = true;
  bool isGuardian = false;
  String index = '';

  bool isFatherDuplicate = false;
  bool isMotherDuplicate = false;
  bool isGuardianDuplicate = false;
  String gender = '';

  String errorText = 'admission id is required in this field ';
  void getValidAdmissionNumber(String number, SingleParent student) async {
    await getAdmissionNumber(number).then((value) {
      setState(() {
        isValidNumber = value['status'];
        student.admissionNumber = number;
        errorText = value['message'];
      });
    });
  }

  addEditPopUp(SingleParent student) {
    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Text(isEdit ? "Edit Student" : "Add Student"),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (isEdit) {
                        await StudentController()
                            .editParent(
                          student: student,
                          fatherPhoto: fatherPhoto,
                          motherPhoto: motherPhoto,
                          guardianPhoto: guardianPhoto,
                          studentPhoto: studentPhoto,
                        )
                            .then((value) {
                          if (value != null) {
                            Utility.displaySnackBar(
                                context,
                                isEdit
                                    ? "Student Updated Scuessfully"
                                    : 'Student added scuessfully');
                            Navigator.pop(context);
                          } else {
                            Utility.displaySnackBar(context,
                                'Something went wrong please try again');
                            Navigator.pop(context);
                          }
                        });
                      } else {
                        await StudentController()
                            .addParent(
                          student: student,
                          fatherPhoto: fatherPhoto,
                          motherPhoto: motherPhoto,
                          guardianPhoto: guardianPhoto,
                          studentPhoto: studentPhoto,
                        )
                            .then((value) {
                          if (value != null) {
                            Utility.displaySnackBar(
                                context,
                                isEdit
                                    ? "Student Updated Scuessfully"
                                    : 'Student added scuessfully');
                            Navigator.pop(context);
                          } else {
                            Utility.displaySnackBar(context,
                                'Something went wrong please try again');
                            Navigator.pop(context);
                          }
                        });
                      }
                    }
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
                          keyboardType: TextInputType.name,
                          name: "",
                          initialValue: student.studentName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Student name is required in this field';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15),
                            filled: true,
                            hintText: 'Student Name *',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              student.studentName = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: FormBuilderTextField(
                          name: "",
                          keyboardType: TextInputType.text,
                          initialValue: student.admissionNumber,
                          validator: (value) {
                            if (isValidNumber == false) {
                              return errorText;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Admission ID*',
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15),
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            getValidAdmissionNumber(value!, student);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: FormBuilderTextField(
                          name: "",
                          keyboardType: TextInputType.text,
                          initialValue: student.rollNo == 0
                              ? null
                              : student.rollNo.toString(),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15),
                            hintText: 'Roll Number (optional)',
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              student.rollNo = int.parse(value!);
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: 'Male',
                                    groupValue: index,
                                    onChanged: (newValue) {
                                      setState(() {
                                        index = newValue.toString();
                                        student.gender = 'Male';
                                      });
                                    }),
                                const Text('Boy')
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 'Female',
                                    groupValue: index,
                                    onChanged: (newValue) {
                                      setState(() {
                                        index = newValue.toString();
                                        student.gender = 'Female';
                                      });
                                    }),
                                const Text('Girl')
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _selectDate(context, 'dob', student);
                        },
                        child: FormTextWidget(
                            isValidate: true,
                            isEnabled: false,
                            keyboardType: TextInputType.name,
                            controller: dobController,
                            hintText: 'Date Of Birth',
                            onChanged: (value) {}),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: FormBuilderTextField(
                          keyboardType: TextInputType.name,
                          name: "",
                          validator: (value) {
                            if (student.fatherName == '' &&
                                student.motherName == '' &&
                                student.guardianName == '') {
                              return 'Father/mother/guardian name is required';
                            }
                            return null;
                          },
                          initialValue: student.fatherName,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15),
                            filled: true,
                            hintText: 'Father Name*',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              student.fatherName = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: FormBuilderTextField(
                          name: "",
                          keyboardType: TextInputType.phone,
                          initialValue: student.fatherMobileNumber == 0
                              ? null
                              : student.fatherMobileNumber.toString(),
                          validator: (value) {
                            if (student.fatherMobileNumber == 0 &&
                                student.motherMobileNumber == 0 &&
                                student.guardianMobileNumber == 0) {
                              return 'Father/mother/guardian name is required';
                            }
                            if (student.fatherMobileNumber.toString().length !=
                                10) {
                              return 'please enter valid mobile number';
                            }
                            if (isFatherDuplicate) {
                              return 'The Number is already exist its duplicate number ';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15),
                            hintText: 'Father Mobile Number*',
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) async {
                            setState(() {
                              student.fatherMobileNumber = int.parse(value!);
                            });
                            if (value!.length == 10) {
                              var unMappedNumber = await checkMobileNumber(
                                  student.fatherMobileNumber, 0, 1);
                              var data = true;
                              data = unMappedNumber['status'] == false &&
                                      unMappedNumber['tag'] != 'duplicate'
                                  ? false
                                  : true;
                              setState(() => isFatherDuplicate =
                                  unMappedNumber['tag'] == 'duplicate'
                                      ? true
                                      : false);
                              if (!data) {
                                alertWindow(student.fatherMobileNumber);
                              } else {
                                setState(() {
                                  isMapped = true;
                                });
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: FormBuilderTextField(
                          name: "",
                          keyboardType: TextInputType.emailAddress,
                          initialValue: student.fatherEmailAddress,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15),
                            hintText: 'Father email address',
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              student.fatherEmailAddress = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: FormBuilderTextField(
                          keyboardType: TextInputType.name,
                          initialValue: student.motherName,
                          name: "",
                          validator: (value) {
                            if (student.fatherName == '' &&
                                student.motherName == '' &&
                                student.guardianName == '') {
                              return 'Father/mother/guardian name is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15),
                            filled: true,
                            hintText: 'Mother Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              student.motherName = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: FormBuilderTextField(
                          name: "",
                          keyboardType: TextInputType.phone,
                          initialValue: student.motherMobileNumber == 0
                              ? null
                              : student.motherMobileNumber.toString(),
                          validator: (value) {
                            if (student.fatherMobileNumber == 0 &&
                                student.motherMobileNumber == 0 &&
                                student.guardianMobileNumber == 0) {
                              return 'Father/mother/guardian name is required';
                            }
                            if (student.motherName != '' &&
                                student.motherMobileNumber == 0) {
                              return 'please enter mother number';
                            }
                            if (student.motherMobileNumber != 0 &&
                                student.motherMobileNumber.toString().length !=
                                    10) {
                              return 'please enter valid mobile number';
                            }
                            if (isMotherDuplicate) {
                              return 'The Number is already exist its duplicate number ';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15),
                            hintText: 'Mother Mobile Number',
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) async {
                            setState(() {
                              student.motherMobileNumber = int.parse(value!);
                            });
                            if (value!.length == 10) {
                              var unMappedNumber = await checkMobileNumber(
                                  student.motherMobileNumber, 0, 2);
                              var data = true;
                              data = unMappedNumber['status'] == false &&
                                      unMappedNumber['tag'] != 'duplicate'
                                  ? false
                                  : true;
                              setState(() => isMotherDuplicate =
                                  unMappedNumber['tag'] == 'duplicate'
                                      ? true
                                      : false);
                              if (!data) {
                                alertWindow(student.motherMobileNumber);
                              } else {
                                setState(() {
                                  isMapped = true;
                                });
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: FormBuilderTextField(
                          name: "",
                          keyboardType: TextInputType.emailAddress,
                          initialValue: student.motherEmailAddress,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15),
                            hintText: 'Mother email Address',
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              student.motherEmailAddress = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Row(
                          children: [
                            Checkbox(
                                value: isGuardian,
                                activeColor: Colors.blueGrey.shade400,
                                onChanged: (value) {
                                  setState(() {
                                    isGuardian = value!;
                                  });
                                }),
                            const Text("Guardian",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      if (isGuardian == true)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: FormBuilderTextField(
                            keyboardType: TextInputType.name,
                            name: "",
                            validator: (value) {
                              if (student.fatherName == '' &&
                                  student.motherName == '' &&
                                  student.guardianName == '') {
                                return 'Father/mother/guardian name is required';
                              }
                              return null;
                            },
                            initialValue: student.guardianName,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 15),
                              filled: true,
                              hintText: 'Guardian Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onChanged: (value) {
                              setState(() {
                                student.guardianName = value!;
                              });
                            },
                          ),
                        ),
                      if (isGuardian == true)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: FormBuilderTextField(
                            name: "",
                            validator: (value) {
                              if (student.fatherMobileNumber == 0 &&
                                  student.motherMobileNumber == 0 &&
                                  student.guardianMobileNumber == 0) {
                                return 'Father/mother/guardian name is required';
                              }
                              if (student.guardianName != '' &&
                                  student.guardianMobileNumber == 0) {
                                return 'please enter mother number';
                              }
                              if (student.guardianMobileNumber != 0 &&
                                  student.guardianMobileNumber
                                          .toString()
                                          .length !=
                                      10) {
                                return 'please enter valid mobile number';
                              }
                              if (isGuardianDuplicate) {
                                return 'The Number is already exist its duplicate number ';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            initialValue: student.guardianMobileNumber == 0
                                ? null
                                : student.guardianMobileNumber.toString(),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 15),
                              hintText: 'Guardian Mobile Number',
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onChanged: (value) async {
                              setState(() {
                                student.guardianMobileNumber =
                                    int.parse(value!);
                              });
                              if (value!.length == 10) {
                                var unMappedNumber = await checkMobileNumber(
                                    student.guardianMobileNumber, 0, 9);
                                var data = true;
                                data = unMappedNumber['status'] == false &&
                                        unMappedNumber['tag'] != 'duplicate'
                                    ? false
                                    : true;
                                setState(() => isGuardianDuplicate =
                                    unMappedNumber['tag'] == 'duplicate'
                                        ? true
                                        : false);
                                if (!data) {
                                  alertWindow(student.guardianMobileNumber);
                                } else {
                                  setState(() {
                                    isMapped = true;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                      if (isGuardian == true)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: FormBuilderTextField(
                            name: "",
                            keyboardType: TextInputType.emailAddress,
                            initialValue: student.guardianEmailAddress,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 15),
                              hintText: 'Guardian email Address',
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onChanged: (value) {
                              setState(() {
                                student.guardianEmailAddress = value!;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  bool isMapped = true;
  void alertWindow(number) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Column(
            children: [
              const Text("Are you sure?"),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Mobile number already mapped with students do you want to continue.",
                style: GoogleFonts.lato(
                    fontSize: 13, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    isMapped = false;
                  });
                  Navigator.pop(context);
                },
                child: const Text("No")),
            TextButton(
                onPressed: () async {
                  setState(() {
                    isMapped = true;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Yes")),
          ],
        );
      },
    );
  }
}

class FormTextWidget extends StatelessWidget {
  const FormTextWidget(
      {super.key,
      required this.keyboardType,
      this.initialValue,
      required this.hintText,
      required this.onChanged,
      required this.isEnabled,
      required this.isValidate,
      this.controller});
  final TextInputType keyboardType;
  final dynamic initialValue;
  final String hintText;
  final Function(String?) onChanged;
  final bool isEnabled;
  final bool isValidate;

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: FormBuilderTextField(
        keyboardType: keyboardType,
        name: "name",
        initialValue: initialValue,
        validator: !isValidate
            ? null
            : (value) {
                if (value == null || value.isEmpty) {
                  return '$hintText is required in this field';
                }
                if (keyboardType == TextInputType.number &&
                    value.length != 10) {
                  return 'Enter valid mobile number';
                }
                return null;
              },
        enabled: isEnabled,
        maxLength: keyboardType == TextInputType.number ? 10 : null,
        controller: initialValue == null ? controller : null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 15),
          filled: true,
          hintText: hintText,
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          fillColor: Colors.grey.shade100,
          hintStyle: TextStyle(color: Colors.blueGrey.shade500),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

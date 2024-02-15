import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/categoryListAPI.dart';
import 'package:ui/api/profile_api.dart';
import 'package:ui/api/settings/index.dart';
import 'package:ui/api/excelAPiservice.dart';
import 'package:ui/api/settings/staff.dart';
import 'package:ui/config/images.dart';
import 'package:ui/controllers/image_controller.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/categorylistModel.dart';
import 'package:ui/model/fetch_staff_model.dart';
import 'package:ui/model/profile_model.dart';
import 'package:ui/model/search/staff_list_model.dart';
import 'package:ui/model/settings/index.dart';
import 'package:ui/widget/staff_info.dart';

class StaffWidget extends StatefulWidget {
  const StaffWidget({super.key});

  @override
  State<StaffWidget> createState() => _StaffWidgetState();
}

class _StaffWidgetState extends State<StaffWidget> {
  List<Division> divisions = [];
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
    setState(() {
      _dobController.text = 'Select Date of Birth';
      _dojController.text = 'Select Date of join';
    });
  }

  Future<void> fetchAllStaff() async {
    await StaffController().getAllStaffList().then((value) {
      if (value != null) {
        setState(() {
          staffList = value;
          isLoading = false;
        });
      }
    });
  }

  Future<void> fetchSingleStaff(String id) async {
    await StaffController().fetchSingleStaff(id: id).then((value) {
      if (mounted) {
        if (value != null) {
          setState(() {
            FetchStaffList.singleStaffData = value;
          });
        }
      }
    });
  }

  void initialize() async {
    await fetchAllStaff();
    await getDivisionList().then((value) {
      if (value != null) {
        setState(() {
          divisions = value;
          divisionId = divisions[0].id;
        });
      }
    });
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

  final TextEditingController _dobController = TextEditingController();
  DateTime selectedDateOfBirth = DateTime.now();

  final TextEditingController _dojController = TextEditingController();
  DateTime selectedDateOfJoin = DateTime.now();

  List<PlatformFile> selectedPicture = [];
  DateTime selectedDate = DateTime.now();

  bool onError = false;
  bool isEdit = false;
  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateOfBirth,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        selectedDateOfBirth = picked;
        _dobController.text = DateFormat.yMd().format(selectedDateOfBirth);
      });
    }
  }

  Future<void> _selectDateOfJoin(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateOfJoin,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDateOfJoin = picked;
        _dojController.text = DateFormat.yMd().format(selectedDateOfJoin);
      });
    }
  }

  void selectImages() async {
    var getImage = await ImageController.pickAndProcessImage();
    if (getImage.images.isNotEmpty) {
      setState(() {
        selectedPicture.clear();
        selectedPicture.addAll(getImage.images);
      });
    }
    if (getImage.errorText != '') _snackBar(getImage.errorText);
  }

  _snackBar(String message) {
    if (message != '') {
      final snackBar = SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        duration: const Duration(milliseconds: 1000),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _selectDate(
      BuildContext context, String field, FetchStaffList staff) async {
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
            staff.dob = DateFormat('dd-MM-yyyy').format(selectedDate);
            _dobController.text = staff.dob;
            break;
          case 'doj':
            staff.doj = DateFormat('dd-MM-yyyy').format(selectedDate);
            _dojController.text = staff.doj;
        }
      });
    }
  }

  Future<bool> staffProfileInfo(
    ProfileModel profile,
  ) async {
    return await showDialog(
            context: context,
            builder: (context) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: StaffProfileInfo(profileModel: profile),
                    ),
                  ),
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            selectedDateOfBirth = DateTime.now();
            isEdit = false;
          });
          addEditPopUp(FetchStaffList(
              id: 0,
              userId: '',
              firstName: '',
              mobileNumber: 0,
              profileImage: '',
              specializedIn: 0,
              userCategory: 0,
              emailId: '',
              classTeacher: 'no',
              employeeNumber: '',
              dob: '',
              doj: '',
              classConfig: 0,
              subjectTeacher: []));
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
            child: staffList == null
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
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Do you want to Delete this User"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () async {
                                                            await StaffController()
                                                                .deleteStaff(
                                                                    staffId: staff
                                                                        .id
                                                                        .toString())
                                                                .then((value) {
                                                              fetchAllStaff();
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
                                                          child: const Text(
                                                              "Yes")),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text("No"))
                                                    ],
                                                  );
                                                },
                                              );
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
                                            onTap: () async {
                                              await fetchSingleStaff(
                                                  staff.id.toString());
                                              setState(() {
                                                _dobController.text =
                                                    FetchStaffList
                                                        .singleStaffData.dob;
                                                _dojController.text =
                                                    FetchStaffList
                                                        .singleStaffData.doj;
                                                isEdit = true;
                                                Navigator.pop(context);
                                              });

                                              addEditPopUp(FetchStaffList
                                                  .singleStaffData);
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
                                          InkWell(
                                            onTap: () async {
                                              await getProfile(
                                                      id: staff.id.toString(),
                                                      role: "2",
                                                      studentId: '')
                                                  .then((value) {
                                                if (value != null) {
                                                  staffProfileInfo(value);
                                                }
                                              });
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Center(
                                                  child: Text(
                                                      "View ${staff.firstName}"),
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

  addEditPopUp(FetchStaffList singleStaffData) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(isEdit ? "Edit Staff" : "Add Staff"),
            actions: [
              TextButton(
                  onPressed: () async {
                    isEdit
                        ? await StaffController()
                            .editStaff(
                                staffList: singleStaffData,
                                profileImage: selectedPicture,
                                divId: divisionId)
                            .then((value) {
                            if (value != null) {
                              fetchAllStaff();
                              Utility.displaySnackBar(context, value);
                            } else {
                              Utility.displaySnackBar(context, "error");
                            }
                            Navigator.pop(context);
                          })
                        : await StaffController()
                            .addStaff(
                                staffList: singleStaffData,
                                profileImage: selectedPicture,
                                divId: divisionId)
                            .then((value) {
                            fetchAllStaff();
                            if (value != null) {
                              Utility.displaySnackBar(
                                  context, value["message"]);
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
                child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                runSpacing: 15,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Stack(
                      children: [
                        Center(
                          child: selectedPicture.isEmpty
                              ? Container(
                                  height: 130,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          onError: (exception, stackTrace) {
                                            setState(() {
                                              singleStaffData.profileImage =
                                                  "https://cdn.iconscout.com/icon/premium/png-256-thumb/add-user-2639844-2214705.png?f=webp";
                                            });
                                          },
                                          image: NetworkImage(
                                              singleStaffData.profileImage),
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                          color: Colors.blueGrey.shade600,
                                          width: 2)),
                                )
                              : Container(
                                  height: 130,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: MemoryImage(
                                              selectedPicture[0].bytes!),
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                          color: Colors.blueGrey.shade600,
                                          width: 2)),
                                ),
                        ),
                        Positioned(
                            right: MediaQuery.of(context).size.width * 0.06,
                            bottom: 0,
                            child: RawMaterialButton(
                              onPressed: selectImages,
                              elevation: 2.0,
                              fillColor: Colors.blueGrey.shade600,
                              shape: const CircleBorder(),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 25.0,
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FormBuilderTextField(
                      name: 'Staff name',
                      initialValue: singleStaffData.firstName,
                      onChanged: (value) {
                        setState(() {
                          singleStaffData.firstName = value!;
                        });
                      },
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: 'Staff name ',
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
                      name: 'Staff Number',
                      onChanged: (value) {
                        setState(() {
                          singleStaffData.mobileNumber = int.parse(value!);
                        });
                      },
                      initialValue: singleStaffData.mobileNumber == 0
                          ? null
                          : singleStaffData.mobileNumber.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: 'staff Number ',
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
                      value: singleStaffData.userCategory == 0
                          ? null
                          : singleStaffData.userCategory,
                      decoration: InputDecoration(
                          hintText: 'teaching category ',
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
                          singleStaffData.userCategory = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: DropdownButtonFormField<dynamic>(
                      isExpanded: true,
                      value: singleStaffData.specializedIn == 0
                          ? null
                          : singleStaffData.specializedIn,
                      decoration: InputDecoration(
                          hintText: 'subject name ',
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
                          singleStaffData.specializedIn = newValue;
                        });
                      },
                    ),
                  ),
                  if (singleStaffData.userCategory != 4) ...[
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
                            value: singleStaffData.classTeacher != "no",
                            onChanged: (value) {
                              setState(() {
                                singleStaffData.classTeacher = "yes";
                              });
                            },
                          ),
                          const Text("Yes"),
                          Checkbox(
                            activeColor: Colors.transparent,
                            checkColor: const Color.fromARGB(255, 68, 138, 255),
                            value: singleStaffData.classTeacher == "no",
                            onChanged: (value) {
                              setState(() {
                                singleStaffData.classTeacher = "no";
                              });
                            },
                          ),
                          const Text("No"),
                        ],
                      ),
                    ),
                    // Visibility(
                    //   visible: singleStaffData.classTeacher == "yes",
                    //   child: SizedBox(
                    //     width: MediaQuery.of(context).size.width * 0.3,
                    //     child: DropdownButtonFormField<dynamic>(
                    //       isExpanded: true,
                    //       value: singleStaffData.classConfig == 0
                    //           ? null
                    //           : singleStaffData.classConfig,
                    //       decoration: InputDecoration(
                    //           hintText: 'class name ',
                    //           border: const OutlineInputBorder(
                    //               borderSide: BorderSide(color: Colors.black)),
                    //           focusedBorder: const OutlineInputBorder(
                    //               borderSide: BorderSide(
                    //                   color: Colors.black, width: 1)),
                    //           labelStyle:
                    //               TextStyle(color: Colors.grey.shade800),
                    //           contentPadding: const EdgeInsets.only(
                    //               left: 10, top: 4, bottom: 4)),
                    //       icon: const Icon(Icons.keyboard_arrow_down),
                    //       items: sectionList!
                    //           .map<DropdownMenuItem<dynamic>>((item) {
                    //         return DropdownMenuItem(
                    //           value: item.id,
                    //           child: Text(item.classSection),
                    //         );
                    //       }).toList(),
                    //       onChanged: (newValue) async {
                    //         setState(() {
                    //           singleStaffData.classConfig = newValue;
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Row(
                        children: [
                          const Text(
                            "Subject Teacher: ",
                            style: TextStyle(fontSize: 16),
                          ),
                          Checkbox(
                            activeColor: Colors.transparent,
                            checkColor: const Color.fromARGB(255, 68, 138, 255),
                            value: singleStaffData.subjectTeacher.isNotEmpty,
                            onChanged: (value) {
                              setState(() {
                                singleStaffData.subjectTeacher.add(
                                    SubjectTeacher(classConfig: 0, subject: 0));
                              });
                            },
                          ),
                          const Text("Yes"),
                          Checkbox(
                            activeColor: Colors.transparent,
                            checkColor: const Color.fromARGB(255, 68, 138, 255),
                            value: singleStaffData.subjectTeacher.isEmpty,
                            onChanged: (value) {
                              setState(() {
                                singleStaffData.subjectTeacher.clear();
                              });
                            },
                          ),
                          const Text("No"),
                        ],
                      ),
                    ),
                    for (int i = 0;
                        i < singleStaffData.subjectTeacher.length;
                        i++)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.62,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<dynamic>(
                                isExpanded: true,
                                value: singleStaffData
                                            .subjectTeacher[i].classConfig ==
                                        0
                                    ? null
                                    : singleStaffData
                                        .subjectTeacher[i].classConfig,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    hintText: 'class',
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1)),
                                    labelStyle:
                                        TextStyle(color: Colors.grey.shade800),
                                    contentPadding: const EdgeInsets.only(
                                        left: 10, top: 4, bottom: 4)),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: sectionList!
                                    .map<DropdownMenuItem<dynamic>>((item) {
                                  return DropdownMenuItem(
                                    value: item.id,
                                    child: Text(item.classSection),
                                  );
                                }).toList(),
                                onChanged: (newValue) async {
                                  setState(() {
                                    singleStaffData.subjectTeacher[i]
                                        .classConfig = newValue;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: DropdownButtonFormField<dynamic>(
                                isExpanded: true,
                                value: singleStaffData
                                            .subjectTeacher[i].subject ==
                                        0
                                    ? null
                                    : singleStaffData.subjectTeacher[i].subject,
                                decoration: InputDecoration(
                                    hintText: 'subject',
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
                                items: subjectList
                                    .map<DropdownMenuItem<dynamic>>((item) {
                                  return DropdownMenuItem(
                                    value: item.id,
                                    child: Text(item.subjectName),
                                  );
                                }).toList(),
                                onChanged: (newValue) async {
                                  setState(() {
                                    singleStaffData.subjectTeacher[i].subject =
                                        newValue;
                                  });
                                },
                              ),
                            ),
                            if (i != 0)
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      singleStaffData.subjectTeacher
                                          .removeAt(i);
                                    });
                                  },
                                  icon: const Icon(Icons.remove)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    singleStaffData.subjectTeacher.add(
                                        SubjectTeacher(
                                            classConfig: 0, subject: 0));
                                  });
                                },
                                icon: const Icon(Icons.add))
                          ],
                        ),
                      ),
                  ],
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FormBuilderTextField(
                      name: 'Staff email',
                      onChanged: (value) {
                        setState(() {
                          singleStaffData.emailId = value!;
                        });
                      },
                      initialValue: singleStaffData.emailId,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: 'staff email ',
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
                      name: 'Employee Number',
                      onChanged: (value) {
                        setState(() {
                          singleStaffData.employeeNumber = value!;
                        });
                      },
                      initialValue: singleStaffData.employeeNumber,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: 'employee number ',
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          labelStyle: TextStyle(color: Colors.grey.shade800),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 4, bottom: 4)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate(context, 'dob', singleStaffData);
                    },
                    child: FormTextWidget(
                        isValidate: true,
                        isEnabled: false,
                        keyboardType: TextInputType.name,
                        controller: _dobController,
                        hintText: 'Date Of Birth',
                        onChanged: (value) {}),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate(context, 'doj', singleStaffData);
                    },
                    child: FormTextWidget(
                        isValidate: false,
                        isEnabled: false,
                        keyboardType: TextInputType.name,
                        controller: _dojController,
                        hintText: 'Date Of Join',
                        onChanged: (value) {}),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )),
          );
        });
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

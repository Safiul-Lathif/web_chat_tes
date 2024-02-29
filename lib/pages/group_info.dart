// ignore_for_file: iterable_contains_unrelated_type, must_be_immutable
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/api/group_info_api.dart';
import 'package:ui/api/inactive_user_api.dart';
import 'package:ui/api/search/check_mobile_number.dart';
import 'package:ui/api/settings/get_admissin_number.dart';
import 'package:ui/api/settings/student.dart';
import 'package:ui/model/group_info_model.dart';
import 'package:ui/model/image_list_model.dart';
import 'package:ui/model/settings/student.dart';
import 'package:ui/utils/utility.dart';
import 'package:ui/widget/profile_info.dart';

import '../model/search/management_list_model.dart';
import '../model/view_section_model.dart';
import '../widget/settings/management.dart';

class GroupInfoWidget extends StatefulWidget {
  final String schoolName;
  String id;
  List<ImageList>? imageList;
  bool isLoading;
  final Function callback;
  bool isClass;

  GroupInfoWidget(
      {super.key,
      required this.schoolName,
      required this.id,
      required this.imageList,
      required this.isLoading,
      required this.isClass,
      required this.callback});

  @override
  State<GroupInfoWidget> createState() => _GroupInfoWidgetState();
}

class _GroupInfoWidgetState extends State<GroupInfoWidget> {
  Iterable<ParticipantsList>? groupInfo;

  int page = 1;

  String stats = "";
  String url = 'data';

  final ScrollController _scrollController = ScrollController();
  List<ParticipantsList> listOfParticipants = [];

  int totalItem = 0;
  bool isSearch = false;

  String className = '';
  List<SectionDetail> sectionList = [];
  List<ManagementList>? managementList = [];
  List<PlatformFile> fatherPhoto = [];
  List<PlatformFile> motherPhoto = [];
  List<PlatformFile> guardianPhoto = [];
  List<PlatformFile> studentPhoto = [];

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

  bool isLoading = false;
  Future<bool> activeInactiveUser(
    String number,
    String id,
    String name,
    String role,
  ) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove User'),
            content: Text('Do you want to Remove $name User?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () async {},
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    getGroupList(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (url != '') {
          if (page != 0) {
            _loadNextPage();
          }
        }
      }
    });
  }

  TextEditingController controller = TextEditingController();

  void _loadNextPage() {
    setState(() {
      page++;
      isLoading = true;
    });
    getGroupList(page);
  }

  void getGroupList(int pageNumber) async {
    await getGroupInfo(widget.id, pageNumber).then((value) {
      if (value != null) {
        setState(() {
          listOfParticipants.addAll(value.data);
          groupInfo = listOfParticipants;
          totalItem = value.total;
          url = value.nextPageUrl;
        });
      }
      for (var i = 0; i < groupInfo!.length; i++) {
        stats = groupInfo!.elementAt(i).appStatus;
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  String searchText = '';

  void searchMember() {
    final listOfData = groupInfo!.where((element) {
      final name = element.name.toLowerCase();
      final text = searchText.toLowerCase();
      return name.contains(text);
    });
    setState(() => groupInfo = listOfData);
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1300;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                setState(() {
                  widget.callback(context, false);
                });
              },
              icon: const Icon(
                Icons.cancel_rounded,
                color: Colors.black,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 17, right: 12),
          child: groupInfo == null
              ? Lottie.network(
                  'https://assets8.lottiefiles.com/packages/lf20_fzmasdx7.json',
                  height: 50.0,
                  repeat: true,
                  reverse: true,
                  animate: true,
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$totalItem Members",
                          style: TextStyle(
                              color: Colors.green.shade500,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await inactiveUser().then((value) {
                                if (value != null) {
                                  setState(() {
                                    Utility.displaySnackBar(
                                        context, value["message"]);
                                  });
                                }
                              });
                            },
                            child: const Text("Resend Credentials")),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              border: Border.all(color: Colors.black)),
                          child: TextField(
                            onTap: () {
                              setState(() {
                                isSearch = !isSearch;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                                searchMember();
                              });
                            },
                            controller: controller,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                  top: 12,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: !isSearch
                                      ? Colors.black38
                                      : Colors.grey.shade600,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: !isSearch
                                        ? Colors.black38
                                        : Colors.grey.shade600,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      controller.clear();
                                      searchText = '';
                                      isSearch = !isSearch;
                                    });
                                  },
                                ),
                                hintText: 'Search...',
                                hintStyle: TextStyle(
                                  color: !isSearch
                                      ? Colors.black38
                                      : Colors.grey.shade600,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        if (widget.isClass)
                          IconButton(
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
                                    classSection: int.parse(widget.id)));
                              },
                              icon: const Icon(Icons.person_add_alt))
                      ],
                    ),
                    SizedBox(
                      height: 320,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: groupInfo!.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Tooltip(
                                message:
                                    groupInfo!.elementAt(index).appStatus !=
                                            "Not Installed"
                                        ? 'Installed User'
                                        : 'Not Installed User',
                                child: ListTile(
                                  leading: Stack(
                                    children: [
                                      const CircleAvatar(
                                        radius: 18.0,
                                        backgroundImage: NetworkImage(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpCKq1XnPYYDaUIlwlsvmLPZ-9-rdK28RToA&usqp=CAU'),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      groupInfo!.elementAt(index).appStatus !=
                                              "Not Installed"
                                          ? const Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Icon(
                                                Icons.circle,
                                                color: Colors.green,
                                                size: 12,
                                              ))
                                          : const Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Icon(
                                                Icons.circle,
                                                color: Colors.red,
                                                size: 12,
                                              )),
                                    ],
                                  ),
                                  title: Text(groupInfo!.elementAt(index).name),
                                  subtitle: Text(
                                      groupInfo!.elementAt(index).designation),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => Material(
                                        type: MaterialType.transparency,
                                        child: Center(
                                            child: SizedBox(
                                                width: MediaQuery.of(context).size.width *
                                                    0.5,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                                child: ProfileInfo(
                                                    context: context,
                                                    lastSeen: groupInfo!.elementAt(index).lastLogin != ''
                                                        ? "Last Login:${Utility.convertDateFormat(groupInfo!.elementAt(index).lastLogin, "dd-MMM-yyyy")} \t${Utility.convertTimeFormat(groupInfo!.elementAt(index).lastLogin.split(' ').last)}"
                                                        : "",
                                                    id: groupInfo!
                                                        .elementAt(index)
                                                        .id,
                                                    role: groupInfo!
                                                        .elementAt(index)
                                                        .userRole
                                                        .toString(),
                                                    image: groupInfo!
                                                        .elementAt(index)
                                                        .profile,
                                                    name: groupInfo!
                                                        .elementAt(index)
                                                        .name,
                                                    mobileNumber: groupInfo!
                                                        .elementAt(index)
                                                        .mobileNumber
                                                        .toString()))),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.grey.shade300,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 2,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Colors.transparent,
                        Colors.grey,
                        Colors.transparent
                      ])),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;

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

  addEditPopUp(SingleParent student) {
    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: const Text("Add Student"),
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

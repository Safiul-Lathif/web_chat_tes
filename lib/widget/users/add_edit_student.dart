// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/api/classgroupApi.dart';
import 'package:ui/api/group/add_student_group.dart';
import 'package:ui/api/settings/get_admissin_number.dart';
import 'package:ui/config/const.dart';
import 'package:ui/controllers/image_controller.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/search/student_list_model.dart';
import 'package:ui/utils/utility.dart';

import '../../model/classModel.dart';

class StudentEditPage extends StatefulWidget {
  const StudentEditPage({super.key, required this.studentList});
  final StudentList studentList;

  @override
  State<StudentEditPage> createState() => _StudentEditPageState();
}

class _StudentEditPageState extends State<StudentEditPage> {
  bool isGuardian = false;
  String index = '';

  String studentName = '';
  String guardianEmailId = '';
  String admissionNumber = '';
  String rollNumber = '';
  String classConfig = '';
  String grpId = '';

  List<PlatformFile> studentPicture = [];

  DateTime dob = DateTime.now();
  bool isLoading = false;

  void selectImages() async {
    HapticFeedback.vibrate();
    var getImage = await ImageController.pickAndProcessImage();
    if (getImage.images.isNotEmpty) {
      setState(() {
        studentPicture.clear();
        studentPicture.addAll(getImage.images);
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

  DateTime selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dob = picked;
        _dateController.text =
            Utility.convertDateFormat(selectedDate.toString(), "yyyy-MM-dd");
      });
    }
  }

  ImageProvider<Object>? image;

  @override
  void initState() {
    super.initState();
    getAllTheGroup();
    setState(() {
      _dateController.text = widget.studentList.dob;
      if (widget.studentList.dob == '') {
        _dateController.text = 'Select date of birth*';
      }
      studentName = widget.studentList.firstName;
      admissionNumber = widget.studentList.admissionNumber;
      rollNumber = widget.studentList.rollNumber.toString();
      if (widget.studentList.rollNumber.toString() == '0') {
        rollNumber = '';
      }
      classConfig = widget.studentList.classConfig.toString();
      image = NetworkImage(widget.studentList.studentProfileImage);
    });
  }

  ClassGroup? classGroup;
  void getAllTheGroup() async {
    await getClassGroup().then((value) {
      if (mounted) {
        setState(() {
          classGroup = value;
        });
      }
    });
  }

  BoxFit fit = BoxFit.fill;

  final _formKey = GlobalKey<FormState>();

  bool isValidNumber = true;
  String errorText = 'admission id is required in this field ';
  void getValidAdmissionNumber(String number) async {
    await getAdmissionNumber(number).then((value) {
      setState(() {
        isValidNumber = value['status'];
        admissionNumber = number;
        errorText = value['message'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: classGroup == null
          ? LoadingAnimator()
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    runSpacing: 15,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Stack(
                          children: [
                            Center(
                              child: studentPicture.isEmpty
                                  ? Container(
                                      height: 130,
                                      width: 130,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              onError: (exception, stackTrace) {
                                                setState(() {
                                                  image = const NetworkImage(
                                                      "https://cdn-icons-png.flaticon.com/512/747/747968.png");
                                                  fit = BoxFit.fitWidth;
                                                });
                                              },
                                              image: image!,
                                              fit: fit),
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
                                              image: FileImage(File(
                                                  studentPicture[0].path!)),
                                              fit: BoxFit.fill),
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
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: FormBuilderTextField(
                          keyboardType: TextInputType.name,
                          name: "",
                          initialValue: studentName,
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
                              studentName = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: FormBuilderTextField(
                          name: "",
                          keyboardType: TextInputType.text,
                          initialValue: admissionNumber,
                          validator: (value) {
                            if (isValidNumber == false) {
                              return errorText;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15),
                            hintText: 'Admission ID*',
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            getValidAdmissionNumber(value!);
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: FormBuilderTextField(
                          name: "",
                          initialValue: rollNumber,
                          keyboardType: TextInputType.text,
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
                              rollNumber = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: FormBuilderDropdown(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 15),
                              hintText: widget.studentList.studentListClass,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              filled: true),
                          name: 'Classes',
                          items: classGroup!.classGroup
                              .map<DropdownMenuItem<dynamic>>((item) {
                            return DropdownMenuItem(
                              value: item.groupId,
                              child: Text(item.groupName),
                              onTap: () {
                                setState(() {
                                  classConfig = item.classConfig.toString();
                                  grpId = item.groupId.toString();
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: FormBuilderTextField(
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            textAlign: TextAlign.center,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _dateController,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(top: 5, bottom: 5, left: 15),
                              hintText: 'Select Your Date of Birth*',
                              filled: true,
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            name: 'Date',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: double.infinity,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: ElevatedButton(
                            style: buttonStyle,
                            onPressed: onPressed,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isLoading ? "Submitting" : "Submit",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(width: 5),
                                if (isLoading)
                                  const SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 3, color: Colors.white))
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void onPressed() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_dateController.text == 'Select date of birth*') {
        Utility.displaySnackBar(context, 'Date of birth is must ');
      } else {
        await editStudentProfile(
                student: widget.studentList,
                studentId: widget.studentList.id.toString(),
                studentName: studentName,
                studentPicture: studentPicture,
                admissionNumber: admissionNumber,
                rollNumber: rollNumber,
                groupId: grpId,
                classConfig: classConfig,
                dob: _dateController.text)
            .then((value) {
          if (value != null) {
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context, true);
            Utility.displaySnackBar(context, 'Student Updated Successfully');
          } else {
            setState(() {
              isLoading = false;
            });
            Utility.displaySnackBar(context, 'Error in updating the student');
          }
        });
      }
    }
  }
}

// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ui/api/addEditUser/add_edit_staff_api.dart';
import 'package:ui/api/categoryListAPI.dart';
import 'package:ui/api/search/check_employee_number.dart';
import 'package:ui/controllers/image_controller.dart';
import 'package:ui/model/categorylistModel.dart';
import 'package:ui/utils/utility.dart';

import '../../model/search/staff_list_model.dart';

class AddEditStaffPage extends StatefulWidget {
  AddEditStaffPage({super.key, required this.userModel, required this.isEdit});
  StaffSearchList userModel;
  final bool isEdit;

  @override
  State<AddEditStaffPage> createState() => _AddEditStaffPageState();
}

class _AddEditStaffPageState extends State<AddEditStaffPage> {
  List<Category> teachingType = [];
  StaffSearchList? userModel;

  bool notDuplicate = true;

  final _formKey = GlobalKey<FormState>();
  BoxFit fit = BoxFit.fill;
  List<PlatformFile> images = [];
  DateTime selectedDate = DateTime.now();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController dojController = TextEditingController();
  List<XFile> selectedPicture = [];

  void selectImages() async {
    HapticFeedback.vibrate();
    var getImage = await ImageController.pickAndProcessImage();
    if (getImage.images.isNotEmpty) {
      setState(() {
        selectedPicture.clear();
        selectedPicture.addAll(getImage.images);
        widget.userModel.profileImage = getImage.images.first.path;
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

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    setState(() {
      userModel = widget.userModel;
      if (!widget.isEdit) {
        widget.userModel = StaffSearchList(
            id: 0,
            firstName: '',
            mobileNumber: 0,
            userStatus: 0,
            profileImage: '',
            designation: 0,
            userCategory: '',
            userId: '',
            dob: '',
            doj: '',
            employeeNo: '',
            emailId: '');
      }
      widget.userModel.profileImage == ''
          ? "https://cdn.iconscout.com/icon/premium/png-256-thumb/add-user-2639844-2214705.png?f=webp"
          : widget.userModel.profileImage;
      dobController.text = widget.userModel.dob;
      dojController.text = widget.userModel.doj;
    });
    await getTeacherCategoryList().then((value) {
      if (value != null) {
        setState(() {
          teachingType = value;
        });
      }
    });
  }

  Future<void> _selectDate(
    BuildContext context,
    String field,
  ) async {
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
            widget.userModel.dob = DateFormat.yMd().format(selectedDate);
            dobController.text = widget.userModel.dob;
            break;
          case 'doj':
            widget.userModel.doj = DateFormat.yMd().format(selectedDate);
            dojController.text = widget.userModel.doj;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade400,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: Text(widget.isEdit ? "Edit Staff" : "Add New Staff"),
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Navigator.pop(context, false),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.blue.withOpacity(0.4), BlendMode.dstATop),
                      image: const AssetImage('assets/images/bg_image_tes.jpg'),
                      repeat: ImageRepeat.repeatY)),
              child: Form(
                  key: _formKey,
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 30, left: 15, right: 15),
                    child: Column(children: [
                      Stack(
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
                                                widget.userModel.profileImage =
                                                    "https://cdn.iconscout.com/icon/premium/png-256-thumb/add-user-2639844-2214705.png?f=webp";
                                                fit = BoxFit.cover;
                                              });
                                            },
                                            image: NetworkImage(
                                                widget.userModel.profileImage),
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
                                            image: FileImage(
                                                File(selectedPicture[0].path)),
                                            fit: BoxFit.cover),
                                        border: Border.all(
                                            color: Colors.blueGrey.shade600,
                                            width: 2)),
                                  ),
                          ),
                          Positioned(
                              bottom: MediaQuery.of(context).size.height * 0.02,
                              right: MediaQuery.of(context).size.width * 0.2,
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
                      const SizedBox(
                        height: 15,
                      ),
                      FormTextWidget(
                          isValidate: true,
                          keyboardType: TextInputType.name,
                          isEnabled: true,
                          initialValue: widget.userModel.firstName,
                          hintText: 'Staff Name*',
                          onChanged: (value) {
                            setState(() {
                              widget.userModel.firstName = value!;
                            });
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        width: MediaQuery.of(context).size.width,
                        child: FormBuilderDropdown(
                          initialValue: widget.userModel.designation == 0
                              ? null
                              : widget.userModel.designation,
                          validator: (dynamic value) {
                            if (value == null) {
                              return 'Please select Category*';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15),
                            filled: true,
                            hintText: 'Select User Category',
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            fillColor: Colors.grey.shade100,
                            hintStyle:
                                TextStyle(color: Colors.blueGrey.shade500),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          name: 'userCategory',
                          items: teachingType
                              .map<DropdownMenuItem<dynamic>>((item) {
                            return DropdownMenuItem(
                              value: item.id,
                              child: Text(item.categoryName),
                              onTap: () {
                                setState(() {
                                  widget.userModel.designation = item.id;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FormTextWidget(
                          isValidate: true,
                          isEnabled: true,
                          keyboardType: TextInputType.number,
                          initialValue: widget.userModel.mobileNumber == 0
                              ? ''
                              : widget.userModel.mobileNumber.toString(),
                          hintText: 'Mobile Number*',
                          onChanged: (value) {
                            setState(() {
                              widget.userModel.mobileNumber = int.parse(value!);
                            });
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      FormTextWidget(
                          isValidate: false,
                          isEnabled: true,
                          keyboardType: TextInputType.emailAddress,
                          initialValue: widget.userModel.emailId,
                          hintText: 'Email Address',
                          onChanged: (value) {
                            setState(() {
                              widget.userModel.emailId = value!;
                            });
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      FormBuilderTextField(
                          keyboardType: TextInputType.text,
                          name: "name",
                          initialValue: widget.userModel.employeeNo,
                          validator: (value) {
                            if (!notDuplicate) {
                              return 'The number is already taken';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 15),
                            filled: true,
                            hintText: 'Employee Number',
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            fillColor: Colors.grey.shade100,
                            hintStyle:
                                TextStyle(color: Colors.blueGrey.shade500),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (value) async {
                            setState(() {
                              widget.userModel.employeeNo = value!;
                            });
                            var result = await checkEmployeeNumber(
                                value!, widget.userModel.id, 2);
                            if (result != null) {
                              setState(() {
                                notDuplicate = result['status'] ?? true;
                              });
                            }
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          _selectDate(context, 'dob');
                        },
                        child: FormTextWidget(
                            isValidate: true,
                            isEnabled: false,
                            keyboardType: TextInputType.name,
                            controller: dobController,
                            hintText: 'Date Of Birth*',
                            onChanged: (value) {}),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          _selectDate(context, 'doj');
                        },
                        child: FormTextWidget(
                            isValidate: false,
                            isEnabled: false,
                            keyboardType: TextInputType.name,
                            controller: dojController,
                            hintText: 'Date Of Join',
                            onChanged: (value) {}),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Colors.black12),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.blueGrey.shade400)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await addEditStaff(widget.userModel,
                                      selectedPicture, widget.isEdit)
                                  .then((value) {
                                if (value != null) {
                                  Utility.displaySnackBar(
                                      context,
                                      widget.isEdit
                                          ? "Staff Updated Scuessfully"
                                          : 'Staff added scuessfully');
                                  Navigator.pop(context, true);
                                } else {
                                  Utility.displaySnackBar(context,
                                      'Something went wrong please try again');
                                  Navigator.pop(context, true);
                                }
                              });
                            }
                          },
                          child:
                              Text(widget.isEdit ? "Edit User" : "Save User"))
                    ]),
                  ))),
        ));
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
    return FormBuilderTextField(
      keyboardType: keyboardType,
      name: "name",
      initialValue: initialValue,
      validator: !isValidate
          ? null
          : (value) {
              if (value == null || value.isEmpty) {
                return '$hintText is required in this field';
              }
              if (keyboardType == TextInputType.number && value.length != 10) {
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
    );
  }
}

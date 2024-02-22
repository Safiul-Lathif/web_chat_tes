// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/api/addEditUser/add_edit_parents_api.dart';
import 'package:ui/api/profile_api.dart';
import 'package:ui/api/search/check_mobile_number.dart';
import 'package:ui/controllers/image_controller.dart';
import 'package:ui/model/search_parent_model.dart';
import 'package:ui/utils/utility.dart';

class AddEditParentPage extends StatefulWidget {
  AddEditParentPage(
      {super.key,
      required this.userModel,
      required this.isEdit,
      required this.callback});
  late ParentSearchList userModel;
  final bool isEdit;
  final Function callback;

  @override
  State<AddEditParentPage> createState() => _AddEditParentPageState();
}

class _AddEditParentPageState extends State<AddEditParentPage> {
  ParentSearchList? userModel;
  final _formKey = GlobalKey<FormState>();
  bool isDuplicate = false;
  BoxFit fit = BoxFit.fill;
  List<PlatformFile> images = [];
  List<ParentCategory> parentType = [
    ParentCategory(category: 'Father', id: 1),
    ParentCategory(category: 'Mother', id: 2),
    ParentCategory(category: 'Guardian', id: 9),
  ];
  DateTime selectedDate = DateTime.now();
  final TextEditingController dobController = TextEditingController();
  List<PlatformFile> selectedPicture = [];
  bool isMapped = true;

  void selectImages() async {
    HapticFeedback.vibrate();
    var getImage = await ImageController.pickAndProcessImage();
    if (getImage.images.isNotEmpty) {
      setState(() {
        selectedPicture.clear();
        selectedPicture.addAll(getImage.images);
        widget.userModel.parentProfileImage = getImage.images.first.path!;
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

  void initialize() {
    setState(() {
      userModel = widget.userModel;
      if (!widget.isEdit) widget.userModel = ParentSearchList.clearData;
      widget.userModel.parentProfileImage == ''
          ? "https://cdn.iconscout.com/icon/premium/png-256-thumb/add-user-2639844-2214705.png?f=webp"
          : widget.userModel.parentProfileImage;
      dobController.text = widget.userModel.dob;
    });
    getProfile(id: widget.userModel.id.toString(), role: "", studentId: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                child: Form(
                    key: _formKey,
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
                                                  onError:
                                                      (exception, stackTrace) {
                                                    setState(() {
                                                      widget.userModel
                                                              .parentProfileImage =
                                                          "https://cdn.iconscout.com/icon/premium/png-256-thumb/add-user-2639844-2214705.png?f=webp";
                                                      fit = BoxFit.cover;
                                                    });
                                                  },
                                                  image: NetworkImage(widget
                                                      .userModel
                                                      .parentProfileImage),
                                                  fit: fit),
                                              border: Border.all(
                                                  color:
                                                      Colors.blueGrey.shade600,
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
                                                      selectedPicture[0]
                                                          .bytes!),
                                                  fit: BoxFit.cover),
                                              border: Border.all(
                                                  color:
                                                      Colors.blueGrey.shade600,
                                                  width: 2)),
                                        ),
                                ),
                                Positioned(
                                    right: MediaQuery.of(context).size.width *
                                        0.06,
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
                            child: FormTextWidget(
                                isValidate: true,
                                keyboardType: TextInputType.name,
                                isEnabled: true,
                                initialValue: widget.userModel.firstName,
                                hintText: 'Parent Name',
                                onChanged: (value) {
                                  setState(() {
                                    widget.userModel.firstName = value!;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: FormBuilderDropdown(
                                initialValue: widget.userModel.userCategory == 0
                                    ? null
                                    : widget.userModel.userCategory,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 15),
                                  filled: true,
                                  hintText: 'Select User Category',
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black45),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black45),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  fillColor: Colors.grey.shade100,
                                  hintStyle: TextStyle(
                                      color: Colors.blueGrey.shade500),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                name: 'userCategory',
                                items: parentType
                                    .map<DropdownMenuItem<dynamic>>((item) {
                                  return DropdownMenuItem(
                                    value: item.id,
                                    child: Text(item.category),
                                    onTap: () {
                                      setState(() {
                                        widget.userModel.userCategory = item.id;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: FormBuilderTextField(
                                keyboardType: TextInputType.phone,
                                name: "name",
                                initialValue: widget.userModel.mobileNumber == 0
                                    ? ''
                                    : widget.userModel.mobileNumber.toString(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Mobile Number is required in this field';
                                  }
                                  if (value.length != 10) {
                                    return 'Enter valid mobile number';
                                  }
                                  if (isDuplicate) {
                                    return 'The Number is already exist its duplicate number ';
                                  }
                                  return null;
                                },
                                maxLength: 10,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 15),
                                  filled: true,
                                  hintText: 'Mobile Number',
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black45),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black45),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  fillColor: Colors.grey.shade100,
                                  hintStyle: TextStyle(
                                      color: Colors.blueGrey.shade500),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onChanged: (value) async {
                                  setState(() {
                                    widget.userModel.mobileNumber =
                                        int.parse(value!);
                                  });
                                  if (value!.length == 10) {
                                    var unMappedNumber =
                                        await checkMobileNumber(
                                            widget.userModel.mobileNumber,
                                            widget.userModel.id,
                                            widget.userModel.userCategory);
                                    var data = true;
                                    data = unMappedNumber['status'] == false &&
                                            unMappedNumber['tag'] != 'duplicate'
                                        ? false
                                        : true;
                                    setState(() => isDuplicate =
                                        unMappedNumber['tag'] == 'duplicate'
                                            ? true
                                            : false);
                                    if (!data) {
                                      alertWindow(
                                          widget.userModel.mobileNumber);
                                    } else {
                                      setState(() {
                                        isMapped = true;
                                      });
                                    }
                                  }
                                }),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: FormTextWidget(
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
                          ),
                          const SizedBox(
                            width: double.infinity,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black12),
                                    foregroundColor:
                                        const MaterialStatePropertyAll(
                                            Colors.white),
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.blueGrey.shade400)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (!isMapped) {
                                      Utility.displaySnackBar(context,
                                          'Please map your account before submitting');
                                    } else {
                                      submitParentInfo();
                                    }
                                  }
                                },
                                child: Text(
                                    widget.isEdit ? "Edit User" : "Save User")),
                          )
                        ])))));
  }

  Future<void> submitParentInfo() async {
    await addEditParent(widget.userModel, selectedPicture, widget.isEdit)
        .then((value) {
      if (value != null) {
        Utility.displaySnackBar(
            context,
            widget.isEdit
                ? "Parent Updated Scuessfully"
                : 'Parent added scuessfully');
        Navigator.pop(context, true);
        widget.callback();
      } else {
        setState(() {
          widget.userModel = userModel!;
        });
        Utility.displaySnackBar(
            context, 'Something went wrong please try again');
        Navigator.pop(context, true);
      }
    });
  }

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
      width: MediaQuery.of(context).size.width * 0.25,
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

class ParentCategory {
  String category;
  int id;
  ParentCategory({
    required this.category,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category,
      'id': id,
    };
  }

  factory ParentCategory.fromMap(Map<String, dynamic> map) {
    return ParentCategory(
      category: map['category'] as String,
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParentCategory.fromJson(String source) =>
      ParentCategory.fromMap(json.decode(source) as Map<String, dynamic>);
}

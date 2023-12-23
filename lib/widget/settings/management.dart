import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/addEditUser/add_edit_management_api.dart';
import 'package:ui/api/deleteApi.dart';
import 'package:ui/api/designation_list_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/settings/index.dart';
import '../../api/search/get_management_list_api.dart';
import '../../model/search/management_list_model.dart';
import 'package:ui/api/settings/index.dart';

class ManagementWidget extends StatefulWidget {
  const ManagementWidget({super.key});

  @override
  State<ManagementWidget> createState() => _ManagementWidgetState();
}

class _ManagementWidgetState extends State<ManagementWidget> {
  List<Division> divisions = [];
  List<DesignationList> designationList = [];

  List<ManagementList> managementList = [];
  List<XFile> selectedPicture = [];

  int divisionId = 0;
  bool isLoading = true;
  int designation = 0;
  String userId = '';
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
    getListOfManagement();
  }

  void getListOfManagement() async {
    await getManagementList(0).then((value) {
      if (value != null) {
        setState(() {
          managementList = value.data;
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            isEdit = false;
          });
          addEditPopUp(ManagementList.managementModelData);
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Management"),
        tooltip: 'Add Managements',
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
                "Management List",
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
            child: managementList == null || designationList.isEmpty
                ? LoadingAnimator()
                : managementList.isEmpty
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
                        itemCount: managementList.length,
                        itemBuilder: (context, index) {
                          var management = managementList[index];
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
                                              await deleteManagement(
                                                      managementId: management
                                                          .id
                                                          .toString())
                                                  .then((value) {
                                                getListOfManagement();
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
                                                      "Delete ${management.firstName}"),
                                                )),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isEdit = true;
                                                userId =
                                                    management.id.toString();
                                                nameController.text =
                                                    management.firstName;
                                                mailController.text = management
                                                    .mobileNumber
                                                    .toString();
                                                numberController.text =
                                                    management.mobileNumber
                                                        .toString();
                                              });
                                              Navigator.pop(context);
                                              addEditPopUp(management);
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Center(
                                                  child: Text(
                                                      "Edit ${management.firstName}"),
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
                                                    management.emailId == ''
                                                        ? "N/A"
                                                        : management.emailId
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
        ]),
      ),
    );
  }

  final TextEditingController dobController = TextEditingController();
  final TextEditingController dojController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<DesignationList> managementTypeList = [];

  Future<void> _selectDate(
      BuildContext context, String field, ManagementList managementList) async {
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
            managementList.dob = DateFormat.yMd().format(selectedDate);
            dobController.text = managementList.dob;
            break;
          case 'doj':
            managementList.doj = DateFormat.yMd().format(selectedDate);
            dojController.text = managementList.doj;
        }
      });
    }
  }

  addEditPopUp(ManagementList managementList) {
    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Text(isEdit ? "Edit Management" : "Add Management"),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await addEditManagement(
                        managementList,
                        selectedPicture,
                        isEdit,
                      ).then((value) {
                        if (value != null) {
                          Utility.displaySnackBar(
                              context,
                              isEdit
                                  ? "Management Updated Scuessfully"
                                  : 'Management added scuessfully');
                          Navigator.pop(context, true);
                        } else {
                          Utility.displaySnackBar(
                              context, 'Something went wrong please try again');
                          Navigator.pop(context, true);
                        }
                      });
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
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  runSpacing: 15,
                  children: [
                    FormTextWidget(
                        isValidate: true,
                        keyboardType: TextInputType.name,
                        isEnabled: true,
                        initialValue: managementList.firstName,
                        hintText: 'Management Name',
                        onChanged: (value) {
                          setState(() {
                            managementList.firstName = value!;
                          });
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: FormBuilderDropdown(
                        initialValue: managementList.designation == ''
                            ? null
                            : managementList.designation,
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
                          hintStyle: TextStyle(color: Colors.blueGrey.shade500),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        name: 'userCategory',
                        items: managementTypeList
                            .map<DropdownMenuItem<dynamic>>((item) {
                          return DropdownMenuItem(
                            value: item.categoryName,
                            child: Text(item.categoryName),
                            onTap: () {
                              setState(() {
                                managementList.userCategory = item.id;
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
                        initialValue: managementList.mobileNumber == 0
                            ? ''
                            : managementList.mobileNumber.toString(),
                        hintText: 'Mobile Number',
                        onChanged: (value) {
                          setState(() {
                            managementList.mobileNumber = int.parse(value!);
                          });
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    FormTextWidget(
                        isValidate: false,
                        isEnabled: true,
                        keyboardType: TextInputType.emailAddress,
                        initialValue: managementList.emailId,
                        hintText: 'Email Address',
                        onChanged: (value) {
                          setState(() {
                            managementList.emailId = value!;
                          });
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    FormTextWidget(
                        isValidate: false,
                        isEnabled: true,
                        keyboardType: TextInputType.name,
                        initialValue: managementList.employeeNo,
                        hintText: 'Employee Number',
                        onChanged: (value) {
                          setState(() {
                            managementList.employeeNo = value!;
                          });
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        _selectDate(context, 'dob', managementList);
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
                    InkWell(
                      onTap: () {
                        _selectDate(context, 'doj', managementList);
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
                  ],
                ),
              ),
            ),
          ),
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

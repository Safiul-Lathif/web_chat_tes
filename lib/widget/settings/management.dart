import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/DivisionlistApi.dart';
import 'package:ui/api/deleteApi.dart';
import 'package:ui/api/designation_list_api.dart';
import 'package:ui/api/excelAPiservice.dart';
import 'package:ui/api/management_list_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/DivisionlistModel.dart';
import 'package:ui/model/designation_list_model.dart';
import 'package:ui/model/management_list.dart';

class ManagementWidget extends StatefulWidget {
  const ManagementWidget({super.key});

  @override
  State<ManagementWidget> createState() => _ManagementWidgetState();
}

class _ManagementWidgetState extends State<ManagementWidget> {
  List<Division> divisions = [];
  List<DesignationList> designationList = [];

  List<ManagementList>? managementList;
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
    await getManagementList().then((value) {
      if (value != null) {
        setState(() {
          managementList = value;
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
                : managementList!.isEmpty
                    ? Center(
                        child: Text(
                          "No Management here click add button to add the Managements",
                          style: GoogleFonts.lato(),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, childAspectRatio: 2.1),
                        itemCount: managementList!.length,
                        itemBuilder: (context, index) {
                          var management = managementList![index];
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
                                                      "Delete ${management.managementPersonName}"),
                                                )),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isEdit = true;
                                                userId =
                                                    management.id.toString();
                                                nameController.text = management
                                                    .managementPersonName;
                                                mailController.text =
                                                    management.emailAddress;
                                                numberController.text =
                                                    management.mobileNumber
                                                        .toString();
                                                // designation =
                                                //     management.designation;
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
                                                      "Edit ${management.managementPersonName}"),
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
                                      management.photo == ''
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
                                                management.photo,
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
                                                  management
                                                      .managementPersonName,
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
                                                Text(
                                                  management.emailAddress,
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
                                                  designationList[management
                                                          .designation]
                                                      .categoryName,
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

  addEditPopUp() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Management" : "Add Management"),
          actions: [
            TextButton(
                onPressed: () async {
                  isEdit
                      ? await editManualDataManagement(
                          id: userId,
                          mail: mailController.text.toString(),
                          mob: numberController.text.toString(),
                          name: nameController.text.toString(),
                          designation: designation.toString(),
                        ).then((value) {
                          if (value != null) {
                            getListOfManagement();
                            Utility.displaySnackBar(context, value);
                          } else {
                            Utility.displaySnackBar(context, "error");
                          }
                          Navigator.pop(context);
                        })
                      : await manualDataManagement(
                          configType: "managements",
                          updateType: "manual",
                          mail: mailController.text,
                          mobileNumber: numberController.text,
                          name: nameController.text,
                          designation: designation.toString(),
                        ).then((value) {
                          getListOfManagement();
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
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'User name',
                  controller: nameController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: 'type User name ',
                      focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                      labelStyle: TextStyle(color: Colors.grey.shade800),
                      contentPadding:
                          const EdgeInsets.only(left: 10, top: 4, bottom: 4)),
                ),
                const SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  controller: numberController,
                  name: 'User Number',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: 'type User Number ',
                      focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                      labelStyle: TextStyle(color: Colors.grey.shade800),
                      contentPadding:
                          const EdgeInsets.only(left: 10, top: 4, bottom: 4)),
                ),
                const SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  controller: mailController,
                  name: 'User email',
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: 'type User email ',
                      focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                      labelStyle: TextStyle(color: Colors.grey.shade800),
                      contentPadding:
                          const EdgeInsets.only(left: 10, top: 4, bottom: 4)),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<dynamic>(
                  isExpanded: true,
                  value: designation,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: designationList.map<DropdownMenuItem<dynamic>>((item) {
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
              ],
            ),
          ),
        );
      },
    );
  }
}

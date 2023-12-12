import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/DivisionlistApi.dart';
import 'package:ui/api/deleteApi.dart';
import 'package:ui/api/settings/add_edit_division.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/DivisionlistModel.dart';

class DivisionWidget extends StatefulWidget {
  const DivisionWidget({super.key});

  @override
  State<DivisionWidget> createState() => _DivisionWidgetState();
}

class _DivisionWidgetState extends State<DivisionWidget> {
  List<Division>? divisionList;
  String divisionName = '';

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await getDivisionList().then((value) {
      if (value != null) {
        setState(() {
          divisionList = value;
        });
      }
    });
  }

  Future<void> addEditPopUp(bool isAdd, Division division) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isAdd ? "Add Division" : "Edit Division"),
          actions: [
            TextButton(
                onPressed: () async {
                  await addEditDivision(
                          divisionName: division.divisionName,
                          divisionId: division.id)
                      .then((value) {
                    if (value != null) {
                      initialize();
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
                  initialize();
                  Navigator.pop(context);
                },
                child: const Text("Cancel"))
          ],
          content: FormBuilderTextField(
            onChanged: (value) {
              setState(() {
                division.divisionName = value!;
              });
            },
            name: 'Division name',
            initialValue: division.divisionName,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintText: 'type division name ',
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1)),
                labelStyle: TextStyle(color: Colors.grey.shade800),
                contentPadding:
                    const EdgeInsets.only(left: 10, top: 4, bottom: 4)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          addEditPopUp(false, Division(id: 0, divisionName: ''));
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Division"),
        tooltip: 'Add Division',
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
                  "Division List",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                )),
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 10),
              child: divisionList == null
                  ? LoadingAnimator()
                  : divisionList!.isEmpty
                      ? Center(
                          child: Text(
                            "No Divisions here click add button to add the division",
                            style: GoogleFonts.lato(),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 5, crossAxisCount: 4),
                          itemCount: divisionList!.length,
                          itemBuilder: (context, index) {
                            var division = divisionList![index];
                            return Card(
                              child: ListTile(
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
                                                            "Do you want to Delete this division"),
                                                        actions: [
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await deleteDivision(
                                                                        divisionId: division
                                                                            .id
                                                                            .toString())
                                                                    .then(
                                                                        (value) {
                                                                  if (value !=
                                                                      null) {
                                                                    initialize();
                                                                    snackbar(
                                                                        "Deleted Successfully");
                                                                  } else {
                                                                    snackbar(
                                                                        "Not Deleted");
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              },
                                                              child: const Text(
                                                                  "Yes")),
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  "No"))
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Center(
                                                      child: Text(
                                                          "Delete ${division.divisionName}"),
                                                    )),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  addEditPopUp(false, division);
                                                },
                                                child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Center(
                                                      child: Text(
                                                          "Edit ${division.divisionName}"),
                                                    )),
                                              ),
                                            ])));
                                      });
                                },
                                title: Text(
                                  division.divisionName,
                                  style: GoogleFonts.lato(),
                                ),
                              ),
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }

  void snackbar(message) {
    Utility.displaySnackBar(context, message);
  }
}

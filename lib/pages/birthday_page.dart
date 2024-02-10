import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/birthday/get_birthday_api.dart';
import 'package:ui/api/birthday/send_birthday_api.dart';
import 'package:ui/custom/leading_image.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/birthday/birthday_model.dart';

class BirthdayPage extends StatefulWidget {
  const BirthdayPage({
    super.key,
  });

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  BirthdayList? birthdayList;
  List<String> classIds = [];
  String bDayMessage = "";
  List<StudentList> studentList = [];
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await getBirthdayList('').then((value) {
      if (value != null) {
        setState(() {
          birthdayList = value;
          studentList = value.studentList
              .where((element) => element.sentStatus != 1)
              .toList();
          bDayMessage = value.text;
        });
      }
    });
    for (int i = 0; i < studentList.length; i++) {
      setState(() {
        classIds.add(studentList[i].id.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.blue.shade50,
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                  image: const AssetImage("assets/images/bg_image_tes.jpg"),
                  repeat: ImageRepeat.repeatX)),
          child: birthdayList == null
              ? Center(child: LoadingAnimator())
              : studentList.isEmpty
                  ? Center(
                      child: Lottie.network(
                        "https://lottie.host/e9f9e1f1-0bcd-4d28-9830-2d7e9b0c9e30/OU2PntbZoS.json",
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.5,
                        repeat: true,
                        reverse: true,
                        animate: true,
                      ),
                    )
                  : Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "List of Students having birthday today",
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.55),
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 5, crossAxisCount: 4),
                            itemCount: studentList.length,
                            itemBuilder: (context, index) {
                              var student = studentList[index];
                              return Card(
                                child: ListTile(
                                  leading: student.image == ''
                                      ? CircleAvatar(
                                          radius: 23,
                                          child: Text(
                                            student.firstName
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : LeadingImageWidget(
                                          image: student.image),
                                  title: Text(student.firstName),
                                  subtitle: Text(student.classSection),
                                ),
                              );
                            },
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: FormBuilderTextField(
                            onChanged: (value) {
                              setState(() {
                                bDayMessage = "Dear *wardname* $value";
                              });
                            },
                            name: 'BirthDay Wishes',
                            maxLines: 10,
                            initialValue:
                                birthdayList!.text.split('*wardname*,').last,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                                labelStyle:
                                    TextStyle(color: Colors.grey.shade800),
                                contentPadding: const EdgeInsets.only(
                                    left: 10, top: 20, bottom: 4)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          const MaterialStatePropertyAll(
                                              Colors.white),
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.grey.shade600)),
                                  onPressed: onSendingBirthday,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Submit",
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  void onSendingBirthday() async {
    setState(() => birthdayList = null);
    if (studentList.where((element) => element.sentStatus != 0).isEmpty) {
      await sendBirthday(classIds: classIds, bDayMessage: bDayMessage)
          .then((value) {
        if (value != null) {
          initialize();
          Utility.displaySnackBar(
              context, "Birthday Wishes Added Successfully");
        }
      });
    } else {
      initialize();
      Utility.displaySnackBar(
          context, "Wishes Already send Successfully , don't send again");
    }
  }
}

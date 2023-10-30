import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/class_group_api.dart';
import 'package:ui/api/news&events/send_events_api.dart';
import 'package:ui/model/classModel.dart';

class AddEventForm extends StatefulWidget {
  const AddEventForm({super.key});

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  ImagePicker picker = ImagePicker();
  bool isChecked = false;
  void _selectImage() async {
    HapticFeedback.vibrate();
    final List<XFile> selectedImages = await picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        image.addAll(selectedImages);
      });
    }
  }

  var title = '';
  var link = '';
  var description = '';
  List<XFile> image = [];

  String? dateTime;
  String? time;
  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }

  void getAllTheGroup() async {
    await getClassGroup().then((value) {
      if (mounted) {
        setState(() {
          class_ = value;
          for (int i = 0; i < class_!.classGroup.length; i++) {
            menuItems.add(class_!.classGroup[i].groupName);
          }
        });
      }
    });
  }

  ClassGroup? class_;

  List<String> menuItems = [];
  List<String> selectedItems = [];
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        DateTime parsedTime =
            DateFormat.jm().parse(selectedTime.format(context).toString());
        _timeController.text = DateFormat('hh:mm a').format(parsedTime);
        time = DateFormat('HH:mm:ss').format(parsedTime);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllTheGroup();
    setState(() {
      _timeController.text = 'Select Time';
      _dateController.text = 'Select Date';
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.blue.withOpacity(0.2), BlendMode.dstATop),
              image: const AssetImage("assets/images/bg_image_tes.jpg"),
              repeat: ImageRepeat.repeat),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: AppBar().preferredSize.height - 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Text(
                      "Add Latest Events Here!!",
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                        onPressed: () => Navigator.pop(context, false),
                        icon: const Icon(
                          Icons.close,
                          size: 30,
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 17, right: 17),
                  child: Column(
                    children: [
                      SizedBox(
                        child: FormBuilderTextField(
                          onChanged: (value) {
                            setState(() {
                              title = value!;
                            });
                          },
                          name: 'Title',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Title is must while sending News!!!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1)),
                              labelStyle:
                                  TextStyle(color: Colors.grey.shade800),
                              labelText: 'Title',
                              contentPadding: const EdgeInsets.only(
                                  left: 10, top: 4, bottom: 4)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: FormBuilderTextField(
                          onChanged: (value) {
                            setState(() {
                              description = value!;
                            });
                          },
                          name: 'Description',
                          maxLines: null,
                          minLines: 5,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1)),
                              labelStyle:
                                  TextStyle(color: Colors.grey.shade800),
                              labelText: 'Description',
                              contentPadding: const EdgeInsets.only(
                                  left: 10, top: 4, bottom: 4)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: _selectImage,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Add Image",
                                  style: TextStyle(color: Colors.grey.shade800),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.add_a_photo,
                                    color: Colors.grey.shade800)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (image.isNotEmpty)
                        for (int i = 0; i < image.length; i++)
                          Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    child: Image.file(
                                      File(image[i].path),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Text(image[i].name)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        image.removeAt(i);
                                      });
                                    },
                                    icon: const Icon(Icons.delete)),
                              ],
                            ),
                          ),
                      const SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        onChanged: (value) {
                          setState(() {
                            link = value!;
                          });
                        },
                        name: 'Youtube Link',
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1)),
                            labelStyle: TextStyle(color: Colors.grey.shade800),
                            labelText: 'Youtube Link',
                            contentPadding: const EdgeInsets.only(
                                left: 10, top: 4, bottom: 4)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black45),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: FormBuilderTextField(
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                textAlign: TextAlign.center,
                                validator: (value) {
                                  if (value == 'Select Date' || value == null) {
                                    return 'Select Date!!';
                                  }
                                  return null;
                                },
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _dateController,
                                decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.only(top: 0.0)),
                                name: 'Date',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _selectTime(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black45),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: FormBuilderTextField(
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                textAlign: TextAlign.center,
                                validator: (value) {
                                  if (value == 'Select Time' || value == null) {
                                    return 'Select Time!!';
                                  }
                                  return null;
                                },
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _timeController,
                                decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.all(5)),
                                name: 'Time',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MultiSelectDialogField(
                        items: menuItems
                            .map((e) => MultiSelectItem(e, e))
                            .toList(),
                        listType: MultiSelectListType.CHIP,
                        buttonText: const Text("Select Individual Classes"),
                        onConfirm: (List<String> values) {
                          selectedItems = values;
                        },
                        searchable: true,
                        title: const Text("Select  classes"),
                        searchHint: 'Select Individual Classes',
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.black)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            List<String> selectedIds = [];
                            for (int i = 0; i < selectedItems.length; i++) {
                              selectedIds.add(class_!.classGroup
                                  .firstWhere((element) =>
                                      element.groupName == selectedItems[i])
                                  .classConfig
                                  .toString());
                            }
                            if (image.isNotEmpty) {
                              sendEvents(
                                      img: image,
                                      title: title,
                                      description: description,
                                      link: link,
                                      classIds: selectedIds,
                                      eventDate: selectedDate,
                                      eventTime: time.toString())
                                  .then((value) {
                                navigation(value != null
                                    ? "Events Added Successfully"
                                    : "Events not Added");
                              });
                            } else {
                              Utility.displaySnackBar(
                                  context, 'Image is Must for Events');
                            }
                          } else {
                            Utility.displaySnackBar(
                                context,
                                title == ''
                                    ? 'Please add Title for an Event'
                                    : 'Please Select Date and Time of an event');
                          }
                        },
                        child: Text('Publish This Event'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigation(String message) {
    Navigator.pop(context, true);
    Utility.displaySnackBar(context, message);
  }
}

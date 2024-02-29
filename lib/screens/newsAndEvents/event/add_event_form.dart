// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/class_group_api.dart';
import 'package:ui/api/news&events/delete_attachments.dart';
import 'package:ui/api/news&events/send_events_api.dart';
import 'package:ui/config/const.dart';
import 'package:ui/model/classModel.dart';
import 'package:ui/model/news&events/single_news_events_model.dart';
import '../../../widget/photo_view_page.dart';

class AddEventForm extends StatefulWidget {
  AddEventForm({super.key, this.eventFeed, required this.callback});
  SingleEvent? eventFeed;
  Function callback;

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  ImagePicker picker = ImagePicker();
  bool isChecked = false;
  Future<void> pickAndProcessImage() async {
    final pickedFile = await pickImage();
    imageView(pickedFile);
  }

  Future<void> imageView(List<PlatformFile> images) async {
    await showDialog<void>(
        context: context,
        builder: (context) => PhotoViewPage(
              onBack: () {
                setState(() {
                  images.clear();
                  Navigator.pop(context);
                });
              },
              images: images,
              onPressed: () async {
                var count = 0;
                for (var img in images) {
                  if (await isImageBelow5MB(img)) {
                    if (image.length >= 11) {
                      _snackBar('cant select more then 10 images');
                    } else {
                      setState(() {
                        image.add(img);
                      });
                    }
                  } else {
                    setState(() {
                      count++;
                      _snackBar("$count images removed as per restriction");
                    });
                  }
                }
                Navigator.pop(context);
              },
            ));
  }

  Future<List<PlatformFile>> pickImage() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      withData: true,
      allowMultiple: true,
      type: FileType.image,
    );

    return pickedFile!.files;
  }

  Future<bool> isImageBelow5MB(PlatformFile? pickedFile) async {
    if (pickedFile == null) return false;

    final fileSize = pickedFile.size;
    return fileSize < IMG_SIZE_RESTRICTION * 1024 * 1024; // 5 MB in bytes
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

  var title = '';
  var link = '';
  var description = '';
  var imageBorderColor = Colors.black;
  var onClicked = false;

  List<PlatformFile> image = [];

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
  var isEdit = false;
  var eventId = '';

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

  List<String> uploadedImages = [];

  @override
  void initState() {
    super.initState();
    getAllTheGroup();
    setState(() {
      _timeController.text = 'Select Time';
      _dateController.text = 'Select Date';
    });
    initialize();
  }

  final _formKey = GlobalKey<FormState>();

  void initialize() {
    if (widget.eventFeed != null) {
      setState(() {
        isEdit = true;
        title = widget.eventFeed!.title;
        description = widget.eventFeed!.description;
        link = widget.eventFeed!.youtubeLink;
        eventId = widget.eventFeed!.id.toString();
        selectedDate = widget.eventFeed!.eventDate;
        time = widget.eventFeed!.eventTime;
        _timeController.text = widget.eventFeed!.eventTime;
        _dateController.text =
            DateFormat.yMd().format(widget.eventFeed!.eventDate);
        for (int i = 0; i < widget.eventFeed!.images.length; i++) {
          uploadedImages.add(widget.eventFeed!.images[i].image);
        }
        for (int i = 0; i < widget.eventFeed!.visibility.length; i++) {
          selectedItems.add(widget.eventFeed!.visibility[i].visibilityClass);
        }
      });
    }
  }

  Future<void> deleteImage(String id, String attachmentId, int index) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Image'),
        content: const Text('Do you want to delete this Image?'),
        actions: [
          ElevatedButton(
            style: buttonStyle,
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: buttonStyle,
            onPressed: () async {
              await deleteAttachments(attachmentId: attachmentId, id: id)
                  .then((value) {
                if (value != null) {
                  _snackBar('Image Deleted Scuessfully');
                  setState(() {
                    uploadedImages.removeAt(index);
                  });
                } else {
                  _snackBar('Error in deleting image');
                }
                Navigator.pop(context);
              });
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<bool> goBack() async {
    Navigator.pop(context, true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.blue.withOpacity(0.2), BlendMode.dstATop),
            image: const AssetImage("assets/images/bg_image_tes.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Container(),
                    Text(
                      isEdit
                          ? "Edit your Uploaded Event"
                          : "Add Latest Events Here!!",
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                        onPressed: () => Navigator.pop(context, true),
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
                          initialValue: title,
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
                          initialValue: description,
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
                                  left: 10, top: 20, bottom: 4)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (isEdit && uploadedImages.isNotEmpty)
                        Text(
                          "Uploaded Image",
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        children: [
                          if (uploadedImages.isNotEmpty)
                            for (int i = 0; i < uploadedImages.length; i++)
                              Container(
                                margin: const EdgeInsets.all(5.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      margin: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: imageBorderColor),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15))),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        child: Image.network(
                                          uploadedImages[i],
                                          height: 95,
                                          width: 95,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            String imageId = widget
                                                .eventFeed!.images
                                                .firstWhere((element) =>
                                                    element.image ==
                                                    uploadedImages[i])
                                                .id
                                                .toString();
                                            deleteImage(
                                                widget.eventFeed!.id.toString(),
                                                imageId,
                                                i);
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: const Icon(
                                                Icons.cancel_presentation,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                        ],
                      ),
                      InkWell(
                        onTap: pickAndProcessImage,
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
                                border: Border.all(color: imageBorderColor),
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
                                    child: Image.memory(
                                      image[i].bytes!,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Text(image[i].name)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        image.removeAt(i);
                                      });
                                      if (image.length < 11) {
                                        setState(() {
                                          imageBorderColor = Colors.black;
                                          onClicked = false;
                                        });
                                      }
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
                        initialValue: link,
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
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: FormBuilderTextField(
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
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
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: FormBuilderTextField(
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
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
                      const SizedBox(
                        height: 10,
                      ),
                      MultiSelectDialogField(
                        initialValue: selectedItems,
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
                      onClicked
                          ? Container()
                          : ElevatedButton(
                              style: ButtonStyle(
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black12),
                                  foregroundColor:
                                      const MaterialStatePropertyAll(
                                          Colors.white),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.blueGrey.shade400)),
                              onPressed: () async {
                                var addUpdate = isEdit ? 'Updated' : 'Added';
                                if (_formKey.currentState!.validate()) {
                                  List<String> selectedIds = [];
                                  setState(() {
                                    onClicked = true;
                                  });
                                  for (int i = 0;
                                      i < selectedItems.length;
                                      i++) {
                                    selectedIds.add(class_!.classGroup
                                        .firstWhere((element) =>
                                            element.groupName ==
                                            selectedItems[i])
                                        .classConfig
                                        .toString());
                                  }
                                  if (image.isNotEmpty ||
                                      uploadedImages.isNotEmpty) {
                                    if (image.length >= 11) {
                                      _snackBar(
                                          'cant select more then 10 images');
                                      setState(() {
                                        imageBorderColor = Colors.red;
                                      });
                                    } else {
                                      sendEvents(
                                              img: image,
                                              eventsId: eventId,
                                              title: title,
                                              description: description,
                                              link: link,
                                              classIds: selectedIds,
                                              eventDate: selectedDate,
                                              eventTime: time.toString())
                                          .then((value) {
                                        navigation(value != null
                                            ? "Events $addUpdate Successfully"
                                            : "Events not $addUpdate");
                                      });
                                    }
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
                              child: Text(isEdit
                                  ? "Update Event"
                                  : 'Publish This Event'),
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
    widget.callback();
    Utility.displaySnackBar(context, message);
  }
}

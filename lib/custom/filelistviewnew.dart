import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/model/configurationModel.dart';
import 'package:ui/utils/utils_file.dart';

class FileListViewNew extends StatefulWidget {
  final dynamic file;
  final String iconPath;
  final Configurations? data;
  const FileListViewNew({
    Key? key,
    required this.file,
    required this.iconPath,
    this.data,
  }) : super(key: key);

  @override
  State<FileListViewNew> createState() => _FileListViewNewState();
}

class _FileListViewNewState extends State<FileListViewNew> {
  @override
  Widget build(BuildContext context) {
    return widget.file == null
        ? Container()
        : Container(
            constraints: const BoxConstraints(minHeight: 0.0, maxHeight: 60),
            child: GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.file.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: <Widget>[
                      SizedBox(
                          child: widget.file.length == 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 25,
                                      width: 25,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                        image: NetworkImage(
                                          ("https://cdn-icons-png.flaticon.com/128/6632/6632547.png"),
                                        ),
                                      )),
                                    ),
                                    Text(
                                      "Please select files to upload",
                                      style: SafeGoogleFont(
                                        'Inter',
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                )
                              : Image.memory(
                                  widget.file[index].bytes,
                                  fit: BoxFit.cover,
                                )),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                            size: 30.0,
                          ),
                          tooltip: 'download this attachment',
                          onPressed: () async {
                            setState(() {
                              widget.file.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                  // );
                }),
          );
  }
}

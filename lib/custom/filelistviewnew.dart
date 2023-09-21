import 'dart:io';
import 'package:flutter/material.dart';
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
            //color: Colors.white,
            constraints: BoxConstraints(
                minHeight: 0.0,
                maxHeight: widget.file.length == 1
                    ? 60.0
                    : widget.file.length == 0
                        ? 0.0
                        : 100.0),
            child: GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.file.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return
                      //  Container(
                      // margin:
                      //     const EdgeInsets.only(bottom: 5.0, left: 5, right: 5),
                      // height: 112.0,
                      // color: Colors.red,
                      // child:
                      Stack(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        height: 112,
                        width: 110,
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
                                            fit: BoxFit.fill)),
                                  ),
                                  Text(
                                    "Please select files to upload",
                                    style: SafeGoogleFont(
                                      'Inter',
                                      // fontSize: 12 * ffem,
                                      // fontWeight: FontWeight.w400,
                                      // height: 0.9152272542 *
                                      //     ffem /
                                      //     fem,
                                      // letterSpacing: 1.2 * fem,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              )
                            : Image.file(
                                File(widget.file[index].path),
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        right: -5,
                        top: -10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            // fileCheck
                            //     ? Icons.remove_red_eye_rounded
                            //     : Icons.arrow_circle_down_outlined,
                            color: Colors.grey,
                            size: 30.0,
                          ),
                          tooltip: 'download this attachment',
                          onPressed: () async {
                            // if (fileCheck) {
                            //   await OpenFile.open(
                            //       "${Strings.downloadPath}${Strings.defaultFolder}/${widget.file[index].toString().split('/').last}");
                            // } else {
                            setState(() {
                              widget.file == null;
                              widget.file.removeAt(index);
                              //       Navigator.pop(context);
                              //       // Navigator.pushReplacement(
                              //       //     context,
                              //       //     MaterialPageRoute(
                              //       //         builder: (context) =>
                              //       //             const OnBoarding()));
                            });
                            //     // DialogBuilder(context)
                            //     //     .showLoadingIndicator("Downloading...");
                            //     // String value = await Utility.downloadFileHttp(
                            //     //     widget.file[index],
                            //     //     widget.file[index].toString().split('/').last,
                            //     //     Strings.defaultFolder);
                            //     // // ignore: use_build_context_synchronously
                            //     // DialogBuilder(context).hideLoadingIndicator();
                            //     // // ignore: use_build_context_synchronously
                            //     // Utility.openDownloadedFile(
                            //     //     context,
                            //     //     "Downloaded Path: $value",
                            //     //     "$value/${widget.file[index].toString().split('/').last}");
                            //     // setState(() {
                            //     //   fileCheck = true;
                            //     // });
                            //     //  }
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

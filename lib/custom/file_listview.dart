import 'package:flutter/material.dart';
import 'package:ui/config/size_config.dart';

class FileListView extends StatefulWidget {
  final dynamic file;
  const FileListView({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  State<FileListView> createState() => _FileListViewState();
}

class _FileListViewState extends State<FileListView> {
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
            child: ListView.builder(
                itemCount: widget.file.length,
                itemBuilder: (BuildContext context, int index) {
                  // bool fileCheck = Utility.checkFileExists(
                  //     "${Strings.defaultFolder}/${widget.file[index].toString().split('/').last}");
                  return Container(
                    margin:
                        const EdgeInsets.only(bottom: 5.0, left: 5, right: 5),
                    height: 112.0,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.file[index].name,
                            // .toString()
                            // .split('/')
                            // .first
                            // .toString(),
                            //filePaths.keys.toList()[index],
                            style: TextStyle(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.cancel_rounded,
                            // fileCheck
                            //     ? Icons.remove_red_eye_rounded
                            //     : Icons.arrow_circle_down_outlined,
                            color: Colors.red,
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
                              Navigator.pop(context);
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const OnBoarding()));
                            });
                            // DialogBuilder(context)
                            //     .showLoadingIndicator("Downloading...");
                            // String value = await Utility.downloadFileHttp(
                            //     widget.file[index],
                            //     widget.file[index].toString().split('/').last,
                            //     Strings.defaultFolder);
                            // // ignore: use_build_context_synchronously
                            // DialogBuilder(context).hideLoadingIndicator();
                            // // ignore: use_build_context_synchronously
                            // Utility.openDownloadedFile(
                            //     context,
                            //     "Downloaded Path: $value",
                            //     "$value/${widget.file[index].toString().split('/').last}");
                            // setState(() {
                            //   fileCheck = true;
                            // });
                            //  }
                          },
                        ),
                      ],
                    ),
                  );
                }),
          );
  }
}

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
        : ListView.builder(
            shrinkWrap: true,
            itemCount: widget.file.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 5.0, left: 5, right: 5),
                height: 42,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        widget.file[index].name,
                        style: TextStyle(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.red,
                        size: 30.0,
                      ),
                      tooltip: 'download this attachment',
                      onPressed: () async {
                        setState(() {
                          widget.file == null;
                          widget.file.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            });
  }
}

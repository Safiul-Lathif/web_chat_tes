import 'dart:html';

import 'package:flutter/material.dart';
import 'package:ui/config/images.dart';

class ExcelScreen extends StatefulWidget {
  ExcelScreen({super.key, required this.downloadUrl});
  String downloadUrl;

  @override
  State<ExcelScreen> createState() => _ExcelScreenState();
}

class _ExcelScreenState extends State<ExcelScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.blue.withOpacity(0.2), BlendMode.dstATop),
            image: const AssetImage(Images.bgImage),
            repeat: ImageRepeat.repeatX),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Excel Process",
            style: TextStyle(fontSize: 22),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
            child: ElevatedButton(
                onPressed: () {
                  AnchorElement anchorElement =
                      AnchorElement(href: widget.downloadUrl);
                  anchorElement.download = widget.downloadUrl.split('/').last;
                  anchorElement.click();
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.download),
                    Text(
                      "Download Database",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
            child: ElevatedButton(
                onPressed: () {
                  AnchorElement anchorElement =
                      AnchorElement(href: widget.downloadUrl);
                  anchorElement.download = widget.downloadUrl.split('/').last;
                  anchorElement.click();
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.upload),
                    Text(
                      "Upload Database",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

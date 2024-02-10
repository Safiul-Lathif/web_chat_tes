import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:ui/utils/utility.dart';
import 'package:ui/utils/utils_file.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomTextWidget extends StatefulWidget {
  const CustomTextWidget({super.key, required this.data});
  final String data;

  @override
  State<CustomTextWidget> createState() => _CustomTextWidgetState();
}

class _CustomTextWidgetState extends State<CustomTextWidget> {
  bool onLinkTap = false;
  @override
  Widget build(BuildContext context) {
    return ExpandableText(
      widget.data.toString(),
      expandText: 'show more',
      collapseText: 'show less',
      urlStyle: TextStyle(
          color: Colors.blue,
          backgroundColor: onLinkTap ? Colors.blue.shade100 : null),
      onUrlTap: (value) async {
        setState(() => onLinkTap = true);
        if (await canLaunchUrl(Uri.parse(value))) {
          await launchUrl(Uri.parse(value),
                  mode: LaunchMode.externalApplication)
              .then((value) => setState(() => onLinkTap = false));
        } else {
          setState(() => onLinkTap = false);
        }
      },
      maxLines: 7,
      onExpandedChanged: (value) {
        if (value == true) {
          Utility.popUpDialog(context, widget.data);
        }
      },
      style: SafeGoogleFont(
        'Inter',
        fontSize: 15,
        color: const Color(0xff303030),
      ),
      linkColor: Colors.blue,
    );
  }
}

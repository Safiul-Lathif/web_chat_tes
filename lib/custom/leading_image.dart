import 'package:flutter/material.dart';

class LeadingImageWidget extends StatelessWidget {
  const LeadingImageWidget({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      child: Image.network(
        image,
        height: 46,
        width: 46,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.network(
            "https://cdn-icons-png.flaticon.com/512/3177/3177440.png",
            height: 46,
            width: 46,
          );
        },
      ),
    );
  }
}

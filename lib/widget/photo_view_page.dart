// ignore_for_file: must_be_immutable, deprecated_member_use
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatefulWidget {
  PhotoViewPage(
      {super.key,
      required this.images,
      required this.onPressed,
      required this.onBack});
  List<PlatformFile> images;
  Function()? onPressed;
  Function()? onBack;

  @override
  State<PhotoViewPage> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<PhotoViewPage> {
  final CarouselController _controller = CarouselController();
  int currentPage = 0;

  int angle = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey.shade600,
          foregroundColor: Colors.white,
          onPressed: widget.onPressed,
          child: const Icon(
            Icons.arrow_forward,
            size: 35,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              "$Image(${currentPage + 1}/${widget.images.length})",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade400),
            ),
            leading: IconButton(
                onPressed: widget.onBack,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey.shade400,
                )),
          ),
        ),
        body: Container(
            child: widget.images.length != 1
                ? Center(
                    child: CarouselSlider(
                      items: List.generate(widget.images.length, (index) {
                        return RotatedBox(
                          quarterTurns: angle,
                          child: SingleImageView(
                            image: widget.images[index],
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentPage = index;
                              angle = 0;
                            });
                          },
                          viewportFraction: 1,
                          height: MediaQuery.of(context).size.height,
                          initialPage: 0),
                      carouselController: _controller,
                    ),
                  )
                : RotatedBox(
                    quarterTurns: angle,
                    child: SingleImageView(
                      image: widget.images[0],
                    ),
                  )));
  }
}

class SingleImageView extends StatelessWidget {
  const SingleImageView({
    super.key,
    required this.image,
  });

  final PlatformFile image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PhotoView(
          gestureDetectorBehavior: HitTestBehavior.translucent,
          // backgroundDecoration: BoxDecoration(
          //     color: Colors.blue.shade50,
          //     image: DecorationImage(
          //       colorFilter: ColorFilter.mode(
          //           Colors.blue.withOpacity(0.2), BlendMode.dstATop),
          //       image: const NetworkImage(
          //           'https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg'),
          //       // fit: BoxFit.contain,
          //     )),
          imageProvider: MemoryImage(
            image.bytes!,
            scale: 40,
          )),
    );
  }
}

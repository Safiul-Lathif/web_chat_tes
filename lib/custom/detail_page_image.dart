// ignore_for_file: must_be_immutable, deprecated_member_use
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({super.key, required this.images, required this.index});
  List<String> images;
  int index;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final CarouselController _controller = CarouselController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentPage = widget.index;
    });
  }

  Future<void> _saveImage(BuildContext context, String url) async {
    String? message;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(url));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/${url.split('/').last}';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);
      if (finalPath != null) {
        message = 'Image saved to disk';
      }
    } catch (e) {
      message = 'An error occurred while saving the image';
    }

    if (message != null) {
      scaffoldMessenger.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating, content: Text(message)));
    }
  }

  double angle = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade50,
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.blue.withOpacity(0.2), BlendMode.dstATop),
                  image: const NetworkImage(
                      'https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg'),
                  fit: BoxFit.cover,
                )),
          ),
          title: Text(
            "Image(${currentPage + 1}/${widget.images.length})",
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            // IconButton(
            //     onPressed: () async {
            //       HapticFeedback.vibrate();
            //       var path = '';
            //       final url = Uri.parse(widget.images[currentPage]);
            //       final response = await http.get(url);
            //       final bytes = response.bodyBytes;
            //       final temp = await getTemporaryDirectory();
            //       path = '${temp.path}/Image.jpg';
            //       File(path).writeAsBytes(bytes);
            //       await Share.shareFiles(
            //         [path],
            //       );
            //     },
            //     icon: const Icon(Icons.share)),
            // IconButton(
            //     onPressed: () {
            //       setState(() {
            //         if (angle == 1.55) {
            //           angle = 0;
            //         } else {
            //           angle = 1.55;
            //         }
            //       });
            //     },
            //     icon: const Icon(Icons.rotate_90_degrees_ccw)),
            // IconButton(
            //     onPressed: () =>
            //         _saveImage(context, widget.images[currentPage]),
            //     icon: const Icon(Icons.download))
          ],
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          backgroundColor: Colors.blue.shade50,
        ),
        body: Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade50,
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.blue.withOpacity(0.2), BlendMode.dstATop),
                  image: const NetworkImage(
                      'https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg'),
                  fit: BoxFit.cover,
                )),
            child: widget.images.length != 1
                ? Center(
                    child: CarouselSlider(
                      items: List.generate(widget.images.length, (index) {
                        return Transform.rotate(
                          angle: angle,
                          child: SingleImageView(
                            image: widget.images[index],
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                          viewportFraction: 1,
                          height: MediaQuery.of(context).size.height,
                          initialPage: widget.index),
                      carouselController: _controller,
                    ),
                  )
                : Transform.rotate(
                    angle: angle,
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

  final String image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PhotoView(
          gestureDetectorBehavior: HitTestBehavior.translucent,
          backgroundDecoration: BoxDecoration(
              color: Colors.blue.shade50,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.2), BlendMode.dstATop),
                image: const NetworkImage(
                    'https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg'),
                fit: BoxFit.contain,
              )),
          imageProvider: NetworkImage(
            image.contains("https://")
                ? image
                : image.contains("http://")
                    ? image
                    : "http://$image",
            scale: 40,
          )),
    );
  }
}

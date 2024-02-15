// ignore_for_file: must_be_immutable, deprecated_member_use
import 'dart:html';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen(
      {super.key,
      required this.images,
      required this.index,
      required this.dateTime,
      required this.title});
  List<String> images;
  int index;
  String title;
  DateTime dateTime;
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
      // // Download image
      // final http.Response response = await http.get(Uri.parse(url));

      // // Get temporary directory
      // final dir = await getTemporaryDirectory();

      // // Create an image name
      // var filename = '${dir.path}/${url.split('/').last}';

      // // Save to filesystem
      // final file = File(filename);
      // await file.writeAsBytes(response.bodyBytes);

      // // Ask the user to save it
      // final params = SaveFileDialogParams(sourceFilePath: file.path);
      // final finalPath = await FlutterFileDialog.saveFile(params: params);
      // if (finalPath != null) {
      //   message = 'Image saved to disk';
      // }
      AnchorElement anchorElement = AnchorElement(href: url);
      anchorElement.download = "fileName";
      anchorElement.click();
    } catch (e) {
      message = 'An error occurred while saving the image';
    }

    if (message != null) {
      scaffoldMessenger.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating, content: Text(message)));
    }
  }

  int angle = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
          title: ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              "${widget.title}-Image(${currentPage + 1}/${widget.images.length})",
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
                DateFormat('d MMMM, yyyy,hh:mm a').format(widget.dateTime)),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            trailing: PopupMenuButton<int>(
                icon: const Icon(
                  Icons.more_vert,
                  size: 27,
                  color: Colors.black,
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                          onTap: () =>
                              _saveImage(context, widget.images[currentPage]),
                          child: const Text("Save")),
                      PopupMenuItem(
                          onTap: () {
                            setState(() {
                              switch (angle) {
                                case 0:
                                  {
                                    angle = 1;
                                  }
                                  break;
                                case 1:
                                  {
                                    angle = 2;
                                  }
                                  break;
                                case 2:
                                  {
                                    angle = 3;
                                  }
                                  break;
                                case 3:
                                  {
                                    angle = 4;
                                  }
                                  break;
                                default:
                                  angle = 0;
                              }
                            });
                          },
                          child: const Text("Rotate")),
                    ]),
          ),
          elevation: 0,
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
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: RotatedBox(
                      quarterTurns: angle,
                      child: Stack(
                        children: [
                          SingleImageView(
                            image: widget.images[currentPage],
                          ),
                          if (currentPage != 0)
                            Positioned(
                              left: 10,
                              bottom: MediaQuery.of(context).size.height * 0.4,
                              child: CircleAvatar(
                                backgroundColor: Colors.black26,
                                child: IconButton(
                                    onPressed: () => setState(() {
                                          currentPage--;
                                          angle = 0;
                                        }),
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          currentPage >= widget.images.length - 1
                              ? Container()
                              : Positioned(
                                  right: 10,
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black26,
                                    child: IconButton(
                                        onPressed: () => setState(() {
                                              currentPage++;
                                              angle = 0;
                                            }),
                                        icon: const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: Colors.white,
                                        )),
                                  ),
                                )
                        ],
                      ),
                    ))
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
                // fit: BoxFit.contain,
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

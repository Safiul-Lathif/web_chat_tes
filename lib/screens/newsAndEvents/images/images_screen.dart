// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ui/Utils/utility.dart';
import 'package:ui/api/news&events/news_image_api.dart';
import 'package:ui/custom/detail_page_image.dart';
import 'package:ui/custom/no_data_widget.dart';
import 'package:ui/model/news&events/news_image_model.dart';

class ImageScreenNews extends StatefulWidget {
  ImageScreenNews({super.key, required this.studentId});
  String studentId;

  @override
  State<ImageScreenNews> createState() => _ImageScreenNewsState();
}

class _ImageScreenNewsState extends State<ImageScreenNews> {
  List<NewsImages>? newsImages;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  List<String> images = [];
  void initialize() async {
    await getAllNewsImage(studentId: widget.studentId).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            newsImages = value;
            isLoading = false;
          });
          getAllImage();
        }
      } else {
        isLoading = false;
      }
    });
    isLoading = false;
  }

  Future<void> getAllImage() async {
    for (var i = 0; i < newsImages!.length; i++) {
      setState(() {
        images.add(newsImages![i].image);
      });
    }
  }

  List<String> selectedIndex = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: selectedIndex.isEmpty
            ? null
            : FloatingActionButton.extended(
                backgroundColor: Colors.blueGrey.shade600,
                foregroundColor: Colors.white,
                onPressed: () async {
                  List<String> paths = [];
                  var path = '';
                  setState(() {
                    path = '';
                    paths.clear();
                  });
                  HapticFeedback.vibrate();
                  for (int i = 0; i < selectedIndex.length; i++) {
                    final url = Uri.parse(selectedIndex[i]);
                    final response = await http.get(url);
                    final bytes = response.bodyBytes;
                    final temp = await getTemporaryDirectory();
                    path = '${temp.path}/Image$i.jpg';
                    paths.add(path);
                    File(paths[i]).writeAsBytes(bytes);
                  }
                  await Share.shareFiles(
                    paths,
                  );
                },
                label: Row(
                  children: const [
                    Icon(Icons.share),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Share"),
                  ],
                ),
              ),
        body: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.blue.shade50,
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                    image: const AssetImage("assets/images/bg_image_tes.jpg"),
                    repeat: ImageRepeat.repeat)),
            child: isLoading && newsImages == null
                ? const NoData()
                : MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: newsImages!.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onLongPress: () {
                                setState(() {
                                  selectedIndex.add(newsImages![index].image);
                                });
                              },
                              onTap: selectedIndex.isEmpty
                                  ? () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                              index: index,
                                              images: images,
                                            ),
                                          ));
                                    }
                                  : () {
                                      setState(() {
                                        if (selectedIndex.contains(
                                            newsImages![index].image)) {
                                          selectedIndex
                                              .remove(newsImages![index].image);
                                        } else {
                                          selectedIndex.length == 10
                                              ? Utility.displaySnackBar(context,
                                                  "can't select more then 10 images")
                                              : selectedIndex.add(
                                                  newsImages![index].image);
                                        }
                                      });
                                    },
                              child: Container(
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  image: DecorationImage(
                                    colorFilter: selectedIndex
                                            .contains(newsImages![index].image)
                                        ? ColorFilter.mode(
                                            Colors.blue.withOpacity(0.3),
                                            BlendMode.dstATop)
                                        : null,
                                    image:
                                        NetworkImage(newsImages![index].image),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(.5),
                                        offset: const Offset(3, 2),
                                        blurRadius: 7)
                                  ],
                                ),
                                child: selectedIndex
                                        .contains(newsImages![index].image)
                                    ? const Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.blue,
                                        ),
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )));
  }
}

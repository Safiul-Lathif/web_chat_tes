import 'package:flutter/material.dart';

Route createRoute(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class ListModel {
  String text;
  Image image;
  Function onTap;
  ListModel({
    required this.image,
    required this.text,
    required this.onTap,
  });
}

List<ListModel> lists = [
  ListModel(
    image: Image.network(
      "https://cdn-icons-png.flaticon.com/512/4090/4090395.png",
      height: 30,
      width: 30,
    ),
    text: 'Home Work',
    onTap: (context) {
      // Navigator.of(context).push(createRoute(const HomeWorkNew()));
    },
  ),
  ListModel(
    image: Image.network(
      "https://cdn-icons-png.flaticon.com/512/3125/3125856.png",
      height: 30,
      width: 30,
    ),
    text: 'School',
    onTap: (context) {},
  ),
  ListModel(
    image: Image.network(
      "https://cdn-icons-png.flaticon.com/512/1048/1048953.png",
      height: 30,
      width: 30,
    ),
    text: 'Attendance',
    onTap: (context) {},
  ),
  ListModel(
    image: Image.network(
      "https://cdn-icons-png.flaticon.com/128/9188/9188957.png",
      height: 30,
      width: 30,
    ),
    text: 'Calender',
    onTap: (context) {},
  ),
  ListModel(
    image: Image.network(
      "https://cdn-icons-png.flaticon.com/128/1048/1048947.png",
      height: 30,
      width: 30,
    ),
    text: 'Time Table',
    onTap: (context) {},
  ),
];

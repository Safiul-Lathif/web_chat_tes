import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoData extends StatelessWidget {
  const NoData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Center(
            child: Lottie.network(
              'https://assets7.lottiefiles.com/private_files/lf30_lkquf6qz.json',
              height: 400.0,
              repeat: true,
              reverse: true,
              animate: true,
            ),
          ),
        ],
      ),
    );
  }
}

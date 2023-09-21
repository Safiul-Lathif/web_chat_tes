import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/config/images.dart';

class LoadingAnimator extends StatelessWidget {
  LoadingAnimator({
    super.key,
  });

  var colorizeTextStyle = GoogleFonts.acme(
    fontSize: 27,
  );

  var colorizeColors = [
    Colors.pink,
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.red
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.blue.withOpacity(0.3), BlendMode.dstATop),
            image: const AssetImage(Images.bgImage),
            repeat: ImageRepeat.repeatX),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 80,
          ),
          Lottie.network(
            'https://assets8.lottiefiles.com/packages/lf20_fzmasdx7.json',
            height: 100.0,
            repeat: true,
            reverse: true,
            animate: true,
          ),
          AnimatedTextKit(repeatForever: true, animatedTexts: [
            ColorizeAnimatedText(
              "Loading ...",
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
            ),
          ])
        ],
      ),
    );
  }
}

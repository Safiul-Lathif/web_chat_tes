import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/config/images.dart';
import 'package:ui/model/message_view_model.dart';

class BirthdayCard extends StatefulWidget {
  const BirthdayCard({
    super.key,
    required this.data,
    required this.itemIndex,
    required this.id,
    required this.notiid,
    required this.callback,
    required this.role,
    required this.type,
    required this.redCount,
  });
  final Message data;
  final int itemIndex;
  final String id;
  final int notiid;
  final Function callback;
  final String role;
  final int type;
  final int redCount;

  @override
  State<BirthdayCard> createState() => _BirthdayCardState();
}

class _BirthdayCardState extends State<BirthdayCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ChatBubble(
          clipper: ChatBubbleClipper7(type: BubbleType.receiverBubble),
          backGroundColor: const Color(0xffE7E7ED),
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 3, left: 5, right: 10),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.25,
            ),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                      image: const AssetImage(Images.bgImage),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          offset: const Offset(3, 2),
                          blurRadius: 7)
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(children: [
                    Lottie.network(
                      "https://lottie.host/ed6500c4-b0ca-41d9-89bb-96eeabf0b752/QeeTfHqF5p.json",
                      height: 200.0,
                      repeat: true,
                      reverse: true,
                      animate: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        widget.data.message!,
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ]),
                )),
          ),
        ),
        Positioned(
          child: Lottie.network(
            "https://lottie.host/54e0f0af-0389-4f06-ab8c-0ff561d25246/LV8A47ZIZa.json",
            height: 200.0,
            repeat: true,
            reverse: true,
            animate: true,
          ),
        ),
        Positioned(
          right: 0,
          child: Lottie.network(
            "https://lottie.host/54e0f0af-0389-4f06-ab8c-0ff561d25246/LV8A47ZIZa.json",
            height: 200.0,
            repeat: true,
            reverse: true,
            animate: true,
          ),
        )
      ],
    );
  }
}

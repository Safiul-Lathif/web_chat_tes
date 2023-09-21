import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:ui/custom/info_delete.dart';
import 'package:ui/custom/receive_message_title.dart';
import 'package:ui/custom/send_message_title.dart';
import 'package:ui/custom/time_widget.dart';
import 'package:ui/custom/visibility_widget.dart';
import 'package:ui/model/message_view_model.dart';

class DeletedWidget extends StatefulWidget {
  const DeletedWidget(
      {super.key,
      required this.data,
      required this.itemIndex,
      required this.id,
      required this.notiid,
      required this.callback,
      required this.role,
      required this.type,
      required this.messageCategory,
      required this.redCount});
  final Message data;
  final int itemIndex;
  final String id;
  final int notiid;
  final Function callback;
  final String role;
  final int type;
  final String messageCategory;
  final int redCount;

  @override
  State<DeletedWidget> createState() => _DeletedWidgetState();
}

class _DeletedWidgetState extends State<DeletedWidget> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return widget.type == 2 ? receiveDelete(context) : sendDelete(context);
  }

  Padding sendDelete(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SendMessageTitle(
            data: widget.data,
            asset: '',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TimeWidget(
                redCount: widget.redCount,
                role: widget.role,
                tym: widget.data.dateTime.toString(),
                communicationType: widget.data.communicationType.toString(),

                notiid: widget.notiid,
                gid: widget.id,
                isDeleted: true,
                // communicationType: widget.data.communicationType.toString(),
              ),
              InkWell(
                onLongPress: () {
                  HapticFeedback.vibrate();
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                child: ChatBubble(
                    clipper: ChatBubbleClipper10(type: BubbleType.sendBubble),
                    backGroundColor: const Color(0xffE7E7ED),
                    margin: const EdgeInsets.only(bottom: 5, right: 5, left: 5),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      child: Text(
                        widget.messageCategory,
                        style: const TextStyle(
                            fontSize: 20,
                            decoration: TextDecoration.lineThrough),
                      ),
                    )),
              ),
              Visibility(
                visible: isVisible,
                child: Row(
                  children: [
                    InfoDeleteWidget(
                      data: widget.data,
                      itemIndex: widget.itemIndex,
                      id: widget.id,
                      callback: widget.callback,
                      type: widget.type,
                      isDeleted: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          VisibilityWidget(
              role: widget.role, visible: widget.data.visibility.toString()),
        ],
      ),
    );
  }

  Column receiveDelete(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(
              left: 7,
            ),
            child: ReceiveMessageTitle(data: widget.data, asset: '')),
        Row(
          children: [
            Visibility(
              visible: isVisible,
              child: Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  InfoDeleteWidget(
                    data: widget.data,
                    itemIndex: widget.itemIndex,
                    id: widget.id,
                    callback: widget.callback,
                    type: widget.type,
                    isDeleted: true,
                  ),
                ],
              ),
            ),
            InkWell(
              onLongPress: () {
                HapticFeedback.vibrate();
                setState(() {
                  isVisible = !isVisible;
                });
              },
              child: ChatBubble(
                  clipper: ChatBubbleClipper10(type: BubbleType.receiverBubble),
                  backGroundColor: const Color(0xffE7E7ED),
                  margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Text(
                      widget.messageCategory,
                      style: const TextStyle(
                          fontSize: 20, decoration: TextDecoration.lineThrough),
                    ),
                  )),
            ),
            TimeWidget(
              communicationType: widget.data.communicationType.toString(),

              redCount: widget.redCount,
              role: widget.role,
              tym: widget.data.dateTime.toString(),
              notiid: widget.notiid,
              gid: widget.id,
              isDeleted: true,
              // communicationType: widget.data.communicationType.toString(),
            )
          ],
        ),
        VisibilityWidget(
            role: widget.role, visible: widget.data.visibility.toString()),
      ],
    );
  }
}

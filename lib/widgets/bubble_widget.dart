import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BubbleWidget extends StatelessWidget {
  final int index;
  final TextAlign myTextAlign;
  final AlignmentGeometry myBubbleAlign;
  final BubbleNip myBubbleNip;
  final String msg;
  final Color color;

  const BubbleWidget(
      {Key key,
      this.index,
      this.myTextAlign,
      this.msg,
      this.myBubbleAlign,
      this.myBubbleNip,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime timeNow = DateTime.now();
    final String formattedDate = DateFormat('dd/MM – kk:mm').format(timeNow);
    return Bubble(
      color: color,
      elevation: 2,
      alignment: myBubbleAlign,
      nipWidth: 8,
      nipHeight: 18,
      nip: myBubbleNip,
      margin: const BubbleEdges.only(top: 12),
      child: Column(
        children: [
          Text(
            msg,
            textAlign: myTextAlign,
            style: const TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            formattedDate,
            textAlign: myTextAlign,
            style: const TextStyle(
                fontSize: 10.0,
                color: Colors.white54,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

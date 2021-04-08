import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aps/stream.dart';
import 'package:provider/provider.dart';

class BubbleWidget extends StatelessWidget {
  final myStreamProvider;
  final index;
  final myTextAlign;
  final myBubbleAlign;
  final myBubbleNip;
  final values;

  const BubbleWidget(
      {Key key,
      this.myStreamProvider,
      this.index,
      this.myTextAlign,
      this.values,
      this.myBubbleAlign,
      this.myBubbleNip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var myStreamProviderTextAlign = Provider.of<MyStream>(context).textAlign;
    var myStreamProviderText = Provider.of<MyStream>(context);
    print('TT: ' + myTextAlign.toString());
    return Container(
      child: Bubble(
        color: Color.fromRGBO(212, 234, 244, 1.0),
        alignment: myBubbleAlign,
        nipWidth: 8,
        nipHeight: 18,
        nip: myBubbleNip,
        margin: BubbleEdges.only(top: 12),
        child: Text(
          '$values',
          textAlign: myTextAlign,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

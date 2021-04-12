import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aps/stream.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BubbleWidget extends StatelessWidget {
  final myStreamProvider;
  final index;
  final myTextAlign;
  final myBubbleAlign;
  final myBubbleNip;
  final values;
  final clientLogin;

  const BubbleWidget(
      {Key key,
      this.myStreamProvider,
      this.index,
      this.myTextAlign,
      this.values,
      this.myBubbleAlign,
      this.myBubbleNip,
      this.clientLogin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime timeNow = DateTime.now();
    String formattedDate = DateFormat('dd/MM – kk:mm').format(timeNow);
    return Container(
      child: Bubble(
        color: Color.fromRGBO(212, 234, 244, 1.0),
        elevation: 2,
        alignment: myBubbleAlign,
        nipWidth: 8,
        nipHeight: 18,
        nip: myBubbleNip,
        margin: BubbleEdges.only(top: 12),
        child: Column(
          children: [
            Text(
              '$values',
              textAlign: myTextAlign,
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              '$formattedDate',
              textAlign: myTextAlign,
              style: TextStyle(fontSize: 10.0, color: Colors.grey),
            ),
          ],
        ), /*child: Text(
          test(myStreamProvider2, [], index, clientLogin),
          textAlign: myTextAlign,
          style: TextStyle(fontSize: 16.0),
        ),*/
      ),
    );
  }

  String test(var myMap, var retorno, int index, var client) {
    var lenght = 0;
    myMap.forEach((k, v) {
      if (k.contains('++$client') && v.contains('++$client')) {
        retorno.add(v.toString());
        lenght++;
        print(lenght);
        print('geust ret: ' + retorno.toString());
      } else {
        print('geust not ret: ' + retorno.toString());
      }
    });

    myMap.forEach((k, v) {
      if (k.contains('++lucas')) {
        print('Tem lucas');
        retorno.add(v.toString());
        print('lucas ret: ' + retorno.toString());
      }
    });

    return retorno[index];
  }
}

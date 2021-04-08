import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aps/stream.dart';
import 'package:flutter_aps/widgets/bubble_widget.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MyHomePage extends StatefulWidget {
  final Socket channel;
  final MyStream myStreamText;
  final BehaviorSubject<Socket> myStream;
  MyHomePage({@required this.channel, this.myStream, this.myStreamText});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  MyStream myStreamProvider2;

  @override
  Widget build(BuildContext context) {
    var myStreamProviderLength =
        Provider.of<MyStream>(context).clientResponse.keys.length;
    var myStreamProvider = Provider.of<MyStream>(context).clientResponse;
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatRoom'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Form(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: 'Send a message'),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 5,
              child: ListView.builder(
                itemCount: myStreamProviderLength,
                itemBuilder: (context, index) {
                  String key = myStreamProvider.keys.elementAt(index);
                  String values = myStreamProvider.values.elementAt(index);
                  return key.contains('lucas')
                      ? BubbleWidget(
                          index: index,
                          myStreamProvider: myStreamProvider,
                          values: values,
                          myBubbleAlign: Alignment.topRight,
                          myTextAlign: TextAlign.right,
                          myBubbleNip: BubbleNip.rightTop,
                        )
                      : BubbleWidget(
                          index: index,
                          myStreamProvider: myStreamProvider,
                          values: values,
                          myBubbleAlign: Alignment.topLeft,
                          myTextAlign: TextAlign.left,
                          myBubbleNip: BubbleNip.leftTop,
                        );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.myStream.value.write(_controller.text);
      var myStreamProvider = Provider.of<MyStream>(context, listen: false);
      setState(() {
        String finalStr = _controller.text.trim();
        final split = finalStr.split(' ');
        var body = split.sublist(2);
        var values = body.reduce((value, element) {
          return value + ' ' + element;
        });

        myStreamProvider.addResponse2(myStreamProvider.login, values);
      });
      _controller.clear();
    }
  }

  @override
  void dispose() {
    //  widget.channel.close();
    super.dispose();
  }
}

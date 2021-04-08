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
  final String login;
  MyHomePage(
      {@required this.channel, this.myStream, this.myStreamText, this.login});

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
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: Text('ChatRoom'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(15),
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: myStreamProviderLength,
                    itemBuilder: (context, index) {
                      String key = myStreamProvider.keys.elementAt(index);
                      String values = myStreamProvider.values.elementAt(index);
                      return key.contains('${widget.login}')
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
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: MediaQuery.of(context).size.height * 0.08,
                  alignment: Alignment.center, // align the row
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Form(
                          child: TextFormField(
                            controller: _controller,
                            decoration:
                                InputDecoration(labelText: 'Send a message'),
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 35,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.blue,
                        alignment: Alignment.bottomCenter,
                        onPressed: _sendMessage,
                        icon: Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* Expanded(
  child: Form(
  child: TextFormField(
  controller: _controller,
  decoration: InputDecoration(labelText: 'Send a message'),
  ),
  ),
  ),*/

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

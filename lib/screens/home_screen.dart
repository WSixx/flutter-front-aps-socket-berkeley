import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aps/stream.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MyHomePage extends StatefulWidget {
  final Socket channel;
  final MyStream myStreamText;
  final BehaviorSubject<Socket> myStream;
  MyHomePage({@required this.channel, this.myStream, this.myStreamText});
  //MyHomePage({this.myStream});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();

  /*void getServer() {
    setState(() {
      widget.myStream.stream.listen((event) {
        event.listen((event) {
          print('Home: ' + String.fromCharCodes(event).trim());
          widget.myStreamText.addResponse(String.fromCharCodes(event).trim());
        });
      });
      widget.myStream.add(widget.channel);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    var myStreamProviderLength = Provider.of<MyStream>(context).response.length;
    var myStreamProvider = Provider.of<MyStream>(context).response;
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatRoom'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: 'Send a message'),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: myStreamProviderLength,
                  itemBuilder: (context, index) {
                    return Bubble(
                      color: Color.fromRGBO(212, 234, 244, 1.0),
                      nip: BubbleNip.leftTop,
                      stick: true,
                      margin: BubbleEdges.only(top: 12),
                      child: Text(
                        '${myStreamProvider[index]}',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    );
                    /*ListTile(
                      title: Text('${myStreamProvider[index]}'),
                    );*/
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.myStream,
                builder: (context, snapshot) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Text('')
                      //widget.myStreamText.getServerResponse().toString()),
                      );
                },
              ),
            ],
          ),
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
      _controller.clear();
    }
  }

  @override
  void dispose() {
    //  widget.channel.close();
    super.dispose();
  }
}

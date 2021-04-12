import 'dart:async';
import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_aps/stream.dart';
import 'package:flutter_aps/widgets/bubble_widget.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ChatRoomScreen extends StatefulWidget {
  final Socket channel;
  final MyStream myStreamText;
  final BehaviorSubject<Socket> myStream;
  final String login;
  final String clientLogin;
  ChatRoomScreen(
      {@required this.channel,
      this.myStream,
      this.myStreamText,
      this.login,
      this.clientLogin});

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController _controller = TextEditingController();
  MyStream myStreamProvider2;
  int lenght = 0;
  var retorno;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    var myStreamProviderLength =
        Provider.of<MyStream>(context).clientResponse.keys.length;
    var myStreamProvider = Provider.of<MyStream>(context).clientResponse;
    var myStreamProvider2 = Provider.of<MyStream>(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Theme.of(context).primaryColor,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.clientLogin.toUpperCase()),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: test(myStreamProvider, widget.clientLogin),
                  itemBuilder: (context, index) {
                    var opa = word(myStreamProvider, index, widget.clientLogin);
                    return opa.contains('++${widget.clientLogin}')
                        ? BubbleWidget(
                            index: index,
                            values: opa,
                            myBubbleAlign: Alignment.topLeft,
                            myTextAlign: TextAlign.left,
                            myBubbleNip: BubbleNip.leftTop,
                          )
                        : BubbleWidget(
                            index: index,
                            values: opa,
                            myBubbleAlign: Alignment.topRight,
                            myTextAlign: TextAlign.right,
                            myBubbleNip: BubbleNip.rightTop,
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "Type Something",
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 35,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.blue,
                      alignment: Alignment.bottomCenter,
                      onPressed: () {
                        sendMessage(myStreamProvider2);
                        setState(() {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 10),
                              curve: Curves.easeOut,
                            );
                          });
                        });
                      },
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int test(var myMap, var client) {
    var length = 0;
    myMap.forEach((k, v) {
      if (k.contains('++$client')) {
        length++;
      }
    });
    myMap.forEach((k, v) {
      if (k.contains('++lucas')) {
        print('Tem lucas');
        length++;
      }
    });
    return length;
  }

  String word(var myMap, int index, var client) {
    var length = 0;
    retorno = [];
    myMap.forEach((k, v) {
      if (k.contains('++$client') && v.contains('++$client')) {
        retorno.add(v.toString());
        length++;
        print(length);
      } else if (k.contains('++lucas')) {
        retorno.add(v.toString());
      }
    });

    /*  myMap.forEach((k, v) {
      if (k.contains('++lucas')) {
        print('Tem lucas');
        retorno.add(v.toString());
        print('lucas ret: ' + retorno.toString());
      }
    });*/

    return retorno[index];
  }

  /* Expanded(
  child: Form(
  child: TextFormField(
  controller: _controller,
  decoration: InputDecoration(labelText: 'Send a message'),
  ),
  ),
  ),*/

  void sendMessage(var provider) {
    if (_controller.text.isNotEmpty) {
      widget.myStream.value.write('msg ' +
          '++' +
          '${widget.clientLogin.replaceAll(':', ' ')}' +
          _controller.text);
      var myStreamProvider = Provider.of<MyStream>(context, listen: false);
      setState(() {
        String finalStr = _controller.text.trim();
        final split = finalStr.split(' ');
        //var body = split.sublist(1);
        var values = split.reduce((value, element) {
          return value + ' ' + element;
        });
        print('Body is: ' + values);
        //myStreamProvider.addResponse2(myStreamProvider.login, values);
        myStreamProvider.addResponse2('++' + provider.login, values);
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

import 'dart:async';
import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_aps/emoticon.dart';
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
  var retorno = [];

  Emoticon _emoticon = Emoticon();

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
                  itemCount: getLength(myStreamProvider, widget.clientLogin),
                  itemBuilder: (context, index) {
                    var opa = getBodyMessage(
                        myStreamProvider, index, widget.clientLogin);
                    return opa.contains('++${widget.clientLogin}')
                        ? BubbleWidget(
                            index: index,
                            color: Theme.of(context).primaryColor,
                            values: opa.replaceAll('++', ''),
                            myBubbleAlign: Alignment.topLeft,
                            myTextAlign: TextAlign.left,
                            myBubbleNip: BubbleNip.leftTop,
                          )
                        : BubbleWidget(
                            index: index,
                            color: Color(0xFF208AAE),
                            values:
                                opa.replaceAll(':${widget.clientLogin}', ''),
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
                            onChanged: (text) {
                              text = _emoticon.checkEmoticonText(text);
                              print(text);
                              _controller.text = text;
                              _controller.selection =
                                  TextSelection.fromPosition(
                                TextPosition(offset: _controller.text.length),
                              );
                              //_controller.text = text;
                            }),
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

  int getLength(var myMap, var clientLogin) {
    var length = 0;
    myMap.forEach((k, v) {
      if (k.contains('++$clientLogin')) {
        length++;
      }
    });
    myMap.forEach((k, v) {
      if (k.contains('++${widget.login}')) {
        print('V:' + v);
        //length++;
        if (v.endsWith(':$clientLogin')) {
          retorno.add(v.toString());
          length++;
          // length++;
        }
      }
    });
    print('Lenght: ' + length.toString());
    return length;
  }

  String getBodyMessage(var myMap, int index, var client) {
    var length = 0;
    retorno = [];
    myMap.forEach((k, v) {
      if (k.contains('++$client') && v.contains('++$client')) {
        retorno.add(v.toString());
        length++;
      } else if (k.contains('++${widget.login}')) {
        //length++;
        if (v.endsWith(':$client')) {
          print('Tem apulo');
          retorno.add(v.toString());
          // length++;
        }
      }
    });

    print('IndexBody: ' + index.toString());
    print('LenghtBody: ' + length.toString());
    print('LenghtRetorno: ' + retorno.length.toString());
    return retorno[index];
  }

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
        var values = split.reduce((value, element) {
          return value + ' ' + element;
        });
        myStreamProvider.addResponse2(
            '++' + provider.login, values + ':${widget.clientLogin}');
        //myStreamProvider.addResponse2('++' + provider.login, values);
      });
      _controller.clear();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

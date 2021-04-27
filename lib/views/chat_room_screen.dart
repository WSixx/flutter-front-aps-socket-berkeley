import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_aps/utils/emoticon.dart';
import 'package:flutter_aps/providers/stream.dart';
import 'package:flutter_aps/utils/colors.dart';
import 'package:flutter_aps/widgets/bubble_widget.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ChatRoomScreen extends StatefulWidget {
  final Socket channel;
  final MyStream myStreamText;
  final BehaviorSubject<Socket> myStream;
  final String login;
  final String clientLogin;
  const ChatRoomScreen(
      {@required this.channel,
      this.myStream,
      this.myStreamText,
      this.login,
      this.clientLogin});

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  List returnList = [];

  final Emoticon _emoticon = Emoticon();

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
    final myStreamProvider = Provider.of<MyStream>(context).clientResponse;
    final myStreamProvider2 = Provider.of<MyStream>(context);
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
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
                  final opa = getBodyMessage(
                      myStreamProvider, index, widget.clientLogin);
                  return opa.contains('++${widget.clientLogin}')
                      ? BubbleWidget(
                          index: index,
                          color: Theme.of(context).primaryColor,
                          msg: opa.replaceAll('++', ''),
                          myBubbleAlign: Alignment.topLeft,
                          myTextAlign: TextAlign.left,
                          myBubbleNip: BubbleNip.leftTop,
                        )
                      : BubbleWidget(
                          index: index,
                          color: MyColors.lightBlue,
                          msg: opa.replaceAll(':${widget.clientLogin}', ''),
                          myBubbleAlign: Alignment.topRight,
                          myTextAlign: TextAlign.right,
                          myBubbleNip: BubbleNip.rightTop,
                        );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: MediaQuery.of(context).size.height * 0.08,
              alignment: Alignment.center, // align the row
              padding: const EdgeInsets.all(15.0),
              decoration: const BoxDecoration(
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
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "Type Something",
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          onFieldSubmitted: (text) {
                            sendMessage(myStreamProvider2);
                            scrollToEnd();
                          },
                          onChanged: (text) {
                            text = _emoticon.checkEmoticonText(text);
                            _controller.text = text;
                            _controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: _controller.text.length),
                            );
                          }),
                    ),
                  ),
                  IconButton(
                    iconSize: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.blue,
                    alignment: Alignment.bottomCenter,
                    onPressed: () {
                      sendMessage(myStreamProvider2);
                      scrollToEnd();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollToEnd() {
    setState(() {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 10),
          curve: Curves.easeOut,
        );
      });
    });
  }

  int getLength(dynamic myMap, dynamic clientLogin) {
    var length = 0;
    myMap.forEach((k, v) {
      if (k.contains('++$clientLogin') == true) {
        length++;
      }
    });
    myMap.forEach((k, v) {
      if (k.contains('++${widget.login}') == true) {
        //length++;
        if (v.endsWith(':$clientLogin') == true) {
          returnList.add(v.toString());
          length++;
          // length++;
        }
      }
    });
    return length;
  }

  String getBodyMessage(dynamic myMap, int index, dynamic client) {
    var length = 0;
    returnList = [];
    myMap.forEach((k, v) {
      if (k.contains('++$client') == true && v.contains('++$client') == true) {
        returnList.add(v.toString());
        length++;
      } else if (k.contains('++${widget.login}') == true) {
        //length++;
        if (v.endsWith(':$client') == true) {
          returnList.add(v.toString());
          // length++;
        }
      }
    });

    return returnList[index].toString();
  }

  void sendMessage(dynamic provider) {
    if (_controller.text.isNotEmpty) {
      widget.myStream.value.write(
          'msg ++${widget.clientLogin.replaceAll(':', ' ')}${_controller.text}');
      final myStreamProvider = Provider.of<MyStream>(context, listen: false);
      setState(() {
        final String finalStr = _controller.text.trim();
        final split = finalStr.split(' ');
        final values = split.reduce((value, element) {
          return '$value $element';
        });
        myStreamProvider.addResponse2(
            '++${provider.login}', '$values${':${widget.clientLogin}'}');
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

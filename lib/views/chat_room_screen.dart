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
  final MyChatClientStream myChatClientStream;
  final BehaviorSubject<Socket> myBehaviorSubjectSocket;
  final String login;
  final String clientLogin;
  const ChatRoomScreen(
      {@required this.channel,
      this.myBehaviorSubjectSocket,
      this.myChatClientStream,
      this.login,
      this.clientLogin});

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _textController = TextEditingController();
  List userBodyMessageList = [];
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
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myProviderClientResponse =
        Provider.of<MyChatClientStream>(context).clientResponse;
    final myProviderChatClientStream = Provider.of<MyChatClientStream>(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            MyColors.blue,
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: const BoxDecoration(
                  color: MyColors.white54,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      getLength(myProviderClientResponse, widget.clientLogin),
                  itemBuilder: (context, index) {
                    final clientBodyMessage = getBodyMessage(
                        myProviderClientResponse, index, widget.clientLogin);
                    return clientBodyMessage.contains('++${widget.clientLogin}')
                        ? BubbleWidget(
                            index: index,
                            color: Theme.of(context).primaryColor,
                            msg: clientBodyMessage.replaceAll('++', ''),
                            myBubbleAlign: Alignment.topLeft,
                            myTextAlign: TextAlign.left,
                            myBubbleNip: BubbleNip.leftTop,
                          )
                        : BubbleWidget(
                            index: index,
                            color: MyColors.lightBlue,
                            msg: clientBodyMessage.replaceAll(
                                ':${widget.clientLogin}', ''),
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
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15.0),
                decoration: const BoxDecoration(
                  color: MyColors.white54,
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
                            controller: _textController,
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
                              sendMessage(myProviderChatClientStream);
                              scrollToEnd();
                            },
                            onChanged: (text) {
                              text = _emoticon.checkTextHasEmoticon(text);
                              _textController.text = text;
                              _textController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: _textController.text.length),
                              );
                            }),
                      ),
                    ),
                    IconButton(
                      iconSize: 35,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: MyColors.blue,
                      alignment: Alignment.bottomCenter,
                      onPressed: () {
                        sendMessage(myProviderChatClientStream);
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
        if (v.endsWith(':$clientLogin') == true) {
          userBodyMessageList.add(v.toString());
          length++;
        }
      }
    });
    return length;
  }

  String getBodyMessage(dynamic myMap, int index, dynamic client) {
    var length = 0;
    userBodyMessageList = [];
    myMap.forEach((k, v) {
      if (k.contains('++$client') == true && v.contains('++$client') == true) {
        userBodyMessageList.add(v.toString());
        length++;
      } else if (k.contains('++${widget.login}') == true) {
        if (v.endsWith(':$client') == true) {
          userBodyMessageList.add(v.toString());
        }
      }
    });
    return userBodyMessageList[index].toString();
  }

  void sendMessage(dynamic provider) {
    if (_textController.text.isNotEmpty) {
      widget.myBehaviorSubjectSocket.value.write(
          'msg ++${widget.clientLogin.replaceAll(':', ' ')}${_textController.text}');
      final myChatClientStreamProvider =
          Provider.of<MyChatClientStream>(context, listen: false);
      setState(() {
        final String finalStr = _textController.text.trim();
        final split = finalStr.split(' ');
        final finalStringFormatted = split.reduce((value, element) {
          return '$value $element';
        });
        myChatClientStreamProvider.addResponseToChatRoom('++${provider.login}',
            '$finalStringFormatted${':${widget.clientLogin}'}');
      });
      _textController.clear();
    }
  }
}

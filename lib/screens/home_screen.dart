import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_aps/stream.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreen extends StatelessWidget {
  final Socket channel;
  final MyStream myStreamText;
  final BehaviorSubject<Socket> myStream;
  final String login;

  const HomeScreen(
      {Key key,
      @required this.channel,
      @required this.myStreamText,
      @required this.myStream,
      @required this.login})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var myStreamProviderLength =
        Provider.of<MyStream>(context).onlineLogins.length;
    var myStreamProviderNames = Provider.of<MyStream>(context).onlineLogins;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: myStreamProviderLength,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.person),
            title: Text('${myStreamProviderNames[index]}'),
          );
        },
      ),
    );
  }
}

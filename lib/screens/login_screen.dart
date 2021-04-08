import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_aps/screens/home_screen.dart';
import 'package:flutter_aps/server/chat_room_client.dart';
import 'package:flutter_aps/socket_connect.dart';
import 'package:flutter_aps/stream.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

class LoginScreen extends StatefulWidget {
  final Socket channel;
  LoginScreen({@required this.channel});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginController = TextEditingController();

  //Socket channel;
  final SocketConnect connectSocket = SocketConnect();

  Stream broadcastStream;
  BehaviorSubject<Socket> s = BehaviorSubject<Socket>();

  MyStream myStream;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getServer();

    //channel = connectSocket.sock;
  }

  @override
  Widget build(BuildContext context) {
    // MyStream myStream = MyStream(widget.channel);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: loginController,
                decoration: InputDecoration(
                  labelText: 'User',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                //  channel.write('login lucas 123');
                widget.channel.write('login lucas 123');
                myStream.login = 'lucas';
                /* if (getServerResponse() == 'Ok login' ||
                    getServerResponse() ==
                        'Welcome to dart-chat! There are 0 other clients online') {*/
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(
                      // channel: widget.channel,
                      channel: widget.channel, myStream: s,
                      // myStreamText: myStream,
                      //myStreamText: myStream,
                    ),
                  ),
                );
              },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }

  void getServer() {
    s.stream.listen((event) {
      //MyStream myStream = MyStream();
      myStream = Provider.of<MyStream>(context, listen: false);
      event.listen((event) {
        String fromCharCodes = String.fromCharCodes(event)
            .trim()
            .replaceAll('[', '')
            .replaceAll(']', ': ');

        final split = fromCharCodes.split(' ');
        final values = <int, String>{
          for (int i = 0; i < split.length; i++) i: split[i]
        };
        var from = values[0];
        var body = split.sublist(1);
        print('Login: ' + from.toString() + '-' + body.toString());
        myStream.addResponse2(from, fromCharCodes);
        myStream.login = 'lucas';
        print(myStream.itemsCount.toString());
      });
    });
    s.add(widget.channel);
  }
}

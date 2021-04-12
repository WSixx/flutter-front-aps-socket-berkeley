import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aps/client_details.dart';
import 'package:flutter_aps/screens/chat_room_screen.dart';
import 'package:flutter_aps/stream.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreen extends StatefulWidget {
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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> setWindowsSize() async {
    if (Platform.isWindows) {
      await DesktopWindow.resetMaxWindowSize();
    }
  }

  @override
  void initState() {
    super.initState();
    setWindowsSize();
  }

  @override
  Widget build(BuildContext context) {
    var myStreamProviderLength =
        Provider.of<MyStream>(context).onlineLogins.length;
    var myStreamProviderNames = Provider.of<MyStream>(context).onlineLogins;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: myStreamProviderLength,
          itemBuilder: (context, index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    width: 200,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 20,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.add),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: InkWell(
                    hoverColor: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoomScreen(
                            channel: widget.channel,
                            myStream: widget.myStream,
                            login: widget.login,
                            clientLogin: myStreamProviderNames[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${myStreamProviderNames[index].toUpperCase()}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

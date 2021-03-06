import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aps/providers/stream.dart';
import 'package:flutter_aps/views/chat_room_screen.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreen extends StatefulWidget {
  final Socket channel;
  final BehaviorSubject<Socket> myStream;
  final String login;

  const HomeScreen(
      {Key key,
      @required this.channel,
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
    final myStreamProviderLength =
        Provider.of<MyChatClientStream>(context).onlineLoginList.length;
    final myStreamProviderNames =
        Provider.of<MyChatClientStream>(context).onlineLoginList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
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
                    padding: const EdgeInsets.all(8),
                    width: 200,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 20,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.add),
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
                            myBehaviorSubjectSocket: widget.myStream,
                            login: widget.login,
                            clientLogin: myStreamProviderNames[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            myStreamProviderNames[index].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
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

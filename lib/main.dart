import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_aps/screens/login_screen.dart';
import 'package:flutter_aps/stream.dart';
import 'package:provider/provider.dart';

void main() async {
 Socket sock = await Socket.connect('192.168.0.33', 3320);
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyStream(),
      child: MyApp(sock),
    ),
  );
}

class MyApp extends StatelessWidget {
  Socket socket;
  MyApp(Socket s) {
    this.socket = s;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF204772),
      ),
      home: LoginScreen(channel: socket),
    );
  }
}

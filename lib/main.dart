import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_aps/providers/stream.dart';
import 'package:flutter_aps/utils/colors.dart';
import 'package:flutter_aps/views/login_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  final Socket sock = await Socket.connect('192.168.0.33', 3320);
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyStream(),
      child: MyApp(sock),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Socket socket;
  const MyApp(this.socket);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyColors.blueDark,
        fontFamily: 'Roboto',
      ),
      home: LoginScreen(channel: socket),
    );
  }
}

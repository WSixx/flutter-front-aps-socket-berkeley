import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aps/providers/stream.dart';
import 'package:flutter_aps/utils/colors.dart';
import 'package:flutter_aps/views/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

class LoginScreen extends StatefulWidget {
  final Socket channel;
  const LoginScreen({@required this.channel});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginController = TextEditingController();

  Stream broadcastStream;
  BehaviorSubject<Socket> s = BehaviorSubject<Socket>();

  final _formKey = GlobalKey<FormState>();

  MyStream myStream;
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    getServer();
    setWindowsSize();
  }

  Future<void> setWindowsSize() async {
    if (Platform.isWindows) {
      await DesktopWindow.setWindowSize(const Size(400, 380));
      await DesktopWindow.setMaxWindowSize(const Size(512, 512));
      await DesktopWindow.setFullScreen(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/lock.png',
                    height: screenHeight * 0.28,
                    width: screenWidth * 0.5,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: loginController,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'User',
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: MyColors.blue,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
                          return 'Digite o usuario';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: passwordController,
                      onEditingComplete: () => node.nextFocus(),
                      obscureText: true,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
                          return 'Digite uma senha';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  if (isLogin)
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          final String userLogin =
                              loginController.text.trim().toLowerCase();
                          final String userPassword =
                              passwordController.text.trim().toLowerCase();
                          signIn(userLogin, userPassword);
                        }
                      },
                      child: const Text('Entrar'),
                    )
                  else
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getServer() {
    s.stream.listen((event) {
      myStream = Provider.of<MyStream>(context, listen: false);
      event.listen((event) {
        String fromCharCodes;
        fromCharCodes =
            utf8.decode(event).trim().replaceAll('[', '').replaceAll(
                  ']',
                  ': ',
                );

        final split = fromCharCodes.split(' ');
        final values = <int, String>{
          for (int i = 0; i < split.length; i++) i: split[i]
        };
        final from = values[0];
        if (from.contains('Ok')) {
          myStream.isLogin = true;
        }
        myStream.addResponse2(from, fromCharCodes);
      });
    });
    s.add(widget.channel);
  }

  void navigator(String userLogin) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          channel: widget.channel,
          myStream: s,
          login: userLogin,
        ),
      ),
    );
  }

  Future<void> signIn(String userLogin, String userPassword) async {
    widget.channel.write('login $userLogin $userPassword');
    setState(() {
      isLogin = false;
    });
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (myStream.singIn()) {
        myStream.login = userLogin;
        navigator(userLogin);
      } else {
        setState(() {
          isLogin = true;
        });
      }
    });
  }
}

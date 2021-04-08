import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_aps/screens/chat_room_screen.dart';
import 'package:flutter_aps/screens/home_screen.dart';
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
  Stream broadcastStream;
  BehaviorSubject<Socket> s = BehaviorSubject<Socket>();

  final _formKey = GlobalKey<FormState>();

  MyStream myStream;
  bool isLogin = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getServer();
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
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
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
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
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
                  isLogin
                      ? ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              String userLogin =
                                  loginController.text.trim().toLowerCase();
                              String userPassword =
                                  passwordController.text.trim().toLowerCase();
                              signIn(userLogin, userPassword);
                            }
                          },
                          child: Text('Entrar'),
                        )
                      : CircularProgressIndicator(),
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
        if (from.contains('Ok')) {
          myStream.isLogin = true;
        }
        myStream.addResponse2(from, fromCharCodes);
      });
    });
    s.add(widget.channel);
  }

  /*void navigator(String userLogin) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomScreen(
          channel: widget.channel,
          myStream: s,
          login: userLogin,
        ),
      ),
    );
  }*/
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

  void signIn(String userLogin, String userPassword) async {
    widget.channel.write('login $userLogin $userPassword');
    setState(() {
      isLogin = false;
    });
    Future.delayed(Duration(seconds: 2)).then((_) {
      if (myStream.singIn()) {
        print('Entrou True');
        myStream.login = '$userLogin';
        navigator(userLogin);
      } else {
        setState(() {
          isLogin = true;
        });
      }
    });
  }
}

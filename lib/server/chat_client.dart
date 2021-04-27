import 'dart:io';

import 'package:flutter/material.dart';

import 'chat_room_client.dart';

class ChatClient {
  Socket _socket;
  String _address;
  int _port;
  final List<String> _login = [];

  Socket get socket {
    return _socket;
  }

  ChatClient(Socket s) {
    _socket = s;
    _address = _socket.remoteAddress.address;
    _port = _socket.remotePort;
    _socket.listen(messageHandler,
        onError: errorHandler, onDone: finishedHandler);
  }

  void distributeMessage(ChatClient client, String message) {
    final split = message.split(' ');
    final values = <int, String>{
      for (int i = 1; i < split.length; i++) i: split[i]
    };
    final sendTo = values[1];
    final body = split.sublist(2);
    final finalStr = body.reduce((value, element) {
      return '$value $element';
    });
    for (final c in clientsChatRoom) {
      if (c != client) {
        debugPrint(c._login.length.toString());
        if (c._login.contains(sendTo)) {
          c.write('$finalStr\n');
        }
      }
    }
  }

  void messageHandler(List<int> data) {
    final message = String.fromCharCodes(data).trim();
    debugPrint('login is: $_login');
    if (_login.isNotEmpty) {
      if ('logoff' == message || 'quit' == message) {
        write('Usuario deslogado');
        handleLogoff(this);
        return;
      }
    } else if (message.startsWith('login')) {
      handleLogin(this, message);
    }
    if (_login.isNotEmpty) {
      if (message.startsWith('msg')) {
        distributeMessage(this, message.replaceRange(0, 3, ''));
      }
    }
  }

  void errorHandler(dynamic error) {
    debugPrint('$_address:$_port Error: $error');
    removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    debugPrint('$_address:$_port Disconnected');
    removeClient(this);
    _socket.close();
  }

  void write(String message) {
    _socket.write(message);
  }

  void removeClient(ChatClient client) {
    clientsChatRoom.remove(client);
  }

  void handleLogoff(ChatClient chatClient) {
    removeClient(this);
    _login.clear();
  }

  void handleLogin(ChatClient chatClient, String message) {
    final client = chatClient._socket;
    final split = message.split(' ');
    final values = <int, String>{
      for (int i = 1; i < split.length; i++) i: split[i]
    };
    final login = values[1];
    final password = values[2];
    if ((login == 'lucas' && password == '123') ||
        (login == 'guest' && password == 'guest') ||
        (login == 'paulo' && password == 'paulo')) {
      const msg = 'Ok login';
      write(msg);
      _login.add(login);
      debugPrint('Usuario logado com  sucesso $login');
      distributeMessage(chatClient, 'Usuario: $login logado');
    } else {
      const msg = 'Error login\n';
      client.write(msg);
      debugPrint('Login Failed for: $login');
    }
  }

  List<String> getLogin() {
    return _login;
  }
}

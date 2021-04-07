import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_aps/server/chat_client.dart';

Socket socket;
List<ChatClient> clientsChatRoom;

class ChatRoom {
  Future<void> startChatRoom() async {
    await Socket.connect('localhost', 3320).then((Socket sock) async {
      socket = sock;
      clientsChatRoom.add(ChatClient(socket));
      print("cliente: " + clientsChatRoom.toString());
      socket.listen(
        dataHandler,
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false,
      );
    }).catchError((e) {
      print('Unable to connect: $e');
      exit(1);
    });

    //Connect standard in to the socket
    stdin.listen(
        (data) => socket.write(String.fromCharCodes(data).trim() + '\n'));
  }

  void dataHandler(data) {
    print(String.fromCharCodes(data).trim());
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket.destroy();
    exit(0);
  }
}

/*
class ChatClient {
  Socket _socket;
  String _address;
  int _port;
  List<String> _login = [];

  ChatClient([Socket s]) {
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
    var sendTo = values[1];
    var body = split.sublist(2);
    var finalStr = body.reduce((value, element) {
      return value + ' ' + element;
    });
    for (var c in clients) {
      if (c != client) {
        print(c.getLogin().length);
        if (c.getLogin().contains(sendTo)) {
          c.write(finalStr + '\n');
        }
      }
    }
  }

  void messageHandler(dynamic data) {
    var message = String.fromCharCodes(data).trim();
    print('login is: ' + _login.toString());
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
        distributeMessage(this, '${message.replaceRange(0, 3, '')}');
      }
    }
    //
  }

  void errorHandler(error) {
    print('$_address:$_port Error: $error');
    removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    print('$_address:$_port Disconnected');
    removeClient(this);
    _socket.close();
  }

  void write(String message) {
    _socket.write(message);
  }

  void removeClient(ChatClient client) {
    clients.remove(client);
  }

  void handleLogoff(ChatClient chatClient) {
    removeClient(this);
    _login.clear();
    //  var onlineMsg = 'offline ' + login + '\n';
    // distributeMessage(chatClient, 'Fui deslogado');
    sendMessageToAllClients('fui de', _socket);
  }

  void handleLogin(ChatClient chatClient, String message) {
    var client = chatClient._socket;
    final split = message.split(' ');
    final values = <int, String>{
      for (int i = 1; i < split.length; i++) i: split[i]
    };
    var login = values[1];
    var password = values[2];
    if ((login == 'lucas' && password == '123') ||
        (login == 'guest' && password == 'guest') ||
        (login == 'paulo' && password == 'paulo')) {
      var msg = 'Ok login';
      write(msg);
      _login.add(login);
      print('Usuario logado com  sucesso ' + login);
      distributeMessage(chatClient, 'Usuario: $login logado');
    } else {
      var msg = 'Error login\n';
      client.write(msg);
      print('Login Failed for: ' + login);
    }
  }

  List<String> getLogin() {
    return _login;
  }
}
*/

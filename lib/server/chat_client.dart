import 'dart:io';

import 'chat_room_client.dart';

class ChatClient {
  Socket _socket;
  String _address;
  int _port;
  final List<String> _login = [];

  get socket {
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
    var sendTo = values[1];
    var body = split.sublist(2);
    var finalStr = body.reduce((value, element) {
      return value + ' ' + element;
    });
    for (var c in clientsChatRoom) {
      if (c != client) {
        print(c._login.length);
        if (c._login.contains(sendTo)) {
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
    clientsChatRoom.remove(client);
  }

  void handleLogoff(ChatClient chatClient) {
    removeClient(this);
    _login.clear();
    //  var onlineMsg = 'offline ' + login + '\n';
    // distributeMessage(chatClient, 'Fui deslogado');
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

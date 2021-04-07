import 'dart:io';

import 'package:flutter_aps/server/chat_client.dart';
import 'package:flutter_aps/text_test.dart';

class Server {
  ServerSocket server;
  List<ChatClient> clients = [];
  Test test = Test();

  List<ChatClient> getChatList() {
    return clients;
  }

  void startServer() async {
    await ServerSocket.bind(InternetAddress.anyIPv4, 3320)
        .then((ServerSocket socket) async {
      server = socket;
      server.listen((client) async {
        await handleConnection(client);
      });
    });
  }

  void sendMessageToAllClients(String message, Socket client) {
    client.write(message);
  }

  Future<void> handleConnection(Socket client) async {
    print('Connection from '
        '${client.remoteAddress.address}:${client.remotePort}');
    test.addMsgText('conectado');

    clients.add(ChatClient(client));

    client.write('Welcome to dart-chat! '
        'There are ${clients.length - 1} other clients online\n');
    clients.forEach((element) {
      print('element: ' + element.getLogin().toString());
    });
  }
}

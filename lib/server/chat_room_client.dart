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
      debugPrint("cliente: $clientsChatRoom");
      socket.listen(
        dataHandler,
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false,
      );
    }).catchError((e) {
      debugPrint('Unable to connect: $e');
      exit(1);
    });

    //Connect standard in to the socket
    stdin.listen(
        (data) => socket.write('${String.fromCharCodes(data).trim()}\n'));
  }

  void dataHandler(List<int> data) {
    debugPrint(String.fromCharCodes(data).trim());
  }

  void errorHandler(String error, StackTrace trace) {
    debugPrint(error);
  }

  void doneHandler() {
    socket.destroy();
    exit(0);
  }
}

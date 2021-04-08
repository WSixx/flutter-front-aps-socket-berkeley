import 'dart:io';

class SocketConnect {
  Socket sock;

  SocketConnect() {
    connectSocket();
    print('Entrou Connect');
  }

  void connectSocket() async {
    this.sock = await Socket.connect('192.168.0.33', 3320);
  }

  void socketWrite(String writeMessage) {
    this.sock.write(writeMessage);
  }

  void closeSocket() {
    sock.close();
  }
}

import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyChatClientStream extends ChangeNotifier {
  final List<String> _onlineLoginList = [];
  Map<String, String> clientResponse = {};
  String login = '';
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  set isLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  List<String> get onlineLoginList => _onlineLoginList;

  bool singIn() {
    if (isLogin == true) {
      return true;
    } else {
      return false;
    }
  }

  void addResponseToChatRoom(String key, String value) {
    if (value.startsWith('++', 0) &&
        !onlineLoginList.contains(key.substring(2))) {
      onlineLoginList.add(key.substring(2));
      notifyListeners();
    }
    clientResponse[key + getRandString(5)] = value;
    notifyListeners();
  }

  String getRandString(int lengthOfRandomString) {
    final random = Random.secure();
    final randomString =
        List<int>.generate(lengthOfRandomString, (i) => random.nextInt(255));
    return base64UrlEncode(randomString);
  }
}

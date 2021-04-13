import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_aps/client_details.dart';

class MyStream extends ChangeNotifier {
  List<String> _response = [];
  List<String> _onlineLogins = [];
  Map<String, String> clientResponse = {};
  Map<String, List<String>> clientResponse2 = {};
  String login = '';
  bool _isLogin = false;
  var textAlign;

  bool get isLogin => _isLogin;

  set isLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  List<String> get onlineLogins => _onlineLogins;

  set onlineLogins(List<String> value) {
    _onlineLogins = value;
  }

  bool singIn() {
    if (isLogin == true) {
      return true;
    } else {
      return false;
    }
  }

  void addResponse2(String key, String value) {
    if (value.startsWith('++', 0) && !onlineLogins.contains(key.substring(2))) {
      ClientDetails clientDetails = ClientDetails();
      onlineLogins.add(key.substring(2));
      clientDetails.login = key.substring(2);
      notifyListeners();
    }
    clientResponse[key + getRandString(5)] = value;

    String myKey = key.substring(2).replaceAll(':', '');
    String myValue = value.split(":").last;

    if (clientResponse2.isEmpty) {
      clientResponse2[key] = [myValue.trim()];
    }

    notifyListeners();
  }

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  int get itemsCount {
    return response.length;
  }

  List<String> get response => _response;

  List<String> getServerResponse() {
    return _response;
  }
}

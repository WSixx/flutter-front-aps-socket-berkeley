import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

class MyStream extends ChangeNotifier {
  List<String> _response = [];
  Map<String, String> clientResponse = {};
  String login = '';
  bool _isLogin = false;
  int index;
  var textAlign;

  bool get isLogin => _isLogin;

  set isLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  bool singIn() {
    if (isLogin == true) {
      return true;
    } else {
      return false;
    }
  }

  void addResponse(String value, int indexWidget) {
    if (value.contains('guest')) {
      toggleSelected(indexWidget);
      notifyListeners();
    } else {}
    _response.add(value);
    notifyListeners();
  }

  void addResponse2(String key, String value) {
    clientResponse[key + getRandString(5)] = value;
    notifyListeners();
  }

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void toggleSelected(int indexWidget) {
    this.index = indexWidget;
    notifyListeners(); // To rebuild the Widget
  }

  int get itemsCount {
    return response.length;
  }

  List<String> get response => _response;

  List<String> getServerResponse() {
    return _response;
  }
}

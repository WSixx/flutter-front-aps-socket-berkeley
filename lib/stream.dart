import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';

class MyStream extends ChangeNotifier {
  List<String> _response = [];
  String login = '';
  var textAlign = TextAlign.left;

  void addResponse(String value) {
    print('ADD Response: ' + value);
    if (value.contains('msg')) {
      print('entrou Align: ' + value);
      textAlign = TextAlign.right;
      notifyListeners();
    } else {
      textAlign = TextAlign.left;
      notifyListeners();
    }
    _response.add(value);
    notifyListeners();
  }

  int get itemsCount {
    return response.length;
  }

  List<String> get response => _response;

  List<String> getServerResponse() {
    return _response;
  }
}

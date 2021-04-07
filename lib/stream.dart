import 'dart:io';

import 'package:flutter/foundation.dart';

class MyStream extends ChangeNotifier {
  List<String> _response = [];

  void addResponse(String value) {
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

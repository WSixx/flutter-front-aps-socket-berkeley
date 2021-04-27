import 'package:flutter/material.dart';

class Emoticon {
  String checkEmoticonText(String text) {
    String textWithEmote;
    if (text.contains('(:')) {
      textWithEmote = text.replaceAll('(::))', '😀');
      return textWithEmote;
    }
    return text;
  }
}

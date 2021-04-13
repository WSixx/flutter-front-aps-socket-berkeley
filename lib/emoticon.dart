import 'package:flutter/material.dart';

class Emoticon {
  String checkEmoticonText(String text) {
    String textWithEmoji;
    if (text.contains('(:')) {
      textWithEmoji = text.replaceAll('(::))', '😀');
      return textWithEmoji;
    }
    return text;
  }
}

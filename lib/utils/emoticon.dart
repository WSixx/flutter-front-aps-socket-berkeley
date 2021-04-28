class Emoticon {
  String checkTextHasEmoticon(String text) {
    String textWithEmote;
    if (text.contains('(:')) {
      textWithEmote = text.replaceAll('(::))', '😀');
      return textWithEmote;
    }
    return text;
  }
}

class Test {
  String msgText;

  //Test(this._msgText);
  //Test();

  //String get msgText => _msgText;

  void addMsgText(String value) {
    print('value ' + value);
    msgText = value;
  }

  String getText() {
    print('get text: ' + msgText);
    return msgText;
  }
}

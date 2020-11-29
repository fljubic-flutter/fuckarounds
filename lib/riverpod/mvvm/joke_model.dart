class JokeSingle {
  String _text;

  JokeSingle({String text}) {
    _text = text;
  }
  String get text => _text;
}

class JokeTwoPart {
  String _setup;
  String _delivery;

  JokeTwoPart({String setup, String delivery}) {
    _setup = setup;
    _delivery = delivery;
  }

  String get setup => _setup;
  String get delivery => _delivery;
}

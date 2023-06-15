import 'package:flutter/material.dart';



class UiSettings with ChangeNotifier {
  String _passphrase = "12345";

  set passphrase(newValue) {
    _passphrase = newValue;
    notifyListeners();
  }
  String get passphrase => _passphrase;
}
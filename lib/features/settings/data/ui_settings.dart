import 'package:flutter/material.dart';



class UiSettings with ChangeNotifier {
  String _yourAddress = "n1Nd8J38uyDRLwh5ShAAPvbNrqBD1wee8v";
  String _passphrase = "12345";

  set yourAddress(newValue){
    _yourAddress = newValue;
    notifyListeners();
  }

  set passphrase(newValue) {
    _passphrase = newValue;
    notifyListeners();
  }
  String get yourAddress => _yourAddress;
  String get passphrase => _passphrase;
}
import 'package:flutter/material.dart';

class UserProfile with ChangeNotifier {
  String _name;

  UserProfile(this._name);

  String get name => _name;

  set name(String newName) {
    if (newName != _name) {
      _name = newName;
      notifyListeners();
    }
  }
}

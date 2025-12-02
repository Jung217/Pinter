import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  String? _email;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get email => _email;
  String? get token => _token;

  void login({
    required String username,
    required String email,
    String? token,
  }) {
    _isLoggedIn = true;
    _username = username;
    _email = email;
    _token = token;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _username = null;
    _email = null;
    _token = null;
    notifyListeners();
  }
}

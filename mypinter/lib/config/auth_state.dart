import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  String? _email;
  String? _token;
  String? _refreshToken;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get email => _email;
  String? get token => _token;
  String? get refreshToken => _refreshToken;

  // Initialize and load saved auth state
  Future<void> loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _username = prefs.getString('username');
      _email = prefs.getString('email');
      _token = prefs.getString('token');
      _refreshToken = prefs.getString('refreshToken');
      notifyListeners();
    } catch (e) {
      // If loading fails, just start with default values
      print('Error loading auth state: $e');
    }
  }

  Future<void> login({
    required String username,
    required String email,
    String? token,
    String? refreshToken,
  }) async {
    _isLoggedIn = true;
    _username = username;
    _email = email;
    _token = token;
    _refreshToken = refreshToken;

    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    if (token != null) await prefs.setString('token', token);
    if (refreshToken != null) await prefs.setString('refreshToken', refreshToken);

    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _username = null;
    _email = null;
    _token = null;
    _refreshToken = null;

    // Clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('token');
    await prefs.remove('refreshToken');

    notifyListeners();
  }
}

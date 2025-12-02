import 'package:flutter/material.dart';
import 'package:mypinter/pages/registerPage.dart';
import 'package:mypinter/config/l10n.dart';
import 'package:provider/provider.dart';
import 'package:mypinter/config/auth_state.dart';
import 'package:mypinter/pages/accountPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  bool _isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email);
  }

  Future<void> _loginAction() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    // Validation
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請輸入使用者名稱')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請輸入密碼')),
      );
      return;
    }

    // Show loading
    setState(() {
      isLoading = true;
    });

    try {
      // Call login API
      final response = await http.post(
        Uri.parse('http://123.192.96.63:8000/api/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        // Success - parse tokens
        final data = jsonDecode(response.body);
        final accessToken = data['access'];
        final refreshToken = data['refresh'];

        // Fetch user info using access token
        final userResponse = await http.get(
          Uri.parse('http://123.192.96.63:8000/api/auth/user/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (userResponse.statusCode == 200) {
          final userData = jsonDecode(userResponse.body);
          
          // Set auth state with user info and tokens
          final authState = Provider.of<AuthState>(context, listen: false);
          authState.login(
            username: userData['username'] ?? username,
            email: userData['email'] ?? '',
            token: accessToken,
          );

          if (!mounted) return;
          
          // Navigate to AccountPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AccountPage()),
          );
        } else {
          // Failed to fetch user info, but login was successful
          final authState = Provider.of<AuthState>(context, listen: false);
          authState.login(
            username: username,
            email: '',
            token: accessToken,
          );

          if (!mounted) return;
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AccountPage()),
          );
        }
      } else {
        // Login failed
        final data = jsonDecode(response.body);
        String errorMessage = '登入失敗';
        
        if (data is Map) {
          if (data.containsKey('detail')) {
            errorMessage = data['detail'];
          } else if (data.containsKey('error')) {
            errorMessage = data['error'];
          } else {
            errorMessage = data.values.join('\n');
          }
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('網路錯誤: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/app_logo.png',
                  width: 100,
                ),
                const SizedBox(height: 12),
                Text(
                  'PINTER',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 32),

                // Username
                TextField(
                  controller: usernameController,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: '使用者名稱',
                    hintStyle: TextStyle(color: colorScheme.secondary),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: L10n.of(context, 'password'),
                    hintStyle: TextStyle(color: colorScheme.secondary),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: colorScheme.secondary,
                      ),
                      onPressed: () => setState(() {
                        obscurePassword = !obscurePassword;
                      }),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(L10n.of(context, 'forgotPassword'),
                        style: TextStyle(color: colorScheme.secondary, fontSize: 14)),
                  ),
                ),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.cardTheme.color,
                      foregroundColor: colorScheme.onSurface,
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isLoading ? null : _loginAction,
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onSurface),
                            ),
                          )
                        : Text(
                            L10n.of(context, 'login'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 28),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: colorScheme.outline)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(L10n.of(context, 'orSignInWith'),
                          style: TextStyle(color: colorScheme.secondary, fontSize: 14)),
                    ),
                    Expanded(child: Divider(color: colorScheme.outline)),
                  ],
                ),
                const SizedBox(height: 20),

                // Social Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(theme.cardTheme.color!, colorScheme.outline,
                        icon: Icons.apple, iconColor: colorScheme.onSurface, onTap: () {}),
                    const SizedBox(width: 16),
                    _socialButton(theme.cardTheme.color!, colorScheme.outline,
                        assetGoogle: true, onTap: () {}),
                  ],
                ),
                const SizedBox(height: 32),

                // Register
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: colorScheme.secondary, fontSize: 14),
                    children: [
                      TextSpan(text: "${L10n.of(context, 'dontHaveAccount')} "),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterPage()),
                            );
                          },
                          child: Text(
                            L10n.of(context, 'registerNow'),
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Toggle Dark/Light
                // Toggle Dark/Light removed as it is system controlled
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(Color card, Color border,
      {IconData? icon,
      bool assetGoogle = false,
      Color iconColor = Colors.black,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: card,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3)],
        ),
        child: Center(
          child: assetGoogle
              ? Image.asset(
                  'assets/google_logo.png', // 確保 pubspec.yaml 有正確宣告
                  width: 19,
                )
              : Icon(icon, color: iconColor, size: 28),
        ),
      ),
    );
  }
}

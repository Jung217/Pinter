import 'package:flutter/material.dart';
import 'package:mypinter/pages/loginPage.dart';
import 'package:mypinter/config/l10n.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool _isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email);
  }

  void _registerAction() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    String? error;
    if (!_isValidEmail(email)) {
      error = '請輸入有效的 Email 格式';
    } else if (password.length < 6) {
      error = '密碼至少需 6 個字元';
    } else if (password != confirmPassword) {
      error = '密碼不一致';
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    // 成功註冊
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('註冊成功\nEmail: $email')),
    );
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
                  width: 70,
                ),
                const SizedBox(height: 12),
                Text(
                  'PINTER',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  L10n.of(context, 'createAccount'),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 48),

                // Email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: L10n.of(context, 'email'),
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
                const SizedBox(height: 20),

                // Confirm Password
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: L10n.of(context, 'confirmPassword'),
                    hintStyle: TextStyle(color: colorScheme.secondary),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: colorScheme.secondary,
                      ),
                      onPressed: () => setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
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
                const SizedBox(height: 28),

                // Register Button
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
                    onPressed: _registerAction,
                    child: Text(
                      L10n.of(context, 'register'),
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
                      child: Text(L10n.of(context, 'orSignUpWith'),
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

                // Login Link
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: colorScheme.secondary, fontSize: 14),
                    children: [
                      TextSpan(text: "${L10n.of(context, 'alreadyHaveAccount')} "),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            L10n.of(context, 'login'),
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
                  'assets/google_logo.png',
                  width: 19,
                )
              : Icon(icon, color: iconColor, size: 28),
        ),
      ),
    );
  }
}

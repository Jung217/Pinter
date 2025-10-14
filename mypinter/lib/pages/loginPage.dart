import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isDark = false;
  bool obscurePassword = true; // ✅ 密碼顯示切換

  // 驗證 Email
  bool _isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email);
  }

  void _loginAction() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    String? error;
    if (!_isValidEmail(email)) {
      error = '請輸入有效的 Email 格式';
    } else if (password.length < 6) {
      error = '密碼至少需 6 個字元';
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    // 成功輸入
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('登入成功\nEmail: $email\nPassword: $password')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 自訂顏色
    const Color primary = Color(0xFFFF4500);
    const Color backgroundLight = Color(0xFFF0F0F0);
    const Color backgroundDark = Color(0xFF1A1A1A);
    const Color cardLight = Colors.white;
    const Color cardDark = Color(0xFF2C2C2C);
    const Color textLight = Color(0xFF1F2937);
    const Color textDark = Color(0xFFF3F4F6);
    const Color subtleLight = Color(0xFF6B7280);
    const Color subtleDark = Color(0xFF9CA3AF);
    const Color borderLight = Color(0xFFE5E7EB);
    const Color borderDark = Color(0xFF4B5563);

    final Color bg = isDark ? backgroundDark : backgroundLight;
    final Color card = isDark ? cardDark : cardLight;
    final Color text = isDark ? textDark : textLight;
    final Color subtle = isDark ? subtleDark : subtleLight;
    final Color border = isDark ? borderDark : borderLight;

    return Scaffold(
      backgroundColor: bg,
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
                    color: text,
                  ),
                ),
                const SizedBox(height: 32),

                // Email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: text),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: subtle),
                    filled: true,
                    fillColor: card,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primary),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  style: TextStyle(color: text),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: subtle),
                    filled: true,
                    fillColor: card,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: subtle,
                      ),
                      onPressed: () => setState(() {
                        obscurePassword = !obscurePassword;
                      }),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primary),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot Password?',
                        style: TextStyle(color: subtle, fontSize: 14)),
                  ),
                ),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: card,
                      foregroundColor: text,
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _loginAction, // ✅ 驗證與 SnackBar
                    child: const Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Or sign in with',
                          style: TextStyle(color: subtle, fontSize: 14)),
                    ),
                    Expanded(child: Divider(color: border)),
                  ],
                ),
                const SizedBox(height: 20),

                // Social Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(card, border,
                        icon: Icons.apple, iconColor: text, onTap: () {}),
                    const SizedBox(width: 16),
                    _socialButton(card, border,
                        assetGoogle: true, onTap: () {}),
                  ],
                ),
                const SizedBox(height: 32),

                // Register
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: subtle, fontSize: 14),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Register now',
                            style: TextStyle(
                              color: text,
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
                // SwitchListTile(
                //   value: isDark,
                //   onChanged: (v) => setState(() => isDark = v),
                //   activeColor: primary,
                //   title: Text('Dark Mode', style: TextStyle(color: text)),
                // )
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

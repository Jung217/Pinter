import 'package:flutter/material.dart';
import 'package:mypinter/config/l10n.dart';
import 'package:mypinter/pages/dogRegistrationPage.dart';
import 'package:mypinter/pages/settingPage.dart';
import 'package:provider/provider.dart';
import 'package:mypinter/config/auth_state.dart';
import 'package:mypinter/pages/loginPage.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, authState, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context, 'account')),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authState.username ?? 'User Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authState.email ?? 'user@example.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Dog Registration Button
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: CircleAvatar(
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                child: Icon(Icons.pets, color: colorScheme.primary),
              ),
              title: Text(
                L10n.of(context, 'dogRegistration'),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                L10n.of(context, 'dogRegistration'),
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.secondary,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.secondary),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DogRegistrationPage()),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // My Dogs
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: CircleAvatar(
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                child: Icon(Icons.list_alt, color: colorScheme.primary),
              ),
              title: Text(
                L10n.of(context, 'myDogs'),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.secondary),
              onTap: () {
                // Navigate to my dogs list
              },
            ),
          ),
          const SizedBox(height: 32),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                authState.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: Text(
                L10n.of(context, 'logout'),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.red, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
        );
      },
    );
  }
}

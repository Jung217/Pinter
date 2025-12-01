import 'package:flutter/material.dart';
import 'package:mypinter/config/app_settings.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  void _showLanguageDialog(BuildContext context) {
    final settings = Provider.of<AppSettings>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(settings.language == 'zh_TW' ? '選擇語言' : 'Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                //leading: const Text('🇹🇼', style: TextStyle(fontSize: 24)),
                title: const Text('繁體中文'),
                trailing: settings.language == 'zh_TW'
                    ? const Icon(Icons.check, color: Colors.orange)
                    : null,
                onTap: () {
                  settings.setLanguage('zh_TW');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已設定為繁體中文')),
                  );
                },
              ),
              ListTile(
                //leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
                title: const Text('English'),
                trailing: settings.language == 'en'
                    ? const Icon(Icons.check, color: Colors.orange)
                    : null,
                onTap: () {
                  settings.setLanguage('en');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Language set to English')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemeModeDialog(BuildContext context) {
    final settings = Provider.of<AppSettings>(context, listen: false);
    final isZh = settings.language == 'zh_TW';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isZh ? '選擇主題' : 'Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.brightness_5),
                title: Text(isZh ? '淺色' : 'Light'),
                trailing: settings.themeMode == ThemeMode.light
                    ? const Icon(Icons.check, color: Colors.orange)
                    : null,
                onTap: () {
                  settings.setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_2),
                title: Text(isZh ? '深色' : 'Dark'),
                trailing: settings.themeMode == ThemeMode.dark
                    ? const Icon(Icons.check, color: Colors.orange)
                    : null,
                onTap: () {
                  settings.setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_auto),
                title: Text(isZh ? '跟隨系統' : 'Follow System'),
                trailing: settings.themeMode == ThemeMode.system
                    ? const Icon(Icons.check, color: Colors.orange)
                    : null,
                onTap: () {
                  settings.setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, settings, child) {
        final isZh = settings.language == 'zh_TW';
        
        return Scaffold(
          appBar: AppBar(
            title: Text(isZh ? "設定" : "Settings"),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            elevation: 1,
          ),
          body: ListView(
            children: [
              const SizedBox(height: 16),
              _buildSectionHeader(isZh ? "帳號" : "Account"),
              _buildSettingItem(
                context,
                Icons.person,
                isZh ? "編輯個人資料" : "Edit Profile",
                () {},
              ),
              _buildSettingItem(
                context,
                Icons.lock,
                isZh ? "更改密碼" : "Change Password",
                () {},
              ),
              _buildSettingItem(
                context,
                Icons.notifications,
                isZh ? "通知" : "Notifications",
                () {},
              ),
              
              const Divider(height: 32),
              _buildSectionHeader(isZh ? "偏好設定" : "Preferences"),
              _buildSettingItem(
                context,
                Icons.language,
                isZh ? "語言" : "Language",
                () => _showLanguageDialog(context),
                subtitle: settings.getCurrentLanguageText(),
              ),
              _buildSettingItem(
                context,
                Icons.dark_mode,
                isZh ? "深色模式" : "Dark Mode",
                () => _showThemeModeDialog(context),
                subtitle: settings.getThemeModeText(),
              ),
              
              const Divider(height: 32),
              _buildSectionHeader(isZh ? "支援" : "Support"),
              _buildSettingItem(
                context,
                Icons.help,
                isZh ? "幫助與支援" : "Help & Support",
                () {},
              ),
              _buildSettingItem(
                context,
                Icons.info,
                isZh ? "關於我們" : "About Us",
                () {},
              ),
              
              const Divider(height: 32),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text(
                  isZh ? "登出" : "Logout",
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  // Handle logout
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    String? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}

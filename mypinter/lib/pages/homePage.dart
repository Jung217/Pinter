import 'dart:async' show TimeoutException;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mypinter/pages/loginPage.dart';
import 'package:mypinter/pages/forumPage.dart';
import 'package:mypinter/pages/chatPage.dart';
import 'package:mypinter/pages/pairingPage.dart';
import 'package:mypinter/pages/mapPage.dart';
import 'package:mypinter/pages/settingPage.dart';
import 'package:mypinter/pages/postPage.dart';
import 'package:mypinter/config/constants.dart';
import 'package:mypinter/config/l10n.dart';
import 'package:provider/provider.dart';
import 'package:mypinter/config/app_settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<dynamic>> fetchPosts() async {
    const url = AppConstants.apiUrl;

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5)); // 超過 5 秒就超時

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Server Error");
      }
    } on TimeoutException {
      throw Exception("Request Timeout");
    } catch (e) {
      throw Exception("Network Error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, settings, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text("Pinter", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
      ),
      drawer: Drawer(
        backgroundColor: colorScheme.surface,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.surface),
              child: Icon(Icons.apps, size: 64, color: colorScheme.onSurface),
            ),
            _drawerItem(icon: Icons.forum, text: L10n.of(context, 'forum'), page: const ForumPage()),
            _drawerItem(icon: Icons.chat, text: L10n.of(context, 'chat'), page: const ChatPage()),
            _drawerItem(icon: Icons.compare_arrows, text: L10n.of(context, 'pairing'), page: const PairingPage()),
            _drawerItem(icon: Icons.map, text: L10n.of(context, 'map'), page: const MapPage()),
            _drawerItem(icon: Icons.account_circle, text: L10n.of(context, 'account'), page: const LoginPage()),
            _drawerItem(icon: Icons.settings, text: L10n.of(context, 'settings'), page: const SettingPage()),
            const Spacer(),
            // Dark Mode switch removed as it is now system controlled
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: colorScheme.primary));
          }
          if (snapshot.hasError) {
            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          AppConstants.sadDogs,
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        L10n.of(context, 'loadingFailed'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => setState(() {}),
                        icon: const Icon(Icons.refresh),
                        label: Text(L10n.of(context, 'retry')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          final posts = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {}); 
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Card(
                  color: theme.cardTheme.color,
                  shape: theme.cardTheme.shape,
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['title'] ?? "",
                            style: theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
                        const SizedBox(height: 8),
                        Text(post['content'] ?? "",
                            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: colorScheme.secondary,
                              child: const Icon(Icons.person, size: 16, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Text(post['author'] ?? "",
                                style: TextStyle(color: colorScheme.secondary, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: colorScheme.onPrimary),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostPage()),
          );
        },
      ),
        );
      },
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required Widget page,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
    );
  }
}

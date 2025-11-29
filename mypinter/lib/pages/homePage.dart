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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDark = false;

  Future<List<dynamic>> fetchPosts() async {
    const url = "http://123.192.96.63:8000/api/posts/?format=json";

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
    const Color primary = Color(0xFFFF4500);
    const Color backgroundLight = Color(0xFFF0F0F0);
    const Color backgroundDark = Color(0xFF1A1A1A);
    const Color cardLight = Colors.white;
    const Color cardDark = Color(0xFF2C2C2C);
    const Color textLight = Color(0xFF1F2937);
    const Color textDark = Color(0xFFF3F4F6);
    const Color subtleLight = Color(0xFF6B7280);
    const Color subtleDark = Color(0xFF9CA3AF);

    final Color bg = isDark ? backgroundDark : backgroundLight;
    final Color card = isDark ? cardDark : cardLight;
    final Color text = isDark ? textDark : textLight;
    final Color subtle = isDark ? subtleDark : subtleLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text("Pinter", style: TextStyle(color: text, fontWeight: FontWeight.bold)),
        backgroundColor: card,
        iconTheme: IconThemeData(color: text),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search, color: text)),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none, color: text)),
        ],
      ),
      drawer: Drawer(
        backgroundColor: card,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: card),
              child: Icon(Icons.apps, size: 64, color: text),
            ),
            _drawerItem(icon: Icons.forum, text: "論壇", textColor: text, page: ForumPage()),
            _drawerItem(icon: Icons.chat, text: "聊天", textColor: text, page: ChatPage()),
            _drawerItem(icon: Icons.compare_arrows, text: "配對", textColor: text, page: PairingPage()),
            _drawerItem(icon: Icons.map, text: "寵物地圖", textColor: text, page: MapPage()),
            _drawerItem(icon: Icons.account_circle, text: "帳號", textColor: text, page: LoginPage()),
            _drawerItem(icon: Icons.settings, text: "設定", textColor: text, page: SettingPage()),
            const Spacer(),
            Container(
              color: card,
              child: SwitchListTile(
                value: isDark,
                onChanged: (v) => setState(() => isDark = v),
                activeColor: primary,
                title: Text('Dark Mode', style: TextStyle(color: text)),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primary));
          }
          if (snapshot.hasError) {
            final dogGif = "https://media.tenor.com/sdwtJhSDETgAAAAM/sad-dog.gif";
            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          dogGif,
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "載入失敗跟你的人生一樣 :P",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: text,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => setState(() {}),
                        icon: const Icon(Icons.refresh),
                        label: const Text("再試一次"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
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
                  color: card,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['title'] ?? "",
                            style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 8),
                        Text(post['content'] ?? "",
                            style: TextStyle(color: text, fontSize: 16)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: subtle,
                              child: const Icon(Icons.person, size: 16, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Text(post['author'] ?? "",
                                style: TextStyle(color: subtle, fontSize: 13)),
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
        backgroundColor: primary,
        child: Icon(Icons.add, color: bg),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostPage()),
          );
        },
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required Color textColor,
    required Widget page,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(text, style: TextStyle(color: textColor)),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
    );
  }
}

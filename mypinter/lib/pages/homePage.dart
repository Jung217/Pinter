import 'package:flutter/material.dart';
import 'package:mypinter/pages/loginPage.dart';
import 'package:mypinter/pages/forumPage.dart';
import 'package:mypinter/pages/chatPage.dart';
import 'package:mypinter/pages/pairingPage.dart';
import 'package:mypinter/pages/mapPage.dart';
import 'package:mypinter/pages/settingPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDark = false;

  final List<Map<String, String>> posts = [
    {
      'image': 'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg',
      'user': 'DogLover99',
      'avatar': 'https://i.pravatar.cc/150?img=12',
      'caption': 'A very good boy enjoying the sun ☀️',
    },
    {
      'image': 'https://images.unsplash.com/photo-1574158622682-e40e69881006',
      'user': 'CorgiFanatic',
      'avatar': 'https://i.pravatar.cc/150?img=36',
      'caption': 'Sleepy corgi loaf 😴',
    },
    {
      'image': 'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg',
      'user': 'DogLover99',
      'avatar': 'https://i.pravatar.cc/150?img=12',
      'caption': 'A very good boy enjoying the sun ☀️',
    },
    {
      'image': 'https://images.unsplash.com/photo-1574158622682-e40e69881006',
      'user': 'CorgiFanatic',
      'avatar': 'https://i.pravatar.cc/150?img=36',
      'caption': 'Sleepy corgi loaf 😴',
    }
  ];

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
    // const Color borderLight = Color(0xFFE5E7EB);
    // const Color borderDark = Color(0xFF4B5563);

    final Color bg = isDark ? backgroundDark : backgroundLight;
    final Color card = isDark ? cardDark : cardLight;
    final Color text = isDark ? textDark : textLight;
    final Color subtle = isDark ? subtleDark : subtleLight;
    //final Color border = isDark ? borderDark : borderLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text("Pinter", style: TextStyle(color: text, fontWeight: FontWeight.bold)),
        backgroundColor: card,
        iconTheme: IconThemeData(color: text),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: text),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none, color: text),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: card,
        child: Column(
          children: [
            DrawerHeader(
              child: Icon(Icons.apps, size: 64, color: text),
            ),
            _drawerItem(
              icon: Icons.forum,
              text: "論壇",
              textColor: text,
              page: ForumPage(),
            ),
            _drawerItem(
              icon: Icons.chat,
              text: "聊天",
              textColor: text,
              page: ChatPage(),
            ),
            _drawerItem(
              icon: Icons.compare_arrows,
              text: "配對",
              textColor: text,
              page: PairingPage(),
            ),
            _drawerItem(
              icon: Icons.map,
              text: "寵物地圖",
              textColor: text,
              page: MapPage(),
            ),
            _drawerItem(
              icon: Icons.account_circle,
              text: "帳號",
              textColor: text,
              page: LoginPage(),
            ),
            _drawerItem(
              icon: Icons.settings,
              text: "設定",
              textColor: text,
              page: SettingPage(),
            ),
            const Spacer(),
            SwitchListTile(
              value: isDark,
              onChanged: (v) => setState(() => isDark = v),
              activeColor: primary,
              title: Text('Dark Mode', style: TextStyle(color: text)),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            color: card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(post['image']!, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post['caption']!, style: TextStyle(color: text, fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(post['avatar']!),
                            radius: 14,
                          ),
                          const SizedBox(width: 8),
                          Text(post['user']!, style: TextStyle(color: subtle, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}

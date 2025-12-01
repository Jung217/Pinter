import 'package:flutter/material.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = [
      {"title": "General Discussion", "icon": Icons.chat, "color": Colors.blue},
      {"title": "Health & Nutrition", "icon": Icons.local_hospital, "color": Colors.red},
      {"title": "Training & Behavior", "icon": Icons.pets, "color": Colors.orange},
      {"title": "Adoption & Rescue", "icon": Icons.favorite, "color": Colors.pink},
      {"title": "Events & Meetups", "icon": Icons.event, "color": Colors.green},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (topic['color'] as Color).withOpacity(0.2),
                child: Icon(topic['icon'], color: topic['color']),
              ),
              title: Text(
                topic['title'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Navigate to topic details
              },
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chats = [
      {
        "name": "Alice",
        "message": "Hey! How is your dog doing?",
        "time": "10:30 AM",
        "avatar": "https://i.pravatar.cc/150?u=alice"
      },
      {
        "name": "Bob",
        "message": "Can we meet at the park tomorrow?",
        "time": "09:15 AM",
        "avatar": "https://i.pravatar.cc/150?u=bob"
      },
      {
        "name": "Charlie",
        "message": "Thanks for the tips!",
        "time": "Yesterday",
        "avatar": "https://i.pravatar.cc/150?u=charlie"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
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
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat['avatar']!),
            ),
            title: Text(
              chat['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              chat['message']!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              chat['time']!,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              // Navigate to chat detail
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:mypinter/pages/chatRoomPage.dart';
import 'package:mypinter/pages/selectContactsPage.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> chats = [
      {
        "name": "Alice",
        "message": "Hey! How is your dog doing?",
        "time": "10:30 AM",
        "avatar": "https://i.pravatar.cc/150?u=alice",
        "unread": 2,
        "isOnline": true,
      },
      {
        "name": "Bob",
        "message": "Can we meet at the park tomorrow?",
        "time": "09:15 AM",
        "avatar": "https://i.pravatar.cc/150?u=bob",
        "unread": 0,
        "isOnline": false,
      },
      {
        "name": "Charlie",
        "message": "Thanks for the tips!",
        "time": "Yesterday",
        "avatar": "https://i.pravatar.cc/150?u=charlie",
        "unread": 0,
        "isOnline": true,
      },
      {
        "name": "Diana",
        "message": "See you at the vet!",
        "time": "Yesterday",
        "avatar": "https://i.pravatar.cc/150?u=diana",
        "unread": 5,
        "isOnline": false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_square),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          final hasUnread = (chat['unread'] as int) > 0;
          final isOnline = chat['isOnline'] as bool;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomPage(
                    contactName: chat['name'],
                    contactAvatar: chat['avatar'],
                    isOnline: isOnline,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Avatar with online indicator
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(chat['avatar']!),
                      ),
                      if (isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Message content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              chat['name']!,
                              style: TextStyle(
                                fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                                fontSize: 16,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              chat['time']!,
                              style: TextStyle(
                                color: hasUnread ? colorScheme.primary : colorScheme.secondary,
                                fontSize: 12,
                                fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                chat['message']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: hasUnread 
                                      ? colorScheme.onSurface 
                                      : colorScheme.secondary,
                                  fontSize: 14,
                                  fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (hasUnread)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${chat['unread']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      child: Icon(Icons.group_add, color: colorScheme.primary),
                    ),
                    title: const Text('New Group', style: TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SelectContactsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      child: Icon(Icons.person_add, color: colorScheme.primary),
                    ),
                    title: const Text('New Chat', style: TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to contact selection for direct chat
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }
}
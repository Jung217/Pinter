import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final String contactName;
  final String contactAvatar;
  final bool isOnline;
  final bool isGroup;
  final List<String>? groupMembers;

  const ChatRoomPage({
    super.key,
    required this.contactName,
    required this.contactAvatar,
    required this.isOnline,
    this.isGroup = false,
    this.groupMembers,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      "text": "Hey! How is your dog doing?",
      "isSender": false,
      "time": "10:25 AM",
      "senderName": "Alice",
    },
    {
      "text": "He's doing great! Just took him to the park.",
      "isSender": true,
      "time": "10:26 AM",
      "senderName": "You",
    },
    {
      "text": "That's awesome! Mine loves the park too.",
      "isSender": false,
      "time": "10:27 AM",
      "senderName": "Bob",
    },
    {
      "text": "We should arrange a playdate sometime!",
      "isSender": true,
      "time": "10:28 AM",
      "senderName": "You",
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "text": _messageController.text,
        "isSender": true,
        "time": "Now",
        "senderName": "You",
      });
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.contactAvatar),
                ),
                if (widget.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.appBarTheme.backgroundColor!,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.isOnline && !widget.isGroup)
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.secondary,
                      ),
                    ),
                  if (widget.isGroup && widget.groupMembers != null)
                    Text(
                      '${widget.groupMembers!.length} members',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.secondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSender = message['isSender'] as bool;

                return Align(
                  alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isSender
                          ? colorScheme.primary
                          : theme.cardTheme.color,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isSender ? const Radius.circular(16) : const Radius.circular(4),
                        bottomRight: isSender ? const Radius.circular(4) : const Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.isGroup && !isSender)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              message['senderName'] ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSender
                                    ? Colors.white.withOpacity(0.9)
                                    : colorScheme.primary,
                              ),
                            ),
                          ),
                        Text(
                          message['text']!,
                          style: TextStyle(
                            color: isSender ? Colors.white : colorScheme.onSurface,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message['time']!,
                          style: TextStyle(
                            color: isSender
                                ? Colors.white.withOpacity(0.7)
                                : colorScheme.secondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Message input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add_circle_outline, color: colorScheme.primary),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: colorScheme.secondary),
                        filled: true,
                        fillColor: theme.scaffoldBackgroundColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

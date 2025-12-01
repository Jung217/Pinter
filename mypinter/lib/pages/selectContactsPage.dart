import 'package:flutter/material.dart';
import 'package:mypinter/pages/newGroupPage.dart';

class SelectContactsPage extends StatefulWidget {
  const SelectContactsPage({super.key});

  @override
  State<SelectContactsPage> createState() => _SelectContactsPageState();
}

class _SelectContactsPageState extends State<SelectContactsPage> {
  final List<Map<String, dynamic>> _allContacts = [
    {"name": "Alice", "avatar": "https://i.pravatar.cc/150?u=alice", "isOnline": true},
    {"name": "Bob", "avatar": "https://i.pravatar.cc/150?u=bob", "isOnline": false},
    {"name": "Charlie", "avatar": "https://i.pravatar.cc/150?u=charlie", "isOnline": true},
    {"name": "Diana", "avatar": "https://i.pravatar.cc/150?u=diana", "isOnline": false},
    {"name": "Eve", "avatar": "https://i.pravatar.cc/150?u=eve", "isOnline": true},
    {"name": "Frank", "avatar": "https://i.pravatar.cc/150?u=frank", "isOnline": false},
    {"name": "Grace", "avatar": "https://i.pravatar.cc/150?u=grace", "isOnline": true},
    {"name": "Henry", "avatar": "https://i.pravatar.cc/150?u=henry", "isOnline": false},
  ];

  final Set<String> _selectedContacts = {};
  String _searchQuery = '';

  List<Map<String, dynamic>> get _filteredContacts {
    if (_searchQuery.isEmpty) return _allContacts;
    return _allContacts
        .where((contact) => contact['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New Group', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            if (_selectedContacts.isNotEmpty)
              Text(
                '${_selectedContacts.length} selected',
                style: TextStyle(fontSize: 12, color: colorScheme.secondary),
              ),
          ],
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        actions: [
          if (_selectedContacts.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewGroupPage(
                      selectedContacts: _selectedContacts.toList(),
                      contactsData: _allContacts
                          .where((c) => _selectedContacts.contains(c['name']))
                          .toList(),
                    ),
                  ),
                );
              },
              child: Text(
                'Next',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.cardTheme.color,
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                hintStyle: TextStyle(color: colorScheme.secondary),
                prefixIcon: Icon(Icons.search, color: colorScheme.secondary),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Contacts list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                final name = contact['name']!;
                final isSelected = _selectedContacts.contains(name);
                final isOnline = contact['isOnline'] as bool;

                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedContacts.add(name);
                      } else {
                        _selectedContacts.remove(name);
                      }
                    });
                  },
                  activeColor: colorScheme.primary,
                  secondary: Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(contact['avatar']!),
                      ),
                      if (isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
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
                  title: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.secondary,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

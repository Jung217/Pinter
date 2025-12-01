import 'package:flutter/material.dart';
import 'package:mypinter/pages/chatRoomPage.dart';

class NewGroupPage extends StatefulWidget {
  final List<String> selectedContacts;
  final List<Map<String, dynamic>> contactsData;

  const NewGroupPage({
    super.key,
    required this.selectedContacts,
    required this.contactsData,
  });

  @override
  State<NewGroupPage> createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  String? _groupPhotoUrl;

  void _createGroup() {
    if (_groupNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name')),
      );
      return;
    }

    // Navigate to group chat room
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomPage(
          contactName: _groupNameController.text,
          contactAvatar: _groupPhotoUrl ?? 'https://i.pravatar.cc/150?u=group',
          isOnline: false,
          isGroup: true,
          groupMembers: widget.selectedContacts,
        ),
      ),
    );
  }

  void _selectGroupPhoto() {
    // In a real app, this would open image picker
    setState(() {
      _groupPhotoUrl = 'https://i.pravatar.cc/150?u=group${DateTime.now().millisecond}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Group', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Group photo
                  GestureDetector(
                    onTap: _selectGroupPhoto,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: colorScheme.primary.withOpacity(0.1),
                          backgroundImage: _groupPhotoUrl != null
                              ? NetworkImage(_groupPhotoUrl!)
                              : null,
                          child: _groupPhotoUrl == null
                              ? Icon(
                                  Icons.group,
                                  size: 60,
                                  color: colorScheme.primary,
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: colorScheme.primary,
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Group name input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _groupNameController,
                      decoration: InputDecoration(
                        hintText: 'Group name',
                        hintStyle: TextStyle(color: colorScheme.secondary),
                        filled: true,
                        fillColor: theme.cardTheme.color,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Members section
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: theme.cardTheme.color,
                    child: Row(
                      children: [
                        Text(
                          'Participants: ${widget.selectedContacts.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Members list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.contactsData.length,
                    itemBuilder: (context, index) {
                      final contact = widget.contactsData[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(contact['avatar']!),
                        ),
                        title: Text(
                          contact['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.close, color: colorScheme.secondary),
                          onPressed: () {
                            setState(() {
                              widget.selectedContacts.remove(contact['name']);
                              widget.contactsData.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Create button
          Container(
            padding: const EdgeInsets.all(16),
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Group',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:message_centre/settings_screen.dart';
import 'sharepoint_service.dart';
import 'message_detail_screen.dart';

class MessageListScreen extends StatefulWidget {
  final String token;

  const MessageListScreen({super.key, required this.token});

  @override
  // ignore: library_private_types_in_public_api
  _MessageListScreenState createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  final SharePointService _sharePointService = SharePointService();
  List<dynamic> _messages = [];
  String userDisplayName = 'YourUserDisplayName'; // Replace with actual user display name

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    final messages = await _sharePointService.fetchMessages(widget.token, userDisplayName);
    setState(() {
      _messages = messages;
    });
  }

  Future<void> _markAsRead(String itemId) async {
    await _sharePointService.markAsRead(widget.token, itemId);
    _fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen(token: widget.token)),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageDetailScreen(message: message),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(message['fields']['MessageTitle']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 5),
                        Text('Service User: ${message['fields']['Type']}'),
                      ],
                    ),
                    Text('Relevance: ${message['fields']['Relevance']}'),
                    Text(message['fields']['MessageBody']),
                  ],
                ),
                trailing: message['fields']['Redd'] != 'Yes'
                    ? ElevatedButton(
                        onPressed: () => _markAsRead(message['id']),
                        child: const Text('Mark as Read'),
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}

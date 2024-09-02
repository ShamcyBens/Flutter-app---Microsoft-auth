import 'package:flutter/material.dart';

class MessageDetailScreen extends StatelessWidget {
  final dynamic message;

  const MessageDetailScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['fields']['MessageTitle'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 5),
                Text('Service User: ${message['fields']['Type']}'),
              ],
            ),
            const SizedBox(height: 10),
            Text('Relevance: ${message['fields']['Relevance']}'),
            const SizedBox(height: 10),
            Text(message['fields']['MessageBody']),
          ],
        ),
      ),
    );
  }
}

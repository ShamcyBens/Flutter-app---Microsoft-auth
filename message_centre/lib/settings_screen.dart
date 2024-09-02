import 'package:flutter/material.dart';
import 'package:message_centre/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  final String token;

  const SettingsScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}

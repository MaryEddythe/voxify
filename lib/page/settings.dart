import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("Settings"),
      foregroundColor: Colors.grey,
     backgroundColor: Colors.transparent, 
     elevation: 0,
      ),
      );
  }
}
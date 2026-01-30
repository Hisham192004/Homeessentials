import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "How can we help you?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text("• Orders are delivered within 2–3 days."),
            Text("• For payment issues, contact support."),
            Text("• You can cancel orders within 24 hours."),
            SizedBox(height: 20),
            Text("Support Email: support@homeessentials.com"),
          ],
        ),
      ),
    );
  }
}

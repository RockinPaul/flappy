import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// Chat session screen.
///
/// Will show the message list, input, and tool call UIs.
class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final happy = context.happyColors;
    return Scaffold(
      appBar: AppBar(
        title: Text('Session $sessionId'),
      ),
      body: Column(
        children: [
          // Message list placeholder
          Expanded(
            child: Center(
              child: Text(
                'Chat UI — coming in Phase 5',
                style: TextStyle(color: happy.textSecondary),
              ),
            ),
          ),
          // Input area placeholder
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(color: happy.divider, width: 0.5),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle: TextStyle(color: happy.inputPlaceholder),
                        filled: true,
                        fillColor: happy.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                    style: IconButton.styleFrom(
                      backgroundColor: happy.buttonPrimaryBackground,
                      foregroundColor: happy.buttonPrimaryTint,
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
}

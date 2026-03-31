import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// Login / onboarding screen.
///
/// Will host QR-code scanning and manual secret-key restore.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final happy = context.happyColors;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.terminal_rounded,
                  size: 64,
                  color: happy.textLink,
                ),
                const SizedBox(height: 24),
                Text(
                  'Happy Coder',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: 'BricolageGrotesque',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Remote control for Claude Code',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: happy.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                // TODO: QR scanner button
                FilledButton.icon(
                  onPressed: () {
                    // TODO: Launch QR scanner
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan QR Code'),
                  style: FilledButton.styleFrom(
                    backgroundColor: happy.buttonPrimaryBackground,
                    foregroundColor: happy.buttonPrimaryTint,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to manual restore
                  },
                  child: Text(
                    'Restore with Secret Key',
                    style: TextStyle(color: happy.textLink),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

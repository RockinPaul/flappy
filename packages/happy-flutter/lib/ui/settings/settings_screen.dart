import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// Settings screen.
///
/// Will host account, appearance, language, voice, usage, and feature settings.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SettingsSection(
            title: 'General',
            children: [
              _SettingsItem(title: 'Account', icon: Icons.person_outline, onTap: () {}),
              _SettingsItem(title: 'Appearance', icon: Icons.palette_outlined, onTap: () {}),
              _SettingsItem(title: 'Language', icon: Icons.language, onTap: () {}),
            ],
          ),
          _SettingsSection(
            title: 'Features',
            children: [
              _SettingsItem(title: 'Voice', icon: Icons.mic_outlined, onTap: () {}),
              _SettingsItem(title: 'Features', icon: Icons.science_outlined, onTap: () {}),
            ],
          ),
          _SettingsSection(
            title: 'About',
            children: [
              _SettingsItem(title: 'Usage', icon: Icons.bar_chart, onTap: () {}),
              _SettingsItem(title: 'Changelog', icon: Icons.history, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final happy = context.happyColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: happy.grouppedSectionTitle,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({required this.title, required this.icon, required this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final happy = context.happyColors;
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: happy.grouppedChevron, size: 20),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

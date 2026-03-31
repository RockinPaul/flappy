import 'package:flutter/material.dart';

import '../../core/breakpoints.dart';
import '../../core/theme.dart';

/// Main home screen showing the sessions list.
///
/// Adapts to phone (bottom tabs) vs tablet (sidebar) layout
/// based on breakpoints.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final happy = context.happyColors;

    if (context.isTablet) {
      return _TabletLayout(happy: happy);
    }
    return _PhoneLayout(happy: happy);
  }
}

class _PhoneLayout extends StatelessWidget {
  const _PhoneLayout({required this.happy});
  final HappyColors happy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Happy Coder',
          style: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Text('Sessions list — coming in Phase 6'),
      ),
      // TODO: Replace with real FAB for new session
      floatingActionButton: FloatingActionButton(
        backgroundColor: happy.fabBackground,
        foregroundColor: happy.fabIcon,
        onPressed: () {
          // TODO: Navigate to new session
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.inbox_outlined), selectedIcon: Icon(Icons.inbox), label: 'Inbox'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Friends'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout({required this.happy});
  final HappyColors happy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
              NavigationRailDestination(icon: Icon(Icons.inbox_outlined), selectedIcon: Icon(Icons.inbox), label: Text('Inbox')),
              NavigationRailDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: Text('Friends')),
              NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Settings')),
            ],
            selectedIndex: 0,
            onDestinationSelected: (_) {},
          ),
          const VerticalDivider(width: 1),
          // Content area
          const Expanded(
            child: Center(
              child: Text('Sessions list — coming in Phase 6'),
            ),
          ),
        ],
      ),
    );
  }
}

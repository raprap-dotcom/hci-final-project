import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  final List<GlobalKey>? navItemKeys;

  const MyBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    this.navItemKeys,
  });

  GlobalKey? _navItemKey(int index) {
    if (navItemKeys == null || index >= navItemKeys!.length) {
      return null;
    }
    return navItemKeys![index];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: GNav(
            gap: 6,
            activeColor: Theme.of(context).colorScheme.onPrimary,
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.7),
            tabBackgroundColor: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.28),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            tabs: [
              GButton(
                key: _navItemKey(0),
                icon: Icons.home_rounded,
                text: 'Home',
                onPressed: () => onTabChange(0),
              ),
              GButton(
                key: _navItemKey(1),
                icon: Icons.show_chart_rounded,
                text: 'Progress',
                onPressed: () => onTabChange(1),
              ),
              GButton(
                key: _navItemKey(2),
                icon: Icons.menu_book_rounded,
                text: 'Subjects',
                onPressed: () => onTabChange(2),
              ),
              GButton(
                key: _navItemKey(3),
                icon: Icons.task_alt_rounded,
                text: 'Quests',
                onPressed: () => onTabChange(3),
              ),
              GButton(
                key: _navItemKey(4),
                icon: Icons.person_rounded,
                text: 'Profile',
                onPressed: () => onTabChange(4),
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}

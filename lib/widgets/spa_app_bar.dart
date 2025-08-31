import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:routine_planner/services/auth_service.dart';
import 'package:routine_planner/screens/settings_screen.dart';

class SpaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const SpaAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1F2937),
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        ...?actions,
        const SizedBox(width: 8),
        StreamBuilder<User?>(
          stream: authService.user,
          builder: (context, snapshot) {
            final user = snapshot.data;
            return PopupMenuButton<String>(
              offset: const Offset(0, 40),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEDE9FE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF4F46E5),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user?.displayName ?? user?.email?.split('@').first ?? 'User',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Color(0xFF6B7280),
                    ),
                  ],
                ),
              ),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, size: 18, color: Color(0xFF6B7280)),
                      SizedBox(width: 12),
                      Text('Profile'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings_outlined, size: 18, color: Color(0xFF6B7280)),
                      SizedBox(width: 12),
                      Text('Settings'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 18, color: Color(0xFFEF4444)),
                      SizedBox(width: 12),
                      Text(
                        'Sign Out',
                        style: TextStyle(color: Color(0xFFEF4444)),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (String value) async {
                switch (value) {
                  case 'profile':
                    // TODO: Implement profile screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile feature coming soon!')),
                    );
                    break;
                  case 'settings':
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                    break;
                  case 'logout':
                    await authService.signOut();
                    break;
                }
              },
            );
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
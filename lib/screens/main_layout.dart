import 'package:flutter/material.dart';
import 'package:routine_planner/widgets/sidebar.dart';
import 'package:routine_planner/screens/dashboard_screen.dart';
import 'package:routine_planner/screens/routines_screen.dart';
import 'package:routine_planner/screens/events_screen.dart';
import 'package:routine_planner/screens/statistics_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = const [
    DashboardScreen(),
    RoutinesScreen(),
    EventsScreen(),
    StatisticsScreen(),
  ];

  final List<String> _screenTitles = const [
    'Dashboard',
    'Routines',
    'Events',
    'Statistics',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Row(
        children: [
          // Sidebar
          SizedBox(
            width: 256,
            child: Sidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Navigation Bar
                Container(
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _screenTitles[_selectedIndex],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Notifications Button
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Color(0xFF6B7280),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Settings Button
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: Color(0xFF6B7280),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Screen Content
                Expanded(
                  child: _screens[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
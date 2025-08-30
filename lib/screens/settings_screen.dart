import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:routine_planner/services/auth_service.dart';
import 'package:routine_planner/models/user_preferences.dart';
import 'package:routine_planner/models/app_locale.dart';
import 'package:routine_planner/models/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserPreferences? _userPreferences;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('preferences')
          .doc('main')
          .get();

      if (doc.exists) {
        setState(() {
          _userPreferences = UserPreferences.fromFirestore(doc, null);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePreferences(UserPreferences updatedPreferences) async {
    setState(() {
      _isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('preferences')
          .doc('main')
          .update(updatedPreferences.copyWith(
            updatedAt: Timestamp.now(),
          ).toFirestore());

      setState(() {
        _userPreferences = updatedPreferences.copyWith(
          updatedAt: Timestamp.now(),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings updated successfully!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating settings: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 0,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userPreferences == null
              ? const Center(child: Text('No preferences found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account Section
                      _buildSectionTitle('Account'),
                      _buildAccountCard(authService),
                      const SizedBox(height: 32),

                      // Appearance Section
                      _buildSectionTitle('Appearance'),
                      _buildLanguageCard(),
                      const SizedBox(height: 16),
                      _buildThemeCard(),
                      const SizedBox(height: 16),
                      _buildInterfaceCard(),
                      const SizedBox(height: 32),

                      // Notifications Section
                      _buildSectionTitle('Notifications'),
                      _buildNotificationsCard(),
                      const SizedBox(height: 32),

                      // About Section
                      _buildSectionTitle('About'),
                      _buildAboutCard(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildAccountCard(AuthService authService) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFEDE9FE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFF4F46E5),
                size: 24,
              ),
            ),
            title: Text(
              user?.displayName ?? user?.email?.split('@').first ?? 'User',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(user?.email ?? ''),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFEF4444)),
            title: const Text(
              'Sign Out',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard() {
    final currentLocale = _userPreferences!.locale;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListTile(
        leading: Text(
          currentLocale.flag,
          style: const TextStyle(fontSize: 24),
        ),
        title: const Text(
          'Language',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(currentLocale.nativeName),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showLanguageDialog(),
      ),
    );
  }

  Widget _buildThemeCard() {
    final currentTheme = _userPreferences!.theme;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [currentTheme.primaryColor, currentTheme.secondaryColor],
            ),
          ),
        ),
        title: const Text(
          'Theme',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(currentTheme.name),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showThemeDialog(),
      ),
    );
  }

  Widget _buildInterfaceCard() {
    final interfaceName = _userPreferences!.preferredInterface == PreferredInterface.taskManagement
        ? 'Task Management'
        : 'Calendar View';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListTile(
        leading: Icon(
          _userPreferences!.preferredInterface == PreferredInterface.taskManagement
              ? Icons.checklist
              : Icons.calendar_today,
          color: const Color(0xFF4F46E5),
        ),
        title: const Text(
          'Preferred Interface',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(interfaceName),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showInterfaceDialog(),
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: SwitchListTile(
        secondary: const Icon(
          Icons.notifications,
          color: Color(0xFF4F46E5),
        ),
        title: const Text(
          'Enable Notifications',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: const Text('Get reminders for your routines and tasks'),
        value: _userPreferences!.enableNotifications,
        activeColor: const Color(0xFF4F46E5),
        onChanged: (value) {
          _updatePreferences(
            _userPreferences!.copyWith(enableNotifications: value),
          );
        },
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info, color: Color(0xFF4F46E5)),
            title: const Text('About RoutinePlanner'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {
              // Show about dialog
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Color(0xFF4F46E5)),
            title: const Text('Privacy Policy'),
            onTap: () {
              // Open privacy policy
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help, color: Color(0xFF4F46E5)),
            title: const Text('Help & Support'),
            onTap: () {
              // Open help screen
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppLocale.supportedLocales.length,
            itemBuilder: (context, index) {
              final locale = AppLocale.supportedLocales[index];
              final isSelected = _userPreferences!.locale == locale;
              
              return ListTile(
                leading: Text(locale.flag, style: const TextStyle(fontSize: 24)),
                title: Text(locale.nativeName),
                subtitle: Text(locale.englishName),
                trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF4F46E5)) : null,
                onTap: () {
                  Navigator.of(context).pop();
                  _updatePreferences(
                    _userPreferences!.copyWith(
                      languageCode: locale.languageCode,
                      countryCode: locale.countryCode,
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: AppTheme.getAllThemes().length,
            itemBuilder: (context, index) {
              final theme = AppTheme.getAllThemes()[index];
              final isSelected = _userPreferences!.selectedTheme == theme.type;
              
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  _updatePreferences(
                    _userPreferences!.copyWith(selectedTheme: theme.type),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? theme.primaryColor : const Color(0xFFE5E7EB),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [theme.primaryColor, theme.secondaryColor],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          theme.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isSelected ? theme.primaryColor : null,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.check,
                            color: theme.primaryColor,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showInterfaceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Interface'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.checklist, color: Color(0xFF10B981)),
              title: const Text('Task Management'),
              subtitle: const Text('Focus on individual tasks with lists and priorities'),
              trailing: _userPreferences!.preferredInterface == PreferredInterface.taskManagement
                  ? const Icon(Icons.check, color: Color(0xFF4F46E5))
                  : null,
              onTap: () {
                Navigator.of(context).pop();
                _updatePreferences(
                  _userPreferences!.copyWith(preferredInterface: PreferredInterface.taskManagement),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF3B82F6)),
              title: const Text('Calendar View'),
              subtitle: const Text('Visual calendar interface with time-based scheduling'),
              trailing: _userPreferences!.preferredInterface == PreferredInterface.calendarView
                  ? const Icon(Icons.check, color: Color(0xFF4F46E5))
                  : null,
              onTap: () {
                Navigator.of(context).pop();
                _updatePreferences(
                  _userPreferences!.copyWith(preferredInterface: PreferredInterface.calendarView),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
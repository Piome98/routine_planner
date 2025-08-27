import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:routine_planner/services/auth_service.dart';
import 'package:routine_planner/services/firestore_service.dart';
import 'package:routine_planner/models/routine.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final firestoreService = FirestoreService();
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 64,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.event_note,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'RoutinePlanner',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Navigation Section
                  const Text(
                    'NAVIGATION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildNavItem(0, Icons.dashboard_outlined, 'Dashboard'),
                  _buildNavItem(1, Icons.checklist, 'Routines'),
                  _buildNavItem(2, Icons.event, 'Events'),
                  _buildNavItem(3, Icons.analytics_outlined, 'Statistics'),
                  
                  const SizedBox(height: 24),
                  
                  // My Routines Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'MY ROUTINES',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                          letterSpacing: 1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showAddRoutineDialog(context),
                        child: const Icon(
                          Icons.add,
                          size: 16,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Routines List
                  Expanded(
                    child: StreamBuilder<List<Routine>>(
                      stream: firestoreService.getRoutines(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final routines = snapshot.data!;
                          return ListView.builder(
                            itemCount: routines.length,
                            itemBuilder: (context, index) {
                              final routine = routines[index];
                              return _buildRoutineItem(routine);
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // User Profile Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            child: StreamBuilder<User?>(
              stream: authService.user,
              builder: (context, snapshot) {
                final user = snapshot.data;
                return Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF4F46E5),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? user?.email?.split('@').first ?? 'User',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F2937),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await authService.signOut();
                      },
                      child: const Icon(
                        Icons.logout,
                        color: Color(0xFF6B7280),
                        size: 20,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEDE9FE) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineItem(Routine routine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(
            routine.isActive ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: routine.isActive ? const Color(0xFF10B981) : const Color(0xFF9CA3AF),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  routine.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  routine.frequency.join(', '),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddRoutineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _AddRoutineDialog(),
    );
  }
}

class _AddRoutineDialog extends StatefulWidget {
  const _AddRoutineDialog();

  @override
  _AddRoutineDialogState createState() => _AddRoutineDialogState();
}

class _AddRoutineDialogState extends State<_AddRoutineDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  List<String> _selectedFrequency = ['Daily'];
  bool _isLoading = false;

  final List<String> _frequencyOptions = const [
    'Daily',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Add New Routine',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Routine Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Routine Name',
                    hintText: 'e.g. Morning Routine',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a routine name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Brief description of your routine',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                
                // Time Fields
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _startTimeController,
                        decoration: InputDecoration(
                          labelText: 'Start Time',
                          hintText: '08:00',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter start time';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _endTimeController,
                        decoration: InputDecoration(
                          labelText: 'End Time (Optional)',
                          hintText: '09:00',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Frequency
                const Text(
                  'Frequency',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _frequencyOptions.map((frequency) {
                    final isSelected = _selectedFrequency.contains(frequency);
                    return FilterChip(
                      label: Text(frequency),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (frequency == 'Daily') {
                            if (selected) {
                              _selectedFrequency = ['Daily'];
                            } else {
                              _selectedFrequency.remove('Daily');
                            }
                          } else {
                            if (selected) {
                              _selectedFrequency.remove('Daily');
                              _selectedFrequency.add(frequency);
                            } else {
                              _selectedFrequency.remove(frequency);
                            }
                          }
                          
                          if (_selectedFrequency.isEmpty) {
                            _selectedFrequency = ['Daily'];
                          }
                        });
                      },
                      selectedColor: const Color(0xFF4F46E5).withAlpha((255 * 0.2).round()),
                      checkmarkColor: const Color(0xFF4F46E5),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveRoutine,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Save Routine'),
        ),
      ],
    );
  }

  void _saveRoutine() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final firestoreService = FirestoreService();
      final routine = Routine(
        userId: FirebaseAuth.instance.currentUser!.uid,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        frequency: _selectedFrequency,
        startTime: _startTimeController.text.trim(),
        endTime: _endTimeController.text.trim().isEmpty 
            ? null 
            : _endTimeController.text.trim(),
        isActive: true,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );
      
      await firestoreService.addRoutine(routine);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Routine created successfully!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating routine: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routine_planner/models/routine_set.dart';
import 'package:routine_planner/services/firestore_service.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: StreamBuilder<List<RoutineSet>>(
        stream: firestoreService.getRoutineSets(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final routineSets = snapshot.data ?? [];

          return Column(
            children: [
              SizedBox(
                height: 400,
                child: PageView.builder(
                  itemCount: routineSets.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final routineSet = routineSets[index];
                    return RoutineSetCard(routineSet: routineSet);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(routineSets.length, (index) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.blue : Colors.grey,
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create routine set screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RoutineSetCard extends StatelessWidget {
  final RoutineSet routineSet;

  const RoutineSetCard({super.key, required this.routineSet});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              routineSet.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: routineSet.routines.length,
                itemBuilder: (context, index) {
                  final routine = routineSet.routines[index];
                  return ListTile(
                    title: Text(routine.name),
                    subtitle: Text(routine.description ?? ''),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Set as active routine
              },
              child: const Text('Set as Active'),
            ),
          ],
        ),
      ),
    );
  }
}
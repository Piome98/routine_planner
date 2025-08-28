import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:routine_planner/models/event.dart';
import 'package:routine_planner/models/routine.dart';
import 'package:routine_planner/services/firestore_service.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getStatisticsData(firestoreService),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final statisticsData = snapshot.data ?? {};
          final routineCompletionData = statisticsData['routineCompletion'] as Map<String, double>? ?? {};
          final eventsPerWeekData = statisticsData['eventsPerWeek'] as List<double>? ?? [];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Routine Completion',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            value: routineCompletionData['completed'] ?? 0,
                            title: '${(routineCompletionData['completed'] ?? 0).toStringAsFixed(0)}%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            value: routineCompletionData['missed'] ?? 0,
                            title: '${(routineCompletionData['missed'] ?? 0).toStringAsFixed(0)}%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Events per Week',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 20,
                        barGroups: List.generate(eventsPerWeekData.length, (index) {
                          return BarChartGroupData(x: index, barRods: [BarChartRodData(toY: eventsPerWeekData[index], color: Colors.blue)]);
                        }),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const style = TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
                                Widget text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = const Text('M', style: style);
                                    break;
                                  case 1:
                                    text = const Text('T', style: style);
                                    break;
                                  case 2:
                                    text = const Text('W', style: style);
                                    break;
                                  case 3:
                                    text = const Text('T', style: style);
                                    break;
                                  case 4:
                                    text = const Text('F', style: style);
                                    break;
                                  case 5:
                                    text = const Text('S', style: style);
                                    break;
                                  case 6:
                                    text = const Text('S', style: style);
                                    break;
                                  default:
                                    text = const Text('', style: style);
                                    break;
                                }
                                return SideTitleWidget(axisSide: meta.axisSide, child: text);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getStatisticsData(FirestoreService firestoreService) async {
    final routines = await firestoreService.getRoutines().first;
    final events = await firestoreService.getEvents().first;

    // Calculate routine completion
    final completedRoutines = routines.where((routine) => routine.isActive).length;
    final totalRoutines = routines.length;
    final routineCompletion = totalRoutines > 0 ? (completedRoutines / totalRoutines) * 100 : 0.0;

    // Calculate events per week
    final eventsPerWeek = List.filled(7, 0.0);
    for (final event in events) {
      final dayOfWeek = event.dateTime.toDate().weekday - 1;
      eventsPerWeek[dayOfWeek]++;
    }

    return {
      'routineCompletion': {
        'completed': routineCompletion,
        'missed': 100 - routineCompletion,
      },
      'eventsPerWeek': eventsPerWeek,
    };
  }
}
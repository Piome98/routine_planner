import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routine_planner/models/task.dart';
import 'package:routine_planner/services/firestore_service.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPersistentHeader(
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.grey[400],
                indicator: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.blue.shade600, width: 2)),
                ),
                tabs: const [
                  Tab(text: '오늘 할 일'),
                  Tab(text: '내 루틴'),
                ],
              ),
            ),
            pinned: true,
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTodaysTasks(),
                _buildMyRoutines(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      expandedHeight: 120,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Text(
          'O:NEAT',
          style: TextStyle(
            color: Colors.blue.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        background: const Padding(
          padding: EdgeInsets.only(top: 60, left: 20),
          child: Text(
            '세상의 모든 루틴을 기록',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {},
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysTasks() {
    final firestoreService = Provider.of<FirestoreService>(context);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return StreamBuilder<List<Task>>(
      stream: firestoreService.getAllTasksForCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final tasks = snapshot.data ?? [];
        final todaysTasks = tasks.where((task) => task.isCompleted.containsKey(today) || !task.isCompleted.containsValue(true)).toList();

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: todaysTasks.length,
                  itemBuilder: (context, index) {
                    final task = todaysTasks[index];
                    final isCompleted = task.isCompleted[today] ?? false;
                    return _buildTaskCard(task, isCompleted);
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('새 이벤트 추가', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyRoutines() {
    return const Center(
      child: Text('내 루틴'),
    );
  }

  Widget _buildTaskCard(Task task, bool isCompleted) {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((255 * 0.1).round()),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: isCompleted,
            onChanged: (value) async {
              if (value != null) {
                final updatedIsCompleted = Map<String, bool>.from(task.isCompleted);
                updatedIsCompleted[today] = value;
                final updatedTask = task.copyWith(isCompleted: updatedIsCompleted);
                await firestoreService.updateTask(task.routineId, updatedTask);
              }
            },
            shape: const CircleBorder(),
            activeColor: Colors.blue.shade600,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    task.durationMinutes != null ? '${task.durationMinutes}분' : '시간 미정',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getPriorityColor(task.priority).withAlpha((255 * 0.1).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              task.priority,
              style: TextStyle(color: _getPriorityColor(task.priority), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case '높음':
        return Colors.red.shade400;
      case '보통':
        return Colors.orange.shade400;
      case '낮음':
        return Colors.blue.shade400;
      default:
        return Colors.grey;
    }
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
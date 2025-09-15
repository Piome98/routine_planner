import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:routine_planner/models/challenge.dart';
import 'package:routine_planner/services/firestore_service.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen>
    with SingleTickerProviderStateMixin {
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
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildLeaderboardSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.blue.shade600,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.blue.shade600,
                tabs: const [
                  Tab(text: '참여 중 (1)'),
                  Tab(text: '전체 챌린지'),
                ],
              ),
            ),
            pinned: true,
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChallengesList(participating: true),
                _buildChallengesList(participating: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    return SliverAppBar(
      backgroundColor: Colors.grey[50],
      expandedHeight: 120,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: const Text(
          '챌린지',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Padding(
          padding: const EdgeInsets.only(top: 60, left: 20),
          child: Text(
            '함께 성장하는 챌린지 커뮤니티',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
      ),
      actions: [
        FutureBuilder<int>(
          future: firestoreService.getUserPoints(),
          builder: (context, snapshot) {
            final userPoints = snapshot.data ?? 0;
            return Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.orange[600], size: 18),
                  const SizedBox(width: 4),
                  Text(
                    userPoints.toString(),
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.blue.shade600,
            heroTag: 'challenge_fab',
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardSection() {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber[600], size: 20),
              const SizedBox(width: 8),
              const Text(
                '이주의 랭킹',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          StreamBuilder<List<LeaderboardUser>>(
            stream: firestoreService.getLeaderboard(limit: 3),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('랭킹을 불러올 수 없습니다'));
              }
              final users = snapshot.data ?? [];
              if (users.isEmpty) {
                return const Center(child: Text('아직 랭킹 데이터가 없습니다'));
              }
              return Column(
                children: users
                    .asMap()
                    .entries
                    .map((entry) =>
                        _buildLeaderboardItem(entry.value, entry.key + 1))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(LeaderboardUser user, int rank) {
    final rankData = _getRankData(rank);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rankData.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(rankData.icon, color: rankData.color, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundColor: user.color,
            child: Text(
              user.avatar,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '완료 ${user.completedChallenges}개',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.orange[600], size: 14),
                const SizedBox(width: 4),
                Text(
                  user.points.toString(),
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesList({required bool participating}) {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    // This is a mock implementation. Replace with actual filtering logic.
    final stream = participating
        ? firestoreService.getChallenges()
        : firestoreService.getChallenges();

    return StreamBuilder<List<ChallengeData>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('챌린지를 불러올 수 없습니다'));
        }
        final challenges = snapshot.data ?? [];
        if (challenges.isEmpty) {
          return const Center(child: Text('해당하는 챌린지가 없습니다'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            return _buildChallengeCard(challenges[index]);
          },
        );
      },
    );
  }

  Widget _buildChallengeCard(ChallengeData challenge) {
    final progress = challenge.maxProgress > 0
        ? (challenge.progress / challenge.maxProgress)
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                challenge.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  challenge.difficultyText,
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            challenge.description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.blue.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.people_alt_outlined, color: Colors.grey[500], size: 16),
              const SizedBox(width: 4),
              Text(
                '${challenge.participants}명',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 12),
              Icon(Icons.av_timer, color: Colors.grey[500], size: 16),
              const SizedBox(width: 4),
              Text(
                '${challenge.daysLeft}일 남음',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const Spacer(),
              Icon(Icons.star, color: Colors.orange[600], size: 16),
              const SizedBox(width: 4),
              Text(
                '${challenge.points}P',
                style: TextStyle(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chat_bubble_outline, color: Colors.grey[500], size: 16),
            ],
          ),
        ],
      ),
    );
  }

  _RankData _getRankData(int rank) {
    switch (rank) {
      case 1:
        return _RankData(
          icon: Icons.emoji_events,
          color: Colors.amber[700]!,
          backgroundColor: Colors.amber[100]!,
        );
      case 2:
        return _RankData(
          icon: Icons.emoji_events,
          color: Colors.grey[600]!,
          backgroundColor: Colors.grey[200]!,
        );
      case 3:
        return _RankData(
          icon: Icons.emoji_events,
          color: Colors.brown[600]!,
          backgroundColor: Colors.brown[100]!,
        );
      default:
        return _RankData(
          icon: Icons.star_border,
          color: Colors.grey[500]!,
          backgroundColor: Colors.grey[100]!,
        );
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
      color: Colors.grey[50],
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

class _RankData {
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  _RankData({
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });
}
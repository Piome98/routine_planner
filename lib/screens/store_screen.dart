import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:routine_planner/models/store_item.dart';
import 'package:routine_planner/services/firestore_service.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin {
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
          SliverPersistentHeader(
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.grey[600],
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                tabs: const [
                  Tab(text: '상품'),
                  Tab(text: '주문내역'),
                ],
              ),
            ),
            pinned: true,
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStoreItemsList(),
                _buildOrderHistoryList(),
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
          '스토어',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Padding(
          padding: const EdgeInsets.only(top: 60, left: 20),
          child: Text(
            '포인트로 구매하는 건강한 쇼핑',
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
              margin: const EdgeInsets.only(right: 20),
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
      ],
    );
  }

  Widget _buildStoreItemsList() {
    // Using mock data for UI representation
    final List<StoreItem> items = [
      StoreItem(
        id: '1',
        name: '프리미엄 물병',
        description: '친환경 스테인리스 스틸 물병, 보온/보냉 기능',
        price: 500,
        category: '건강용품',
        tag: '완료',
        dateRange: '2025-09-01 ~ 2025-09-15',
        progress: 100,
        maxProgress: 100,
        maxReward: 50,
        status: '완료',
      ),
      StoreItem(
        id: '2',
        name: '요가 매트',
        description: '고급 NBR 소재, 두께 10mm',
        price: 800,
        category: '운동용품',
        tag: '모집중',
        dateRange: '2025-09-05 ~ 2025-09-20',
        progress: 42,
        maxProgress: 50,
        maxReward: 30,
        status: '모집중',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildStoreItemCard(items[index]);
      },
    );
  }

  Widget _buildOrderHistoryList() {
    return const Center(
      child: Text('주문 내역이 없습니다.'),
    );
  }

  Widget _buildStoreItemCard(StoreItem item) {
    final bool isCompleted = item.status == '완료';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.inventory_2_outlined, color: Colors.grey[400]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? Colors.orange[100]
                                : Colors.green[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.tag,
                            style: TextStyle(
                              color: isCompleted
                                  ? Colors.orange[700]
                                  : Colors.green[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange[600], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${item.price}P',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.category,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDateInfo('시작', item.dateRange.split(' ~ ')[0]),
              const SizedBox(width: 16),
              _buildDateInfo('종료', item.dateRange.split(' ~ ')[1]),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('모집 현황', style: TextStyle(fontSize: 13)),
                  Text(
                    '${item.progress}/${item.maxProgress}개',
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: item.progress / item.maxProgress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                '최소 목표: ${item.maxReward}개',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isCompleted ? null : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? Colors.grey[300] : Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isCompleted ? '참여 불가' : '구독하고 참여',
                style: TextStyle(
                  color: isCompleted ? Colors.grey[600] : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(String title, String date) {
    return Row(
      children: [
        Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 6),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(width: 6),
        Text(date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

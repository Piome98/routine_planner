import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardUser {
  final String id;
  final int rank;
  final String name;
  final int points;
  final int completedChallenges;
  final String avatar;
  final Color color;
  final String? profileImageUrl;
  final DateTime? lastActive;

  LeaderboardUser({
    required this.id,
    required this.rank,
    required this.name,
    required this.points,
    required this.completedChallenges,
    required this.avatar,
    required this.color,
    this.profileImageUrl,
    this.lastActive,
  });

  factory LeaderboardUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return LeaderboardUser(
      id: snapshot.id,
      rank: data?['rank'] ?? 0,
      name: data?['name'] ?? '',
      points: data?['points'] ?? 0,
      completedChallenges: data?['completedChallenges'] ?? 0,
      avatar: data?['avatar'] ?? '',
      color: Color(data?['colorValue'] ?? Colors.blue.value),
      profileImageUrl: data?['profileImageUrl'],
      lastActive: data?['lastActive']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'rank': rank,
      'name': name,
      'points': points,
      'completedChallenges': completedChallenges,
      'avatar': avatar,
      'colorValue': color.value,
      'profileImageUrl': profileImageUrl,
      'lastActive': lastActive != null ? Timestamp.fromDate(lastActive!) : null,
    };
  }

  // 순위에 따른 아이콘과 색상 가져오기
  IconData get rankIcon {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.workspace_premium;
      case 3:
        return Icons.military_tech;
      default:
        return Icons.circle;
    }
  }

  Color get rankColor {
    switch (rank) {
      case 1:
        return Colors.amber.shade600;
      case 2:
        return Colors.grey.shade600;
      case 3:
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade400;
    }
  }

  bool get isTopThree => rank <= 3;

  LeaderboardUser copyWith({
    String? id,
    int? rank,
    String? name,
    int? points,
    int? completedChallenges,
    String? avatar,
    Color? color,
    String? profileImageUrl,
    DateTime? lastActive,
  }) {
    return LeaderboardUser(
      id: id ?? this.id,
      rank: rank ?? this.rank,
      name: name ?? this.name,
      points: points ?? this.points,
      completedChallenges: completedChallenges ?? this.completedChallenges,
      avatar: avatar ?? this.avatar,
      color: color ?? this.color,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}

enum ChallengeType {
  health,
  fitness,
  productivity,
  social,
  education,
  personal,
}

enum ChallengeStatus {
  upcoming,
  active,
  completed,
  cancelled,
}

enum ChallengeDifficulty {
  easy,
  medium,
  hard,
  expert,
}

class ChallengeData {
  final String id;
  final String name;
  final String description;
  final int progress;
  final int maxProgress;
  final int points;
  final double completionRate;
  final int participants;
  final int daysLeft;
  final ChallengeType type;
  final ChallengeStatus status;
  final ChallengeDifficulty difficulty;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final String? createdBy;
  final List<String> tags;
  final Map<String, dynamic>? requirements;
  final bool isActive;

  ChallengeData({
    required this.id,
    required this.name,
    required this.description,
    required this.progress,
    required this.maxProgress,
    required this.points,
    required this.completionRate,
    required this.participants,
    required this.daysLeft,
    required this.type,
    required this.status,
    required this.difficulty,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.createdBy,
    this.tags = const [],
    this.requirements,
    this.isActive = true,
  });

  factory ChallengeData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ChallengeData(
      id: snapshot.id,
      name: data?['name'] ?? '',
      description: data?['description'] ?? '',
      progress: data?['progress'] ?? 0,
      maxProgress: data?['maxProgress'] ?? 0,
      points: data?['points'] ?? 0,
      completionRate: (data?['completionRate'] ?? 0.0).toDouble(),
      participants: data?['participants'] ?? 0,
      daysLeft: data?['daysLeft'] ?? 0,
      type: ChallengeType.values.firstWhere(
        (e) => e.toString() == 'ChallengeType.${data?['type']}',
        orElse: () => ChallengeType.personal,
      ),
      status: ChallengeStatus.values.firstWhere(
        (e) => e.toString() == 'ChallengeStatus.${data?['status']}',
        orElse: () => ChallengeStatus.upcoming,
      ),
      difficulty: ChallengeDifficulty.values.firstWhere(
        (e) => e.toString() == 'ChallengeDifficulty.${data?['difficulty']}',
        orElse: () => ChallengeDifficulty.easy,
      ),
      startDate: data?['startDate']?.toDate(),
      endDate: data?['endDate']?.toDate(),
      createdAt: data?['createdAt']?.toDate(),
      createdBy: data?['createdBy'],
      tags: List<String>.from(data?['tags'] ?? []),
      requirements: data?['requirements'],
      isActive: data?['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'progress': progress,
      'maxProgress': maxProgress,
      'points': points,
      'completionRate': completionRate,
      'participants': participants,
      'daysLeft': daysLeft,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'createdBy': createdBy,
      'tags': tags,
      'requirements': requirements,
      'isActive': isActive,
    };
  }

  // 편의 메서드들
  String get difficultyText {
    switch (difficulty) {
      case ChallengeDifficulty.easy:
        return '쉬움';
      case ChallengeDifficulty.medium:
        return '보통';
      case ChallengeDifficulty.hard:
        return '어려움';
      case ChallengeDifficulty.expert:
        return '전문가';
    }
  }

  String get statusText {
    switch (status) {
      case ChallengeStatus.upcoming:
        return '예정';
      case ChallengeStatus.active:
        return '진행중';
      case ChallengeStatus.completed:
        return '완료';
      case ChallengeStatus.cancelled:
        return '취소';
    }
  }

  String get typeText {
    switch (type) {
      case ChallengeType.health:
        return '건강';
      case ChallengeType.fitness:
        return '운동';
      case ChallengeType.productivity:
        return '생산성';
      case ChallengeType.social:
        return '소셜';
      case ChallengeType.education:
        return '교육';
      case ChallengeType.personal:
        return '개인';
    }
  }

  MaterialColor get difficultyColor {
    switch (difficulty) {
      case ChallengeDifficulty.easy:
        return Colors.green;
      case ChallengeDifficulty.medium:
        return Colors.orange;
      case ChallengeDifficulty.hard:
        return Colors.red;
      case ChallengeDifficulty.expert:
        return Colors.purple;
    }
  }

  bool get isChallengeActive => status == ChallengeStatus.active;
  bool get isCompleted => status == ChallengeStatus.completed;
  bool get canJoin => status == ChallengeStatus.active || status == ChallengeStatus.upcoming;

  ChallengeData copyWith({
    String? id,
    String? name,
    String? description,
    int? progress,
    int? maxProgress,
    int? points,
    double? completionRate,
    int? participants,
    int? daysLeft,
    ChallengeType? type,
    ChallengeStatus? status,
    ChallengeDifficulty? difficulty,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    String? createdBy,
    List<String>? tags,
    Map<String, dynamic>? requirements,
    bool? isActive,
  }) {
    return ChallengeData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      maxProgress: maxProgress ?? this.maxProgress,
      points: points ?? this.points,
      completionRate: completionRate ?? this.completionRate,
      participants: participants ?? this.participants,
      daysLeft: daysLeft ?? this.daysLeft,
      type: type ?? this.type,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      tags: tags ?? this.tags,
      requirements: requirements ?? this.requirements,
      isActive: isActive ?? this.isActive,
    );
  }
}
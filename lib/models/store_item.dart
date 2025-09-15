import 'package:cloud_firestore/cloud_firestore.dart';

class StoreItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final String category;
  final String dateRange;
  final int progress;
  final int maxProgress;
  final int maxReward;
  final String status;
  final String tag;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final List<String> participants;

  StoreItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.dateRange,
    required this.progress,
    required this.maxProgress,
    required this.maxReward,
    required this.status,
    required this.tag,
    this.startDate,
    this.endDate,
    this.isActive = true,
    this.participants = const [],
  });

  // Firebase Firestore 연동을 위한 메서드들
  factory StoreItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return StoreItem(
      id: snapshot.id,
      name: data?['name'] ?? '',
      description: data?['description'] ?? '',
      price: data?['price'] ?? 0,
      category: data?['category'] ?? '',
      dateRange: data?['dateRange'] ?? '',
      progress: data?['progress'] ?? 0,
      maxProgress: data?['maxProgress'] ?? 0,
      maxReward: data?['maxReward'] ?? 0,
      status: data?['status'] ?? '',
      tag: data?['tag'] ?? '',
      startDate: data?['startDate']?.toDate(),
      endDate: data?['endDate']?.toDate(),
      isActive: data?['isActive'] ?? true,
      participants: List<String>.from(data?['participants'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'dateRange': dateRange,
      'progress': progress,
      'maxProgress': maxProgress,
      'maxReward': maxReward,
      'status': status,
      'tag': tag,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'isActive': isActive,
      'participants': participants,
    };
  }

  // 편의 메서드들
  double get completionRate => maxProgress > 0 ? progress / maxProgress : 0.0;
  
  bool get isCompleted => progress >= maxProgress;
  
  bool get isLimited => tag == '한정';
  
  bool get isPopular => tag == '인기';

  // copyWith 메서드 (상태 업데이트용)
  StoreItem copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    String? category,
    String? dateRange,
    int? progress,
    int? maxProgress,
    int? maxReward,
    String? status,
    String? tag,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    List<String>? participants,
  }) {
    return StoreItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      dateRange: dateRange ?? this.dateRange,
      progress: progress ?? this.progress,
      maxProgress: maxProgress ?? this.maxProgress,
      maxReward: maxReward ?? this.maxReward,
      status: status ?? this.status,
      tag: tag ?? this.tag,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      participants: participants ?? this.participants,
    );
  }

  @override
  String toString() {
    return 'StoreItem(id: $id, name: $name, price: $price, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StoreItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
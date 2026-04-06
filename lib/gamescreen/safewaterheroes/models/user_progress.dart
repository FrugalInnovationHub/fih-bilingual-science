import 'package:cloud_firestore/cloud_firestore.dart';

class UserProgress {
  final int coins;
  final List<int> completedLessons;
  // Simple flags for game completion badges
  final bool sortingBadged;
  final bool filterBadged;
  final bool adventureBadged;
  // Metadata
  final int schemaVersion;
  final DateTime? createdAt;
  final DateTime? lastActiveAt;

  UserProgress({
    this.coins = 0,
    this.completedLessons = const [],
    this.sortingBadged = false,
    this.filterBadged = false,
    this.adventureBadged = false,
    this.schemaVersion = 1,
    this.createdAt,
    this.lastActiveAt,
  });

  // Factory for initial empty state
  factory UserProgress.initial() => UserProgress(
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );

  UserProgress copyWith({
    int? coins,
    List<int>? completedLessons,
    bool? sortingBadged,
    bool? filterBadged,
    bool? adventureBadged,
    DateTime? lastActiveAt,
  }) {
    return UserProgress(
      coins: coins ?? this.coins,
      completedLessons: completedLessons ?? this.completedLessons,
      sortingBadged: sortingBadged ?? this.sortingBadged,
      filterBadged: filterBadged ?? this.filterBadged,
      adventureBadged: adventureBadged ?? this.adventureBadged,
      schemaVersion: this.schemaVersion,
      createdAt: this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'coins': coins,
      'completedLessons': completedLessons,
      'sortingBadged': sortingBadged,
      'filterBadged': filterBadged,
      'adventureBadged': adventureBadged,
      'schemaVersion': schemaVersion,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'lastActiveAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserProgress.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return UserProgress.initial();

    return UserProgress(
      coins: data['coins'] ?? 0,
      completedLessons: List<int>.from(data['completedLessons'] ?? []),
      sortingBadged: data['sortingBadged'] ?? false,
      filterBadged: data['filterBadged'] ?? false,
      adventureBadged: data['adventureBadged'] ?? false,
      schemaVersion: data['schemaVersion'] ?? 1,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      lastActiveAt: (data['lastActiveAt'] as Timestamp?)?.toDate(),
    );
  }
}
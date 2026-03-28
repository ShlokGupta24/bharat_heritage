import 'package:freezed_annotation/freezed_annotation.dart';

part 'passport_model.freezed.dart';
part 'passport_model.g.dart';

/// A single visit/stamp entry for a monument. Stored in Firestore at:
/// `users/{uid}/passport/{monumentId}`
@freezed
abstract class PassportEntry with _$PassportEntry {
  const factory PassportEntry({
    required String monumentId,
    required String monumentName,
    required DateTime visitedAt,
    String? notes,
  }) = _PassportEntry;

  factory PassportEntry.fromJson(Map<String, dynamic> json) =>
      _$PassportEntryFromJson(json);
}

/// The full user passport: a list of all visited monuments.
class UserPassport {
  final List<PassportEntry> visits;
  final int totalMonuments;

  const UserPassport({required this.visits, required this.totalMonuments});

  int get visitedCount => visits.length;
  double get progressFraction =>
      totalMonuments == 0 ? 0 : visitedCount / totalMonuments;
  int get progressPercent => (progressFraction * 100).round();

  Set<String> get visitedIds => visits.map((e) => e.monumentId).toSet();

  bool hasVisited(String monumentId) => visitedIds.contains(monumentId);

  /// Most recent stamp entry
  PassportEntry? get latestEntry {
    if (visits.isEmpty) return null;
    return visits.reduce((a, b) => a.visitedAt.isAfter(b.visitedAt) ? a : b);
  }
}

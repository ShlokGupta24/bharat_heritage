import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'models/passport_model.dart';

part 'passport_repository.g.dart';

@riverpod
PassportRepository passportRepository(Ref ref) => PassportRepository();

/// Firestore-backed store for user passport stamps.
///
/// Schema:
///   users/{uid}/passport/{monumentId}
///     - monumentId   : String
///     - monumentName : String
///     - visitedAt    : Timestamp
///     - notes        : String? (optional)
class PassportRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _passportCol(String uid) =>
      _db.collection('users').doc(uid).collection('passport');

  /// Real-time stream of all stamps for a user.
  Stream<List<PassportEntry>> watchEntries(String uid) {
    return _passportCol(uid)
        .orderBy('visitedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => PassportEntry.fromJson({
                  ...doc.data(),
                  'visitedAt': (doc.data()['visitedAt'] as Timestamp)
                      .toDate()
                      .toIso8601String(),
                }))
            .toList());
  }

  /// Records a new stamp. Idempotent: uses monumentId as document ID.
  Future<void> recordVisit({
    required String uid,
    required String monumentId,
    required String monumentName,
  }) async {
    final ref = _passportCol(uid).doc(monumentId);
    // Only stamp once — don't overwrite an existing visit.
    final snap = await ref.get();
    if (snap.exists) return;

    await ref.set({
      'monumentId': monumentId,
      'monumentName': monumentName,
      'visitedAt': FieldValue.serverTimestamp(),
      'notes': null,
    });
  }
}

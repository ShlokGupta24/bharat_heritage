import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:bharat_heritage/features/monuments/data/models/monument.dart';
import 'package:bharat_heritage/features/monuments/domain/monuments_provider.dart';
import 'package:bharat_heritage/features/passport/data/models/passport_model.dart';
import 'package:bharat_heritage/features/passport/data/passport_repository.dart';
import 'package:bharat_heritage/features/auth/domain/user_provider.dart';
import 'package:bharat_heritage/features/passport/domain/haversine_provider.dart';

part 'passport_provider.g.dart';

// ---------------------------------------------------------------------------
// Stream all stamps for the currently signed-in user.
// ---------------------------------------------------------------------------
@riverpod
Stream<List<PassportEntry>> passportEntries(Ref ref) async* {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.value;
  if (user == null) {
    yield [];
    return;
  }
  final repo = ref.read(passportRepositoryProvider);
  yield* repo.watchEntries(user.uid);
}

// ---------------------------------------------------------------------------
// Convenience: Set of visited monument IDs (derived from the stream).
// ---------------------------------------------------------------------------
@riverpod
Future<Set<String>> visitedMonumentIds(Ref ref) async {
  final entries = await ref.watch(passportEntriesProvider.future);
  return entries.map((e) => e.monumentId).toSet();
}

// ---------------------------------------------------------------------------
// Full UserPassport object (combines visited list + total monument count).
// ---------------------------------------------------------------------------
@riverpod
Future<UserPassport> userPassport(Ref ref) async {
  final allMonuments = await ref.watch(monumentsProvider.future);
  final entries = await ref.watch(passportEntriesProvider.future);

  return UserPassport(
    visits: entries,
    totalMonuments: allMonuments.length,
  );
}

// ---------------------------------------------------------------------------
// Current device position — single best-effort fix.
// ---------------------------------------------------------------------------
@riverpod
Future<Position?> currentPosition(Ref ref) async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.deniedForever) return null;
  try {
    return await Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.high),
    );
  } catch (_) {
    return null;
  }
}

// ---------------------------------------------------------------------------
// Monument detected within 500 m of the user (null if none).
// ---------------------------------------------------------------------------
@riverpod
Future<Monument?> nearbyMonument(Ref ref) async {
  final position = await ref.watch(currentPositionProvider.future);
  if (position == null) return null;

  final all = await ref.watch(monumentsProvider.future);

  for (final m in all) {
    if (HaversineLogic.isWithin500m(
      position.latitude,
      position.longitude,
      m.coordinates.lat,
      m.coordinates.lon,
    )) {
      return m;
    }
  }
  return null;
}

// ---------------------------------------------------------------------------
// Awards a stamp if the user is near an un-stamped monument.
// Call `ref.read(tryAwardStampProvider)` from the UI.
// ---------------------------------------------------------------------------
@riverpod
Future<String?> tryAwardStamp(Ref ref) async {
  final userAsync = ref.read(currentUserProvider);
  final user = userAsync.value;
  if (user == null) return null;

  final monument = await ref.read(nearbyMonumentProvider.future);
  if (monument == null) return null;

  final visited = await ref.read(visitedMonumentIdsProvider.future);
  if (visited.contains(monument.id)) return null; // Already stamped

  final repo = ref.read(passportRepositoryProvider);
  await repo.recordVisit(
    uid: user.uid,
    monumentId: monument.id,
    monumentName: monument.name,
  );

  return monument.name; // Return name so UI can display a toast
}

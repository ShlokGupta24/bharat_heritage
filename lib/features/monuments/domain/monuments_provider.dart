import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharat_heritage/features/monuments/data/models/monument_repository.dart';
import '../data/models/monument.dart';

part 'monuments_provider.g.dart';

// ---------------------------------------------------------------------------
// Core data provider — fetches all monuments from the UNESCO API
// ---------------------------------------------------------------------------
@riverpod
Future<List<Monument>> monuments(Ref ref) async {
  final repository = ref.watch(monumentsRepositoryProvider);
  return repository.fetchMonuments();
}

// ---------------------------------------------------------------------------
// Monument of the Day — deterministically picks one monument based on the
// day-of-year so it rotates daily and is consistent within the same day.
// ---------------------------------------------------------------------------
@riverpod
Future<Monument?> monumentOfTheDay(Ref ref) async {
  final all = await ref.watch(monumentsProvider.future);
  if (all.isEmpty) return null;

  // Use a numeric date string as seed so it changes every midnight automatically
  final now = DateTime.now();
  final dayOfYear = int.parse(
    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}',
  );
  final index = dayOfYear % all.length;
  return all[index];
}

// ---------------------------------------------------------------------------
// Search query state
// ---------------------------------------------------------------------------
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) => state = query;
}

// ---------------------------------------------------------------------------
// Filtered monuments — derived from monuments + search query
// ---------------------------------------------------------------------------
@riverpod
Future<List<Monument>> filteredMonuments(Ref ref) async {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final all = await ref.watch(monumentsProvider.future);

  if (query.isEmpty) return all;

  return all.where((m) {
    return m.name.toLowerCase().contains(query) ||
        m.shortDescription.toLowerCase().contains(query);
  }).toList();
}

// ---------------------------------------------------------------------------
// Other Expeditions — returns up to 5 monuments excluding monument of the
// day, rotates daily using the same date-based seed
// ---------------------------------------------------------------------------
@riverpod
Future<List<Monument>> otherExpeditions(Ref ref) async {
  final all = await ref.watch(monumentsProvider.future);
  final motd = await ref.watch(monumentOfTheDayProvider.future);

  final others = all.where((m) => m.id != motd?.id).toList();
  if (others.isEmpty) return [];

  final now = DateTime.now();
  final dayOfYear = int.parse(
    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}',
  );

  final startIndex = (dayOfYear * 3) % others.length;
  final result = <Monument>[];
  for (int i = 0; i < 5 && i < others.length; i++) {
    result.add(others[(startIndex + i) % others.length]);
  }
  return result;
}
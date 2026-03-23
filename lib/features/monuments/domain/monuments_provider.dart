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
// Monument of the Day — picks one monument based on the current date,
// so it rotates daily without a network call
// ---------------------------------------------------------------------------
@riverpod
Future<Monument?> monumentOfTheDay(Ref ref) async {
  final all = await ref.watch(monumentsProvider.future);
  if (all.isEmpty) return null;
  final index = DateTime.now().day % all.length;
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
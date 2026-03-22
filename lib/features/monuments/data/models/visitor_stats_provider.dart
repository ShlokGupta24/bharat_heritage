import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharat_heritage/features/monuments/domain/monuments_provider.dart';
import 'package:bharat_heritage/features/monuments/data/models/visitor_stats_repository.dart';
import 'package:bharat_heritage/features/monuments/data/models/visitor_stats.dart';

part 'visitor_stats_provider.g.dart';

// ---------------------------------------------------------------------------
// All stats (cached)
// ---------------------------------------------------------------------------
@riverpod
Future<List<VisitorStats>> allVisitorStats(Ref ref) async {
  final repo = ref.watch(visitorStatsRepositoryProvider);
  return repo.fetchAllStats();
}

// ---------------------------------------------------------------------------
// Stats for monument of the day — fuzzy name match
// ---------------------------------------------------------------------------
@riverpod
Future<VisitorStats?> monumentVisitorStats(Ref ref) async {
  final monument = await ref.watch(monumentOfTheDayProvider.future);
  if (monument == null) return null;

  final allStats = await ref.watch(allVisitorStatsProvider.future);
  if (allStats.isEmpty) return null;

  final searchName = monument.name.toLowerCase();

  // Try progressively looser matches
  VisitorStats? match;

  // 1. Exact match
  match = allStats.cast<VisitorStats?>().firstWhere(
        (s) => s!.monumentName.toLowerCase() == searchName,
    orElse: () => null,
  );

  // 2. Contains match — monument name contains API name or vice versa
  match ??= allStats.cast<VisitorStats?>().firstWhere(
        (s) =>
    searchName.contains(s!.monumentName.toLowerCase()) ||
        s.monumentName.toLowerCase().contains(searchName),
    orElse: () => null,
  );

  // 3. First-word match — e.g. "Taj Mahal" matches "Taj Mahal, Agra"
  if (match == null) {
    final firstWord = searchName.split(' ').first;
    match = allStats.cast<VisitorStats?>().firstWhere(
          (s) => s!.monumentName.toLowerCase().contains(firstWord),
      orElse: () => null,
    );
  }

  return match;
}

// ---------------------------------------------------------------------------
// Crowd curve model
// Generates normalized hourly bar heights (0.0–1.0) from annual visitor data.
// Since the API only has annual totals (not hourly), we model the distribution
// using a realistic bell curve centred around peak hours, scaled by how busy
// the monument is relative to all monuments in the dataset.
// ---------------------------------------------------------------------------
class CrowdCurveData {
  /// Normalized heights for 8 bars: 06:00 08:00 10:00 12:00 14:00 16:00 18:00 20:00
  final List<double> heights;
  final int totalDomestic;
  final int totalForeign;
  final int total;
  final String popularityLabel; // 'Very Popular' | 'Popular' | 'Moderate' | 'Quiet'

  const CrowdCurveData({
    required this.heights,
    required this.totalDomestic,
    required this.totalForeign,
    required this.total,
    required this.popularityLabel,
  });
}

@riverpod
Future<CrowdCurveData> crowdCurve(Ref ref) async {
  final stats = await ref.watch(monumentVisitorStatsProvider.future);
  final allStats = await ref.watch(allVisitorStatsProvider.future);

  // Fallback curve if no match found
  const defaultHeights = [0.15, 0.3, 0.6, 1.0, 0.75, 0.5, 0.35, 0.1];

  if (stats == null) {
    return const CrowdCurveData(
      heights: defaultHeights,
      totalDomestic: 0,
      totalForeign: 0,
      total: 0,
      popularityLabel: 'Unknown',
    );
  }

  final domestic = stats.domesticVisitors ?? 0;
  final foreign = stats.foreignVisitors ?? 0;
  final total = domestic + foreign;

  // Find max total across all monuments for relative scaling
  final maxTotal = allStats
      .map((s) => (s.domesticVisitors ?? 0) + (s.foreignVisitors ?? 0))
      .fold(0, (a, b) => a > b ? a : b);

  // Popularity ratio 0.0–1.0
  final ratio = maxTotal > 0 ? (total / maxTotal).clamp(0.0, 1.0) : 0.5;

  String label;
  if (ratio > 0.7) label = 'Very Popular';
  else if (ratio > 0.4) label = 'Popular';
  else if (ratio > 0.15) label = 'Moderate';
  else label = 'Quiet';

  // Foreign visitor share shifts peak earlier (tourists arrive earlier)
  final foreignShare = total > 0 ? foreign / total : 0.0;

  // Base bell curve centred at index 3 (12:00)
  // foreignShare > 0.3 shifts peak to index 2 (10:00) — tourists arrive early
  final peakIndex = foreignShare > 0.3 ? 2 : 3;

  // Generate a gaussian-ish curve around the peak, scaled by popularity
  final rawHeights = List.generate(8, (i) {
    final dist = (i - peakIndex).abs();
    final base = [1.0, 0.75, 0.5, 0.3, 0.15, 0.08, 0.05, 0.03][dist.clamp(0, 7)];
    // Scale quiet monuments to have a flatter curve
    return base * (0.4 + ratio * 0.6);
  });

  // Normalize so the peak bar is always 1.0
  final peak = rawHeights.reduce((a, b) => a > b ? a : b);
  final normalized = rawHeights.map((h) => h / peak).toList();

  return CrowdCurveData(
    heights: normalized,
    totalDomestic: domestic,
    totalForeign: foreign,
    total: total,
    popularityLabel: label,
  );
}
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bharat_heritage/features/monuments/domain/monuments_provider.dart';
import 'package:bharat_heritage/features/weather//data/aqi_repository.dart';
import 'package:bharat_heritage/features/weather//data/models/aqi_data.dart';

part 'aqi_provider.g.dart';

// Fetches AQI for the Monument of the Day's coordinates
@riverpod
Future<AqiData?> monumentAqi(Ref ref) async {
  final monument = await ref.watch(monumentOfTheDayProvider.future);
  if (monument == null) return null;

  return ref.watch(aqiForCoordinatesProvider(monument.coordinates.lat, monument.coordinates.lon).future);
}

@riverpod
Future<AqiData?> aqiForCoordinates(Ref ref, double lat, double lon) async {
  final repository = ref.watch(aqiRepositoryProvider);
  return repository.fetchAqiData(lat, lon);
}

// Returns a safety message and color category based on AQI avg_value
AqiSafetyInfo getAqiSafetyInfo(String avgValue) {
  final aqi = int.tryParse(avgValue) ?? 0;

  if (aqi <= 50) {
    return AqiSafetyInfo(
      label: 'GOOD',
      message: 'Great day to visit! Air quality is excellent.',
      level: AqiLevel.good,
    );
  } else if (aqi <= 100) {
    return AqiSafetyInfo(
      label: 'MODERATE',
      message: 'Safe to visit. Sensitive visitors may carry a mask.',
      level: AqiLevel.moderate,
    );
  } else if (aqi <= 200) {
    return AqiSafetyInfo(
      label: 'POOR',
      message: 'Limit outdoor exposure. Wear a mask when visiting.',
      level: AqiLevel.poor,
    );
  } else {
    return AqiSafetyInfo(
      label: 'HAZARDOUS',
      message: 'Not recommended to visit outdoors today.',
      level: AqiLevel.hazardous,
    );
  }
}

enum AqiLevel { good, moderate, poor, hazardous }

class AqiSafetyInfo {
  final String label;
  final String message;
  final AqiLevel level;

  const AqiSafetyInfo({
    required this.label,
    required this.message,
    required this.level,
  });
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/aqi_repository.dart';
import '../../monuments/data/models/monument.dart';

class ProcessedAqi {
  final int aqi;
  final String category;
  const ProcessedAqi(this.aqi, this.category);
}

final aqiProvider = FutureProvider.family<ProcessedAqi, Coordinates>((ref, coords) async {
  final repo = ref.watch(aqiRepositoryProvider);
  final data = await repo.fetchAqiData(coords.lat, coords.lon);
  
  if (data == null) {
    return const ProcessedAqi(50, 'GOOD');
  }

  final val = double.tryParse(data.avgValue) ?? 50.0;
  final int aqi = val.round();
  
  String cat;
  if (aqi <= 50) cat = 'GOOD';
  else if (aqi <= 100) cat = 'SATISFACTORY';
  else if (aqi <= 200) cat = 'MODERATE';
  else if (aqi <= 300) cat = 'POOR';
  else if (aqi <= 400) cat = 'VERY POOR';
  else cat = 'SEVERE';

  return ProcessedAqi(aqi, cat);
});
